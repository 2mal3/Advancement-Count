from beet.contrib.vanilla import Vanilla


# Cenarios:
# player that has installed datapack to an existing world want to get its advancements tracked -> data version does not match, since new player has no score -> update
# player that has changed its name want to maintain its advancement count



function ~/tick:
    schedule function ~/ 1s replace
    execute as @a unless score @s adco.recalculate_version = %latest adco.recalculate_version:
        scoreboard players operation @s adco.recalculate_version = %latest adco.recalculate_version
        function adco:recalculate/player


function ~/player:
    scoreboard players reset @s adco.score

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
            execute if predicate f"adco:unlock_previous/{predicate_name}" run function adco:count/1
        elif advancement_display["frame"] == "goal":
            execute if predicate f"adco:unlock_previous/{predicate_name}" run function adco:count/2
        elif advancement_display["frame"] == "challenge":
            execute if predicate f"adco:unlock_previous/{predicate_name}" run function adco:count/5
