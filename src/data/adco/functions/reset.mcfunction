
advancement revoke @a everything

scoreboard objectives remove adco.score
scoreboard objectives add adco.score dummy
scoreboard objectives setdisplay list adco.score
scoreboard objectives modify adco.score rendertype integer

tellraw @s:
    text: "Reset all Advancements for all current players"
    color: "gold"
