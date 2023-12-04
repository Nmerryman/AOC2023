import std/[strutils, times, sets, math, sequtils]


type
    Coordinate = object
        x, y: int

    Number = object
        value: string
        start, stop: Coordinate
    
    Symbol = object
        value: char
        location: Coordinate


proc buildTouching(num: Number): seq[Coordinate] =
    for x in num.start.x - 1 .. num.stop.x + 1:
        for y in num.start.y - 1 .. num.stop.y + 1:
            result.add(Coordinate(x: x, y: y))


proc buildTouching(sym: Symbol): seq[Coordinate] =
    for x in sym.location.x - 1 .. sym.location.x + 1:
        for y in sym.location.y - 1 .. sym.location.y + 1:
            result.add(Coordinate(x: x, y: y))

proc touches(number: Number, coordinate: Coordinate): bool = number.start.y == coordinate.y and number.start.x <= coordinate.x and number.stop.x >= coordinate.x

proc parseData: (seq[Number], seq[Symbol]) =
    var numbers: seq[Number]
    var symbols: seq[Symbol]

    var line_index = 0
    for line in lines("input.txt"):
        var cur_num: Number
        for i, c in line:
            if c.isDigit:
                # If we have a number, start adding to the number object
                if cur_num.value == "":
                    cur_num.start = Coordinate(x: i, y: line_index)
                cur_num.value &= c
            else:
                # Save what we currently have (If we have anything)
                if cur_num.value != "":
                    cur_num.stop = Coordinate(x: i - 1, y: line_index)
                    numbers.add(cur_num)
                    reset(cur_num)
                # If it's a symbol we save it
                if c != '.':
                    symbols.add(Symbol(value: c, location: Coordinate(x: i, y: line_index)))
        # Account for anything on the edge
        if cur_num.value != "":
            cur_num.stop = Coordinate(x: line.high, y: line_index)
            numbers.add(cur_num)
            reset(cur_num)
        
        line_index += 1
    
    return (numbers, symbols)


proc part1 =
    # 552638 -> too low (Forgot lines that end with numbers)

    let start = now()

    var (numbers, symbols) = parseData()

    # In order to avoid dupes I'm going number -> symbol
    var sum_num: int = 0
    for num in numbers:
        block num_test:
            for test in num.buildTouching:
                for sym in symbols:
                    if sym.location.x == test.x and sym.location.y == test.y:
                        sum_num += parseInt(num.value)
                        break num_test
    
    # echo numbers
    # echo "------"
    # echo symbols

    echo "Value: ", sum_num
    echo "Done in: ", now() - start
    

proc part2 =
    # 2470928 -> too low
    let start = now()

    var (numbers, symbols) = parseData()

    var sum_num: int
    for sym in symbols:
        if sym.value == '*':
            var matches = initHashSet[Number]()
            for touching in sym.buildTouching:      # Get ring of coordinates the symbol touches
                for num in numbers:                 # For every known number
                    if num.touches(touching):       # Test coordinate touches a number
                        # echo "hit"
                        matches.incl(num)
            # echo matches
            if matches.len == 2:
                let nums = toSeq(matches)
                sum_num += nums[0].value.parseInt * nums[1].value.parseInt
    
    echo "Value: ", sum_num
    echo "Done in: ", now() - start


# part1()
part2()
