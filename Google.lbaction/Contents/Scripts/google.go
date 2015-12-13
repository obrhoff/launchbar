package main

import (
	"encoding/json"
	"fmt"
	"github.com/PuerkitoBio/goquery"
	"net/http"
	"net/url"
	"os"
)

type Query struct {
	Title        string `json:"title"`
	Subtitle     string `json:"subtitle"`
	Url          string `json:"url"`
	Icon         string `json:"icon"`
	QuickLookURL string `json:"quickLookURL"`
}

const baseUrl string = "https://www.google.com/search"
const agent string = "NokiaN97/21.1.107 (SymbianOS/9.4; Series60/5.0 Mozilla/5.0; Profile/MIDP-2.1 Configuration/CLDC-1.1) AppleWebkit/525 (KHTML, like Gecko) BrowserNG/7.1.4"

func main() {
	if len(os.Args) < 1 {
		return
	}

	GetQuery(os.Args[1])

}

func GetQuery(query string) {

	client := &http.Client{}
	req, err := http.NewRequest("GET", baseUrl, nil)
	req.Header.Set("User-Agent", agent)

	q := req.URL.Query()
	q.Add("q", query)
	req.URL.RawQuery = q.Encode()
	resp, err := client.Do(req)

	if err == nil {
		document, _ := goquery.NewDocumentFromResponse(resp)
		results := parseQuery(document)
		json, err := json.Marshal(results)
		if err == nil {
			fmt.Println(string(json))
		}
	}

}

func parseQuery(document *goquery.Document) []Query {

	var results []Query

	document.Find("h3.r a").Each(func(i int, s *goquery.Selection) {
		str, exists := s.Attr("href")
		if exists {
			u, _ := url.Parse(str)
			m, _ := url.ParseQuery(u.RawQuery)
			doneUrl := m["q"][0]
			_, urlError := url.Parse(doneUrl)
			if urlError == nil {
				var result Query
				result.Title = s.Text()
				result.Url = doneUrl
				result.Subtitle = doneUrl
				result.QuickLookURL = doneUrl
				result.Icon = "Google"
				results = append(results, result)
			}
		}
	})
	return results
}
