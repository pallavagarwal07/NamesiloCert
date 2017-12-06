package main

import (
	"encoding/json"
	"fmt"
)

type ReqT struct {
	Operation string `xml:"operation"`
	IP        string `xml:"ip"`
}

type dnsListRecordsResp struct {
	Request ReqT `xml:"request"`
	Reply   struct {
		Code           int    `xml:"code"`
		Detail         string `xml:"detail"`
		ResourceRecord []struct {
			RecordID string `xml:"record_id"`
			Type     string `xml:"type"`
			Host     string `xml:"host"`
			Value    string `xml:"value"`
			TTL      int    `xml:"ttl"`
			Distance int    `xml:"distance"`
		} `xml:"resource_record"`
	} `xml:"reply"`
}

type dnsAddRecordResp struct {
	Request ReqT `xml:"request"`
	Reply   struct {
		Code     int    `xml:"code"`
		Detail   string `xml:"detail"`
		RecordID string `xml:"record_id"`
	} `xml:"reply"`
}

func prettyPrint(v interface{}) {
	data, err := json.MarshalIndent(v, "", " ")
	if err != nil {
		panic(err)
	}
	fmt.Println(string(data))
}
