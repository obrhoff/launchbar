import json
import sys
import urllib2
import urllib

base_url = 'http://search.cocoapods.org/api/pods?%s'
arguments = ' '.join(sys.argv[1:])
scriptOutput = []

def search(search_string):

	url = base_url % urllib.urlencode({'query': search_string, 'amount': 10})
	q = urllib2.Request(url)
	q.add_header('Accept', 'application/vnd.cocoapods.org+flat.hash.json; version=1')
	q.add_header('User-Agent', 'LaunchBar')

	string_results = urllib2.urlopen(q).read()
	json_results = json.loads(string_results)
   
	for item in json_results:
		scriptOutput.append({'title' : item["id"], 'subtitle': item["summary"], 'icon' : 'Cocoapods'})

search(arguments)

print json.dumps(scriptOutput)
