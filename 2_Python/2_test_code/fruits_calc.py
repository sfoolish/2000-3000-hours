#!/usr/bin/env python
# -*- coding: utf-8 -*-

class Fruit(object):
    def __init__(self, name, price = 0, discount = 1.0):
        if price < 0:
        	price = 0
        if discount > 1.0 or discount <= 0 :
        	discount = 1.0
        
        self.name = name
        self.original_price = price
        self.discount = discount

    @property
    def current_price(self):
    	return self.original_price * self.discount

if __name__ == '__main__':
	apple = Fruit('apple', 1, 0.9)
	orange = Fruit('orange', 2, 0.8)

	print 3 * apple.current_price + 4 * orange.current_price

