
## Load
function ./load:
    scoreboard objectives add adco.data dummy

    execute unless score %installed adco.data matches 1 run function ./install
    execute if score %installed adco.data matches 1 unless score $version adco.data matches ctx.meta.version run function ./update

function_tag minecraft:load:
    values:
        - "adco:core/load"


## Install
function ./install:
    scoreboard players set %installed adco.data 1

    scoreboard objectives add adco.score dummy
    scoreboard objectives setdisplay list adco.score
    # Set the version in format: xx.xx.xx
    scoreboard players set $version adco.data ctx.meta.version

    # Sent installation message after 4 seconds
    schedule function ./send_message 4s replace:
        tellraw @a:
            text: f"Installed {ctx.project_name} {ctx.project_version} from {ctx.project_author}!"
            color: "green"


## Uninstall
function ./uninstall:
    scoreboard objectives remove adco.data
    scoreboard objectives remove adco.score

    tellraw @a:
        text: f"Uninstalled {ctx.project_name} {ctx.project_version} from {ctx.project_author}!"
        color: "green"

    datapack disable "file/Advancement-Count"
    datapack disable "file/Advancement-Count.zip"
