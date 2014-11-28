package main

import (
	"fmt"
	"strconv"
)

func main() {
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
