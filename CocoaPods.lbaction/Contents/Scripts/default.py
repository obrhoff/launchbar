#!/usr/bin/python
#
# Copyright (c) 2014 Objective Development
# http://www.obdev.at/

import urllib
import sys
import webbrowser

base_url = 'http://cocoapods.org/?q=%s'
arguments = ' '.join(sys.argv[1:])

def search(search_string):
	url = base_url % urllib.quote(search_string)
	webbrowser.open(url)

search(arguments)
