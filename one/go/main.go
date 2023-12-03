package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"unicode"
)

const (
	inputFile = "input.txt"
)

func main() {
	partOne()
}

func partOne() {
	var total int64
	fn := func(line string) {
		var numStr string
		for i := 0; i < len(line); i++ {
			if !isInt(string(line[i])) {
				continue
			}

			numStr += string(line[i])
		}

		switch len(numStr) {
		case 1:
			numStr += numStr
		case 2:
		default:
			numStr = string(numStr[0]) +
				string(numStr[len(numStr)-1])
		}

		i, err := strconv.Atoi(numStr)
		check(err)

		total += int64(i)
	}

	forEachLine(fn)

	print(total)
}

func forEachLine(fn func(string)) {
	f, err := os.Open(fmt.Sprintf("../%s", inputFile))
	check(err)
	defer f.Close()

	var (
		line    string
		scanner = bufio.NewScanner(f)
	)
	for scanner.Scan() {
		line = scanner.Text()

		fn(line)

	}
}

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func isInt(s string) bool {
	for _, c := range s {
		if !unicode.IsDigit(c) {
			return false
		}
	}
	return true
}
