package main

import (
	"bytes"
	"encoding/xml"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
)

func (name *Namesilo) Do(url string, req url.Values) ([]byte, error) {
	resp, err := http.Get(url + "&" + req.Encode())
	if err != nil {
		return nil, err
	}
	if code := resp.StatusCode; code != 200 {
		return nil, fmt.Errorf("Non-200 status code: %d", code)
	}
	out, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}
	out = bytes.Join(bytes.Split(out, []byte{'\n'})[1:], nil)
	return out, nil
}

func (name *Namesilo) GetDNS(req url.Values) (*dnsListRecordsResp, error) {
	out, err := name.Do(fmt.Sprintf(name.URL, "dnsListRecords"), req)
	if err != nil {
		return nil, err
	}

	var v dnsListRecordsResp
	if err := xml.Unmarshal(out, &v); err != nil {
		return nil, err
	}
	return &v, nil
}

func (name *Namesilo) SetDNS(req url.Values) (*dnsAddRecordResp, error) {
	out, err := name.Do(fmt.Sprintf(name.URL, "dnsAddRecord"), req)
	if err != nil {
		return nil, err
	}
	var v dnsAddRecordResp
	if err := xml.Unmarshal(out, &v); err != nil {
		return nil, err
	}
	return &v, nil
}
