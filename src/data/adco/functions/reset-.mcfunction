
advancement revoke @a everything

scoreboard objectives remove adco.score
scoreboard objectives add adco.score dummy
scoreboard objectives setdisplay list adco.score

tellraw @s:
    text: "Reset all Advancements"
    color: "gold"
