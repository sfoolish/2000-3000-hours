package main

// http://legendtkl.com/2016/03/11/go-log/
// https://golang.org/pkg/log
// https://github.com/golang-samples/log/blob/master/log_format/main.go

import (
	"io"
	"log"
	"os"
)

var (
	Info    *log.Logger
	Warning *log.Logger
	Error   *log.Logger
)

func Init(infoHandle io.Writer,
	warningHandle io.Writer,
	errorHandle io.Writer) {

	Info = log.New(infoHandle,
		"[  INFO   ] ",
		log.Ldate|log.Ltime|log.Lshortfile)

	Warning = log.New(warningHandle,
		"[ WARNING ] ",
		log.Ldate|log.Ltime|log.Lmicroseconds|log.Llongfile)

	Error = log.New(errorHandle,
		"[  ERROR  ] ",
		log.Ldate|log.Ltime|log.Lshortfile)
}

func main() {
	Init(os.Stdout, os.Stdout, os.Stderr)

	Info.Println("Special Information")
	Warning.Println("There is something you need to know about")
	Error.Println("Something has failed")
}
