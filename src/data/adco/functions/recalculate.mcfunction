from 2mal3:log import log
from beet.contrib.vanilla import Vanilla

log "debug" "@s" "Recalculating points"

scoreboard players set .temp adco.data 0


# Count the points for each unlocked advancement
vanilla = ctx.inject(Vanilla)
vanilla_advancements = vanilla.releases["1.21"].data.advancements
for name, advancement in vanilla_advancements.items():
    if "recipes" in name:   # Skip recipe unlocking advancements
        continue

    # Create a predicate for the advancement to test if it has been unlocked
    predicate_name = name.split(":")[1].replace("/", "_")
    predicate_content = {
        "condition": "minecraft:entity_properties",
        "entity": "this",
        "predicate": {
            "type_specific": {
                "type": "player",
                "advancements": {}
            }
        }
    }
    predicate_content["predicate"]["type_specific"]["advancements"][name] = true
    predicate f"adco:unlock_previous/{predicate_name}" predicate_content

    # Give the corresponding points to all players that have unlocked the advancement
    advancement_content = advancement.data
    advancement_display = advancement_content["display"]
    if "frame" not in advancement_display or advancement_display["frame"] == "task":
        execute if predicate f"adco:unlock_previous/{predicate_name}" run scoreboard players add .temp adco.data 1
    elif advancement_display["frame"] == "goal":
        execute if predicate f"adco:unlock_previous/{predicate_name}" run scoreboard players add .temp adco.data 2
    elif advancement_display["frame"] == "challenge":
        execute if predicate f"adco:unlock_previous/{predicate_name}" run scoreboard players add .temp adco.data 5

# Get the player name
# 386f2fa2-430d-4c4c-aca1-85eaadcb3019
summon armor_stand ~ ~ ~ \
    {UUID:[I;946810786,1124944972,-1398700566,-1379192807],Marker:1b,Invisible:1b}
loot replace entity 386f2fa2-430d-4c4c-aca1-85eaadcb3019 armor.head loot \
    {"pools":[{"rolls":1,"entries":[{"type":"minecraft:item","name":"minecraft:player_head","functions":[{"function":"minecraft:fill_player_head","entity":"this"}]}]}]}
data modify storage adco:data root.temp set from entity 386f2fa2-430d-4c4c-aca1-85eaadcb3019 ArmorItems[3].components."minecraft:profile".name
kill 386f2fa2-430d-4c4c-aca1-85eaadcb3019

# Store the calculated points with the player name in the data storage
data modify storage adco:data root.uuid set from entity @s UUID
execute with storage adco:data root:
    $execute unless data storage adco:data root.players[{uuid: $(uuid)}] run function adco:recalculate/init_player

    $execute store result storage adco:data root.players[{uuid: $(uuid)}].points int 1 run scoreboard players get .temp adco.data
    $data modify storage adco:data root.players[{uuid: $(uuid)}].name set from storage adco:data root.temp

function ~/init_player:
    data modify storage adco:data root.players append value {}
    data modify storage adco:data root.players[-1].uuid set from storage adco:data root.uuid

# Render the points
scoreboard players reset * adco.score
data modify storage adco:data root.temp set from storage adco:data root.players
function ~/render_loop
function ~/render_loop:
    execute with storage adco:data root.temp[-1]:
        $scoreboard players set $(name) adco.score $(points)

    data remove storage adco:data root.temp[-1]
    execute if data storage adco:data root.temp[] run function ~/
