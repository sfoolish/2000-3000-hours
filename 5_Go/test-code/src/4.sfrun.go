package main

import (
	"encoding/json"
	"fmt"
	"runtime"
	"strconv"
	"strings"
)

func sfTrimPrefix() {
	var s = "Goodbye,, world!"
	s = strings.TrimPrefix(s, "Goodbye,")
	s = strings.TrimPrefix(s, "Howdy,")
	fmt.Println("Hello" + s)
}

func sfAtoi() {
	if i, err := strconv.Atoi("123"); err == nil {
		fmt.Printf("%d", i)
	} else {
		fmt.Println("error")
	}
	fmt.Println("")
}

func sfgoHello() {
	for i := 0; i < 3; i++ {
		fmt.Println("hello")
		runtime.Gosched()
	}
}

func sfgoWorld() {
	for i := 0; i < 3; i++ {
		fmt.Println("world")
		runtime.Gosched()
	}
}

func sfCofMaxProcs() {
	old := runtime.GOMAXPROCS(8)
	fmt.Println(old)
}

func sum(a []int, c chan int) {
	total := 0
	for _, i := range a {
		total += i
	}
	c <- total
}

func sfTestSum() {
	data := []int{1, 2, 3, 4, 5, -1, -2, -3, -4, -5}

	c := make(chan int)
	go sum(data[:len(data)/2], c)
	go sum(data[len(data)/2:], c)
	x, y := <-c, <-c

	fmt.Println(x, y, x+y)
}

func sfTestBufChan() {
	c := make(chan int, 2)
	c <- 4
	c <- 5
	x, y := <-c, <-c
	fmt.Println(x, y)
}

var errors = map[int]string{
	// command related errors
	EcodeKeyNotFound: "Key not found",
	EcodeTestFailed:  "Compare failed", //test and set
	EcodeNotFile:     "Not a file",
}

const (
	EcodeKeyNotFound = 100
	EcodeTestFailed  = 101
	EcodeNotFile     = 102
)

type Error struct {
	ErrorCode int    `json:errorCode`
	Message   string `json:message`
	Cause     string `json:cause`
	Index     uint64 `json:index`
}

func NewError(errorCode int, cause string, index uint64) *Error {
	return &Error{
		ErrorCode: errorCode,
		Message:   errors[errorCode],
		Cause:     cause,
		Index:     index,
	}
}

func (e Error) toJsonString() string {
	b, _ := json.Marshal(e)
	return string(b)
}

func sfTestJson() {
	error := NewError(EcodeKeyNotFound, "Not Exist", 10000)
	fmt.Println(error.toJsonString)
}

func main() {
//	fmt.Println("hello")
//	sfTrimPrefix()
//	sfAtoi()
//	go sfgoHello()
//	go sfgoWorld()
	sfCofMaxProcs()
	sfCofMaxProcs()
//	sfTestSum()
//	sfTestBufChan()
//	sfTestJson()
//	time.Sleep(100 * time.Millisecond)
}
