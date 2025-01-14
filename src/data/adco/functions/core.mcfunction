from 2mal3:log import log


## Load
function ~/load:
    scoreboard objectives add adco.data dummy

    log "info" "server" "Loaded!"

    execute unless score %installed adco.data matches 1 run function ~/install
    execute if score %installed adco.data matches 1 unless score $version adco.data matches ctx.meta.version run function ~/update

    scoreboard players add %latest adco.recalculate_version 1


## Install
function ~/load/install:
    scoreboard players set %installed adco.data 1

    scoreboard objectives add 2mal3.debug_mode dummy
    scoreboard objectives add adco.score dummy
    scoreboard objectives setdisplay list adco.score
    scoreboard objectives modify adco.score rendertype integer
    scoreboard objectives add adco.recalculate_version dummy
    # Set the version in format: xx.xx.xx
    scoreboard players set $version adco.data ctx.meta.version

    # Sent installation message after 4 seconds
    schedule function ~/send_message 4s replace:
        tellraw @a:
            text: f"Installed {ctx.project_name} {ctx.project_version} from {ctx.project_author}!"
            color: "green"


## Update
function ~/update:
    execute if score $version adco.data matches 10100:
        scoreboard players set $version adco.data 10101
        log "info" "server" "Updated to 1.0.1"

    execute if score $version adco.data matches 10101:
        scoreboard players set $version adco.data 10102
        log "info" "server" "Updated to 1.1.2"

    execute if score $version adco.data matches 10102:
        scoreboard players set $version adco.data 10103
        log "info" "server" "Updated to 1.1.3"

    execute if score $version adco.data matches 10103:
        scoreboard players set $version adco.data 10104
        log "info" "server" "Updated to 1.1.4"

    execute if score $version adco.data matches 10104:
        scoreboard players set $version adco.data 10200
        log "info" "server" "Updated to 1.2.0"


## Uninstall
function ~/uninstall:
    scoreboard objectives remove adco.data
    scoreboard objectives remove adco.score
    scoreboard objectives remove adco.recalculate_version

    tellraw @a:
        text: f"Uninstalled {ctx.project_name} {ctx.project_version} from {ctx.project_author}!"
        color: "green"

    project_file_name = ctx.project_name.replace(' ', '-')
    datapack disable f"file/{project_file_name}"
    datapack disable f"file/{project_file_name}.zip"
