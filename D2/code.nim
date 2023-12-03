import std/[strscans, strutils, times, math]

type 
    Color = enum
        red, green, blue

proc part1 =
    let start = now()
    const colors: array[Color, int] = [12, 13, 14]

    var id: int
    var games: string

    var game_sum = 0
    for line in lines("input.txt"):
        if scanf(line, "Game $i: $+", id, games):
            block game_loop:
                for round in games.split("; "):
                    for cube in round.split(", "):
                        # echo cube.split(' ')
                        let num = cube.split(' ')[0].parseInt
                        let color = cube.split(' ')[1]
                        if num > colors[parseEnum[Color](color)]:
                            break game_loop
                game_sum += id
    echo "Part 1: ", game_sum
    echo "Done in : ", now() - start,"s"


proc part2 =
    let start = now()

    var id: int
    var games: string

    var mins: array[Color, int]

    var game_sum = 0
    for line in lines("input.txt"):
        if scanf(line, "Game $i: $+", id, games):
            mins = [0, 0, 0]
            for round in games.split("; "):
                for cube in round.split(", "):
                    # echo cube.split(' ')
                    let num = cube.split(' ')[0].parseInt
                    let color = parseEnum[Color](cube.split(' ')[1])
                    if num > mins[color]:
                        mins[color] = num
            # echo mins
            game_sum += prod(mins)
    echo "Part 2: ", game_sum
    echo "Done in : ", now() - start,"s"





part1()
part2()
