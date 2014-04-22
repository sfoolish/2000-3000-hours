# [Largest prime factor](http://projecteuler.net/problem=3)

import math

def prime_factor(m):
    return [i for i in xrange(2, 1 + int(math.floor(math.sqrt(m)))) \
            if (m % i == 0)]

def is_prime(n):
    return len(prime_factor(n)) == 0

def largest_prime_factor(m):
    prime_list = prime_factor(m)
    prime_list2 = filter(lambda x: len(prime_factor(x)) == 0, prime_list)
    prime_list2.sort()
    return prime_list2[len(prime_list2) - 1]

print largest_prime_factor(600851475143)