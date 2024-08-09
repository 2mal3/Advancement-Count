
advancement revoke @a everything
data modify storage adco:data root.players set value []

function adco:render

tellraw @s:
    text: "Reset all Advancements for all current players"
    color: "gold"
