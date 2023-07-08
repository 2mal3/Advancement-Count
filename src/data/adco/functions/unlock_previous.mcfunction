from beet.contrib.vanilla import Vanilla


vanilla_advancements = ctx.inject(Vanilla).mount("data/minecraft/advancements").data.advancements
for name, advancement in vanilla_advancements.items():
    if "recipes" in name:   # Skip recipe unlocking advancements
        continue

    # Create a predicate for the advancement to test if it has been unlocked
    predicate_name = name.split(":")[1].replace("/", "-")
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
    if advancement_content["display"]["frame"] == "task":
        execute if predicate f"adco:unlock_previous/{predicate_name}" run function adco:count/1
    if advancement_content["display"]["frame"] == "goal":
        execute if predicate f"adco:unlock_previous/{predicate_name}" run function adco:count/2
    if advancement_content["display"]["frame"] == "challenge":
        execute if predicate f"adco:unlock_previous/{predicate_name}" run function adco:count/5
