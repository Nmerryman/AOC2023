import std/[tables, strutils, times, sequtils, sets]
import npeg


type
    Seed = object
        start, stop: int
    Mapping = object
        src_start, dest_start, range_len: int
    CatMap = object
        src, dest: string
        mappings: seq[Mapping]
    Parsed = object
        seeds: seq[Seed]
        categories: seq[CatMap]



proc parse_data: Parsed = 
    let data = readFile("input.txt")

    var temp_CatMap: CatMap
    let parser = peg("input", parse: Parsed):
        input <- "seeds: " * seeds * +"\n" * input_categories
        seeds <- *>(*' ' * +Digit * ' ' * +Digit):
            for v in capture.capList[1 .. capture.capList.high]:
                let temp_nums = v.s.strip().split().map(parseInt)
                parse.seeds.add(Seed(start: temp_nums[0], stop: temp_nums[0] + temp_nums[1]))
        input_categories <- category * *(+'\n' * category)
        category <- desc * " map:" * *(+'\n' * map_line):
            parse.categories.add(temp_CatMap)
            reset(temp_CatMap)
        desc <- >+Alpha * "-to-" * >+Alpha:
            temp_CatMap.src = $1
            temp_CatMap.dest = $2
        map_line <- >+Digit * " " * >+Digit * " " * >+Digit:
            temp_CatMap.mappings.add(Mapping(src_start: parseInt($2), dest_start: parseInt($1), range_len: parseInt($3)))
    assert parser.match(data, result).ok

    # echo result.seeds
    # echo result.categories
    # echo "-----"


proc find_mapping(mappings: seq[CatMap], name: string): CatMap =
    for m in mappings:
        if m.src == name:
            return m
    raise newException(Exception, "No mapping found for " & name)


proc part2 =
    let start = now()

    var data = parse_data()
    echo "parsed"

    let end_str = "location"
    var cur_str = "seed"
    var cur_seeds = data.seeds
    var next_seeds: seq[Seed]

    while cur_str != end_str:
        
        # Crop out what we can
        for m in data.categories.find_mapping(cur_str).mappings:  # Current mapping
            # echo "(", m.src_start, ", ", m.src_start + m.range_len - 1, ") + ", m.dest_start - m.src_start, " = (", m.dest_start, ", ", m.dest_start + m.range_len - 1, ")"
            # echo "starting: ", cur_seeds

            let shift = m.dest_start - m.src_start
            # Unmodified seeds that may still be proccessed in later transformations
            var temp_seeds: seq[Seed]
            for s in cur_seeds:  # Current seed
                if s.stop < m.src_start or s.start > m.src_start + m.range_len - 1:  # No overlap
                    temp_seeds.add(s)
                else:    
                    # Unchanged seed parts
                    if s.start < m.src_start:
                        temp_seeds.add(Seed(start: s.start, stop: m.src_start - 1))
                    if s.stop > m.src_start + m.range_len - 1:
                        temp_seeds.add(Seed(start: m.src_start + m.range_len, stop: s.stop))
                    # Seed parts that are modified get moved to the next stage
                    next_seeds.add(Seed(start: max(s.start, m.src_start) + shift, stop: min(s.stop, m.src_start + m.range_len - 1) + shift))
            # echo "temp: ", temp_seeds
            # echo "next: ", next_seeds
            cur_seeds = temp_seeds
        
        for a in next_seeds:
            cur_seeds.add(a)

        next_seeds.reset()
        cur_str = data.categories.find_mapping(cur_str).dest
                    
    # print cur_seeds
    var lowest = cur_seeds[0].start
    for a in cur_seeds:
        if a.start < lowest:
            lowest = a.start
    echo "Part 2: ", lowest
    echo "Time taken: ", now() - start
        


part2()
