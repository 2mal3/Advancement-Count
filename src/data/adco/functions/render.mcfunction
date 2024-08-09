scoreboard players reset * adco.score
data modify storage adco:data root.temp set from storage adco:data root.players
function ~/render_loop
function ~/render_loop:
    execute with storage adco:data root.temp[-1]:
        $scoreboard players set $(name) adco.score $(points)

    data remove storage adco:data root.temp[-1]
    execute if data storage adco:data root.temp[] run function ~/
