#!/usr/bin/env python

# [Parsing values from a JSON file in Python](http://stackoverflow.com/questions/2835559/parsing-values-from-a-json-file-in-python)

import json
from pprint import pprint
import os

def save_user_info(url, usr, passwd):
	info = {"url": url, "usr":usr, "passwd":passwd}
	file = open("tmp", "w")
	file.write(json.dumps(info))
	file.close()

def load_user_info():
	file = open("tmp")
	json_data = file.read()
	data = json.loads(json_data)
	pprint(data)
	file.close()

def load():
	with open("tmp") as file:
		data = json.load(file)
		print type(data)
		pprint(data)

def rmv_tmp_file():
	if os.path.exists('tmp'):
		print "remove tmp file"
		os.remove("tmp")

save_user_info("abc", "user-name", ["passwd", "abc", "ABC"])
load_user_info()
load()
rmv_tmp_file()

