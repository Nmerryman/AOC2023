import npeg


proc main =
    let parser = peg("input"):
        input <- >+Print * Space * >+Print:
            echo $1, $2
    
    echo parser.match("testing\nuhh").ok


main()
