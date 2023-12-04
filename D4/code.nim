import std/[strutils, math, times, sequtils]


proc part1 =
    let start = now()

    var sum_score: int 
    for line in lines("input.txt"):
        let line_parts = line.split(": ")
        let (card, card_nums) = (line_parts[0], line_parts[1])
        let temp_num = card_nums.split(" | ")
        var winning = temp_num[0].splitWhitespace()
        var owned = temp_num[1].splitWhitespace()
        
        # echo winning
        # echo owned

        var win_count: int
        for w in winning:
            if w in owned:
                win_count += 1
        
        # echo win_count
        if win_count > 0:
            sum_score += 2 ^ (win_count - 1)
    
    echo "Value: ", sum_score
    echo "Done in: ", now() - start


proc part2 =
    let start = now()

    var sum_score: seq[int] = @[1]
    for i, line in lines("input.txt").toSeq:
        let line_parts = line.split(": ")
        let (card, card_nums) = (line_parts[0], line_parts[1])
        let temp_num = card_nums.split(" | ")
        var winning = temp_num[0].splitWhitespace()
        var owned = temp_num[1].splitWhitespace()
        
        # echo winning
        # echo owned

        var win_count: int
        for w in winning:
            if w in owned:
                win_count += 1
        
        for a in 1 .. win_count:
            while i + win_count > sum_score.high:
                sum_score.add(1)
            sum_score[i + a] += sum_score[i]
        
        if i > sum_score.high:
            sum_score.add(1)

        # echo sum_score
        
    
    echo "Value: ", sum(sum_score)
    echo "Done in: ", now() - start





# part1()
part2()
