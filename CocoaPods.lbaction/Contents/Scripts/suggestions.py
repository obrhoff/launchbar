import json
import sys
import urllib

base_url = 'http://search.cocoapods.org/api/v1/pods.flat.ids.json?%s'
arguments = ' '.join(sys.argv[1:])
scriptOutput = []

def search(search_string):
    url = base_url % urllib.urlencode({'query': search_string, 'amount': 10})
    string_results = urllib.urlopen(url).read()
    json_results = json.loads(string_results)

    for item in json_results:
        scriptOutput.append({'title' : item, 'icon' : 'DuckDuckGo'})

search(arguments)

print json.dumps(scriptOutput)
