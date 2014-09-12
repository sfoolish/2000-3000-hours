package mymath

import (
	"fmt"
)

func Sqrt(x float64) float64 {
	z := 0.0
	for i := 0; i < 1000; i++ {
		z -= (z*z - x) / (2 * x)
	}
	return z
}

func PrintComplex() {
	val := 1 + 2i
	fmt.Printf("Complex value is: %v \n", val)
}
