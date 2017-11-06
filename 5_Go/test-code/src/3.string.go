package main

import (
	"fmt"
	"strconv"
)

// http://nanxiao.me/golang-string-byte-slice-conversion/
// test string byte convert

func testStringByte() {
	out := make([]byte, 0)
	data := "abcd"
	output := fmt.Sprintf("%v", "test")
	fmt.Println(output)
	for _, i := range []byte((fmt.Sprintf("%v", "test"))) {
		out = append(out, i)
	}
	out = append(out, '@')
	fmt.Printf("%v\n", string(out))
	fmt.Println(len(data), data)
}

func testNumPrint() {
	out := make([]byte, 0)
	for i := 0; i < 15; i++ {
		x := fmt.Sprintf("%d", i)
		for _, i := range []byte(x) {
			out = append(out, i)
		}
		out = append(out, '\t')
	}
	fmt.Printf("%v\n", string(out))
}

func testStringConv() {
	result := []string{}
	result = append(result, "hello")
	result = append(result, "world")

	fmt.Printf("result %v \n", result)

	//result_int := new([3]int)
	result_int := make([]int, 0, 2)
	result_int = append(result_int, 1)
	result_int = append(result_int, 2)
	fmt.Printf("result_int %v \n", result_int)

	value := "False"
	ret, err := strconv.ParseBool(value)
	fmt.Printf("result_int %v %v \n", ret, err)

	fmt.Printf("data %q: %s \n", "hello", "world")
}

func main() {
	testStringByte()
	testNumPrint()
	testStringConv()
}
