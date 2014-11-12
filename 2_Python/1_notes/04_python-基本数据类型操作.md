## tuple

In [2]: a = (1)
In [3]: a
Out[3]: 1
In [6]: type(a)
Out[6]: int
In [7]: a = ([1])
In [8]: a
Out[8]: [1]
In [9]: type(a)
Out[9]: list


In [1]: a = [[1, 2]]
In [2]: tuple(a)
Out[2]: ([1, 2],)
In [3]: a=[1,2]
In [4]: tuple(a)
Out[4]: (1, 2)

## list

In [5]: options = ['o', 'd']
In [6]: ['-%s' % o for o in options]
Out[6]: ['-o', '-d']


In [7]: a = [1, 2]
In [8]: a = a + [3, 4]
In [9]: a
Out[9]: [1, 2, 3, 4]

In [23]: a = [1, 2]
In [24]: a.extend([3, 4])
In [25]: a
Out[25]: [1, 2, 3, 4]

In [11]: ''.join(['1', '2'])
Out[11]: '12'

In [15]: a = 1
In [16]: b = 2
In [18]: ''.join([str(a), str(b)])
Out[18]: '12'

## set

In [1]: a = set([1, 3, 3, 3])

In [2]: a
Out[2]: {1, 3}

In [3]: b = set((3, 4, 5))

In [4]: a -b
Out[4]: {1}

In [5]: b -a
Out[5]: {4, 5}

In [6]: b
Out[6]: {3, 4, 5}
