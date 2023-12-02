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


proc getNumber(s: string): int =
    let numbers = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
    var first: int 
    var last: int
    var first_found = false
    for i, v in s:
        if v.isDigit:
            if not first_found:
                first_found = true
                first = parseInt($v)
            last = parseInt($v)

        for n in numbers:
            if i + n.high <= s.high and s[i .. i + n.high] == n:
                if not first_found:
                    first_found = true
                    first = numbers.find(n)

                last = numbers.find(n)
    
    return first * 10 + last



proc part2 =
    var nums: seq[int]
    for line in lines("input.txt"):
        nums.add(getNumber(line))
    echo sum(nums)



# part1()
part2()
