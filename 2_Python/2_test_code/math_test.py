'''
.. function:: ceil(x)

    Return the ceiling of *x* as a float, the smallest integer value greater than or
    equal to *x*.

.. function:: fabs(x)

    Return the absolute value of *x*.

.. function:: floor(x)

    Return the floor of *x* as a float, the largest integer value less than or equal
    to *x*.

.. function:: modf(x)

    Return the fractional and integer parts of *x*.  Both results carry the sign
    of *x* and are floats.
'''

import math

res = math.sqrt(2)
print res
print math.ceil(res)
print math.floor(res)
print math.modf(res)
print math.fabs(1), math.fabs(-1.1)




