import std/[tables, strutils, times]
import npeg, print


type
    Seed = object
        values: Table[string, int]
    Mapping = object
        src_start, dest_start, range_len: int
    CatMap = object
        src, dest: string
        mappings: seq[Mapping]
    Parsed = object
        seeds: seq[int]
        categories: seq[CatMap]



proc parse_data: Parsed = 
    let data = readFile("input.txt")

    var temp_CatMap: CatMap
    let parser = peg("input", parse: Parsed):
        input <- "seeds: " * seeds * +"\n" * input_categories
        seeds <- seed * *(' ' * seed)
        seed <- >+Digit:
            parse.seeds.add(parseInt($1))
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

    # print result


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


proc part1 =
    let start = now()

    var data = parse_data()

    let end_str = "location"
    var scores: Table[int, int]
    for s in data.seeds:
        var cur_str = "seed"
        var cur_num = s
        while cur_str != end_str:
            let temp = cur_num
            let temp_map = data.categories.find_mapping(cur_str)
            cur_num = apply_mapping(cur_num, temp_map)
            # print cur_str, " -> ", temp_map.dest, " ", temp, " -> ", cur_num
            cur_str = temp_map.dest
        # let temp_map = data.categories.find_mapping(cur_str)
        # cur_num = apply_mapping(cur_num, temp_map)

        scores[s] = cur_num
    # print scores

    var l_key: int
    var lowest = int.high
    for k, v in scores:
        if v < lowest:
            lowest = v
            l_key = k
    
    echo "Part 1: ", lowest
    echo "Time taken: ", now() - start, "s"







part1()
