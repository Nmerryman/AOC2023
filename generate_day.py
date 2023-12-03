import os
import sys


def main():
    if len(sys.argv) != 2:
        print("Only expecting folder name.")
        quit(1)
    
    target = sys.argv[1]
    if not os.path.exists(target):
        os.mkdir(target)
    
    os.chdir(target)

    open("code.nim", 'a').close()
    open("test.txt", 'a').close()
    open("input.txt", 'a').close()


if __name__ == "__main__":
    main()
