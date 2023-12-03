package main

import (
	"bufio"
	"os"
	"strconv"
	"unicode"
)

func main() {
	// Read file.
	f, err := os.Open("../input.txt")
	check(err)
	defer f.Close()

	var (
		line    string
		scanner = bufio.NewScanner(f)
		total   int64
	)
	for scanner.Scan() {
		line = scanner.Text()

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
			numStr = string(numStr[0]) + string(numStr[len(numStr)-1])
		}

		i, err := strconv.Atoi(numStr)
		check(err)

		total += int64(i)
	}

	print(total)
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
