package main

import (
	"fmt"
	"log"
	"os"
	"strings"
)

const reqURL = "https://www.namesilo.com/api/%s?version=%d&type=%s&key=%s"

type Namesilo struct {
	URL string
}

func parse(str string) (string, string) {
	pieces := strings.Split(str, ".")
	domain := strings.Join(pieces[len(pieces)-2:], ".")
	key := strings.Join(pieces[:len(pieces)-2], ".")
	return key, domain
}

func main() {
	state := Namesilo{}
	version := 1
	resType := "xml"
	apiKey := os.Getenv("NAMESILO")
	if apiKey == "" {
		log.Fatalln("Environment variable NAMESILO or HOME empty")
	}
	reqURL_ := fmt.Sprintf(reqURL, "%s", version, resType, apiKey)
	state.URL = reqURL_

	if len(os.Args) < 3 {
		fmt.Println("Usage:", os.Args[0], "<domain>", "<value>")
		os.Exit(1)
	}
	key, domain := parse(os.Args[1])

	fmt.Println("Key is:", key, ", Domain is:", domain)
	dns, err := state.SetDNS(map[string][]string{
		"domain":  {domain},
		"rrtype":  {"TXT"},
		"rrhost":  {key},
		"rrvalue": {os.Args[2]},
		"rrttl":   {"3600"},
	})
	if err != nil {
		log.Fatalln("DNS put failed", err)
	}
	prettyPrint(dns)
}
