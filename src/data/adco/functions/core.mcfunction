from adco:log import log


## Load
function ~/load:
    scoreboard objectives add adco.data dummy

    log "info" "server" "Loaded!"

    execute unless score %installed adco.data matches 1 run function ~/install
    execute if score %installed adco.data matches 1 unless score $version adco.data matches ctx.meta.version run function ~/update


## Install
function ~/load/install:
    scoreboard players set %installed adco.data 1

    scoreboard objectives add 2mal3.debug_mode dummy
    scoreboard objectives add adco.score dummy
    scoreboard objectives setdisplay list adco.score
    scoreboard objectives modify adco.score rendertype integer
    # Set the version in format: xx.xx.xx
    scoreboard players set $version adco.data ctx.meta.version

    # Sent installation message after 4 seconds
    schedule function ~/send_message 4s replace:
        tellraw @a:
            text: f"Installed {ctx.project_name} {ctx.project_version} from {ctx.project_author}!"
            color: "green"


## First Join
function ~/first_join:
    execute store result score .temp_0 adco.data run data get entity @s DataVersion
    execute unless score .temp_0 adco.data matches 3700:
        tellraw @s [
            {"text": "[", "color": "gray"},
            {"text": f"{ctx.project_name}", "color": "red", "bold": true},
            {"text": "]: ", "color": "gray"},
            {
                "text": "You are using the incorrect Minecraft version. Please check the website.",
                "color": "red",
                "bold": true
            }
        ]

    # Unlock advancements that were unlocked before the datapack was installed
    function adco:unlock_previous

advancement ~/first_join {
    "criteria": {
        "requirement": {
            "trigger": "minecraft:tick"
        }
    },
    "rewards": {
        "function": "adco:core/first_join"
    }
}


## Uninstall
function ~/uninstall:
    scoreboard objectives remove adco.data
    scoreboard objectives remove adco.score

    tellraw @a:
        text: f"Uninstalled {ctx.project_name} {ctx.project_version} from {ctx.project_author}!"
        color: "green"

    datapack disable "file/Advancement-Count"
    datapack disable "file/Advancement-Count.zip"
