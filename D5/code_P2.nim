import std/[tables, strutils, times, sequtils, sets]
import npeg, print


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
    let data = readFile("test.txt")

    var temp_CatMap: CatMap
    let parser = peg("input", parse: Parsed):
        input <- "seeds: " * seeds * +"\n" * input_categories
        seeds <- *>(*' ' * +Digit * ' ' * +Digit):
            for v in capture.capList[1 .. capture.capList.high]:
                # print v
                let temp_nums = v.s.strip().split().map(parseInt)
                parse.seeds.add(Seed(start: temp_nums[0], stop: temp_nums[0] + temp_nums[1]))
            echo "Seeds done"
        input_categories <- category * *(+'\n' * category):
            echo "input_categories done"
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


proc apply_mapping(num: int, mapping: CatMap): int =
    for m in mapping.mappings:
        if num >= m.src_start and num < m.src_start + m.range_len:
            return m.dest_start + num - m.src_start
    return num


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
    # var scores: Table[int, int]
    var cur_seeds = data.seeds
    var next_seeds: seq[Seed]

    while cur_str != end_str:
        for m in data.categories.find_mapping(cur_str).mappings:
            echo "<(", m.src_start, ", ", m.src_start + m.range_len, ") -> (", m.dest_start, ", ", m.dest_start + m.range_len, ") {r=", m.range_len,", d=", m.dest_start - m.src_start, "}", ">"
            for s in cur_seeds:
                echo "[", s, "]"
                # Seed starts before mapping
                if s.start < m.src_start:
                    # echo "before"
                    next_seeds.add(Seed(start: s.start, stop: min(s.stop, m.src_start)))
                # Seed starts in mapping 
                if s.start >= m.src_start and s.start <= m.src_start + m.range_len:
                    # echo "in"
                    let shift = m.dest_start - m.src_start
                    next_seeds.add(Seed(start: s.start + shift, stop: min(s.stop + shift, m.src_start + m.range_len + shift)))
                if s.stop > m.src_start + m.range_len:
                    # echo "after"
                    next_seeds.add(Seed(start: max(s.start, m.src_start + m.range_len + 1), stop: s.stop))
        echo cur_str, ": ", cur_seeds, " -> ", next_seeds
        cur_seeds = next_seeds
        next_seeds = @[]
        echo "========="
        cur_str = data.categories.find_mapping(cur_str).dest
    
    # print cur_seeds
    var lowest = cur_seeds[0].start
    for a in cur_seeds:
        if a.start < lowest:
            lowest = a.start
    echo "Part 2: ", lowest
        

                    

    #     var cur_str = "seed"
    #     var cur_num = s
    #     while cur_str != end_str:
    #         let temp = cur_num
    #         let temp_map = data.categories.find_mapping(cur_str)
    #         cur_num = apply_mapping(cur_num, temp_map)
    #         # print cur_str, " -> ", temp_map.dest, " ", temp, " -> ", cur_num
    #         cur_str = temp_map.dest
    #     # let temp_map = data.categories.find_mapping(cur_str)
    #     # cur_num = apply_mapping(cur_num, temp_map)

    #     scores[s] = cur_num
    # # print scores

    # var l_key: int
    # var lowest = int.high
    # for k, v in scores:
    #     if v < lowest:
    #         lowest = v
    #         l_key = k
    
    # echo "Part 1: ", lowest
    # echo "Time taken: ", now() - start, "s"







part2()
