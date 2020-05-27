package main

import (
	"fmt"

	"github.com/gocolly/colly"
	"github.com/voodoolabs/bidderScraper/cmd"
)

func main() {

	cmd.Execute()
	c := colly.NewCollector()

	// Find and visit all links
	c.OnHTML("a[href]", func(e *colly.HTMLElement) {
		e.Request.Visit(e.Attr("href"))
	})

	c.OnRequest(func(r *colly.Request) {
		fmt.Println("Visiting", r.URL)
	})

	c.Visit("http://go-colly.org/")
}
