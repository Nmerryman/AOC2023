import std/[strutils, algorithm, math]

proc firstDigit(s: string | seq[char]): char =
    for c in s:
        if c.isDigit:
            return c

proc part1 =
    var nums: seq[int]
    for line in lines("input.txt"):
        var x: char = firstDigit(line)
        var y: char = firstDigit(line.reversed)
        nums.add(parseInt(x & y))
    echo sum(nums)


part1()
