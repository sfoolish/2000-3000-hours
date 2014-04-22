
# functions the usual way VS the lambda way
# the lambda syntax `lambda [parameter_list]: expression`
#
# syntatic lambda limitations:
#     can not contain statements
#     can not contain loops
#     limited to a singal expression
#
# putting lambda to use
#      use lambda to avoid unnecessary code copying
#      useful for setting up simpole tasks
def f_usual(x):
    return x * 2

f_lambda = lambda x: x * 2

assert f_usual(1000) == f_lambda(1000)

# map filter and reduce
assert map(lambda x: x ** 2, range(1, 5)) == [1, 4, 9, 16]
assert filter(lambda x: x % 2 == 0, range(10)) == [0, 2, 4, 6, 8]
assert reduce(lambda x, y: x + y, range(10)) == 45

def is_prime(n):
    return len(filter(lambda x: n % x == 0, range(2, n))) == 0

def primes(m):
    return filter(is_prime, range(1, m))

def is_prime_third(n):
    return not any(n % k == 0 for k in xrange(2, n))

def primes_third(m):
    return [n for n in xrange(1, m) if is_prime_third(n)]

assert primes(1000) == primes_third(1000)


## eliminating if based on short circuit
pr = lambda s: s
namenum = lambda x: (x == 0 and pr('zero')) \
                 or (x == 1 and pr('one'))  \
                 or (pr('other'))

assert namenum(0) == 'zero'
assert namenum(1) == 'one'
assert namenum(2) == 'other'

## elimiting while statement based on short circuit
range_sum = lambda x: (x == 1 and x) \
             or (range_sum(x - 1) + x)
assert range_sum(10) == 55

res = [(x, y) for x in (1, 3, 5, 7) for y in (2, 4, 6, 8) if x * y > 25]
assert res == [(5, 6), (5, 8), (7, 4), (7, 6), (7, 8)]

# closure
def counter(start=0, step=1):
    x = [start]
    def _inc():
        x[0] += step
        return x[0]
    return _inc

c1 = counter()
assert c1() == 1
assert c1() == 2
c2 = counter(100, -10)
assert c2() == 90
assert c2() == 80

