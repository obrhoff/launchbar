package main

import (
	"encoding/json"
	"fmt"
	"github.com/PuerkitoBio/goquery"
	"net/http"
	"net/url"
	"os"
	"strings"
	"time"
)

type Query struct {
	Title    string `json:"title"`
	Subtitle string `json:"subtitle"`
	Url      string `json:"url"`
	Icon     string `json:"icon"`
}

const baseUrl string = "https://www.google.com/search"
const agent string = "NokiaN97/21.1.107 (SymbianOS/9.4; Series60/5.0 Mozilla/5.0;"

func main() {
	if len(os.Args) < 1 {
		return
	}

	GetQuery(os.Args[1])

}

func GetQuery(query string) {

	if len(query) < 1 {
		return
	}

	time.Sleep(500 * time.Millisecond)

	client := &http.Client{}
	req, err := http.NewRequest("GET", baseUrl, nil)
	req.Header.Set("User-Agent", agent)

	q := req.URL.Query()
	q.Add("q", query)
	q.Add("ie", "utf8")
	q.Add("oe", "utf8")
	q.Add("num", "30")

	req.URL.RawQuery = q.Encode()
	resp, err := client.Do(req)

	if err == nil {
		document, _ := goquery.NewDocumentFromResponse(resp)
		results := parseQuery(document)
		json, _ := json.Marshal(results)
		if len(results) > 0 {
			fmt.Println(string(json))
		}
	}
}

func parseQuery(document *goquery.Document) []Query {

	var results []Query
	document.Find("li.g").Each(func(i int, global *goquery.Selection) {
		description := global.Find("span.st").Text()
		title := global.Find("h3.r a")
		str, exists := title.Attr("href")
		if exists {
			u, _ := url.Parse(str)
			m, _ := url.ParseQuery(u.RawQuery)
			urlParameter := m["q"][0]
			doneUrl, _ := url.Parse(urlParameter)
			host := strings.Replace(doneUrl.Host, "www.", "", 1)
			if len(doneUrl.Scheme) > 0 {
				var result Query
				subtitle := host + ": " + description
				result.Title = title.Text()
				result.Url = doneUrl.String()
				result.Subtitle = subtitle
				result.Icon = "Google"
				results = append(results, result)
			}
		}
	})

	return results
}
