package model

import (
	"encoding/xml"
	/*"fmt"*/
	/*"os"*/
	"ds3g/orm"
	/*"reflect"*/
	"testing"
)

/*

	Helper-Func's n Fixture

*/
func newRoute(id orm.TEXT) *Route {

	r := &Route{Id: id, Impl_repo: 0, Src: "coll1/bok1", Http_code: 200}

	r.Names = []Name{
		Name{route_id: "--", Lang: "no", Name: "Den ene"},
		Name{route_id: "--", Lang: "en", Name: "The One", Tooltip: "Longer desc"},
		Name{route_id: id, Lang: "sv", Name: "den enda"},
	}

	r.Meta_values = []MetaValue{
		MetaValue{Key: "a", Value: "en verdi"},
		MetaValue{route_id: "xx", Key: "b", Value: ""},
		MetaValue{Key: "keyC", Value: "Enda en text"},
	}

	return r
}

/*


	TESTs


*/

func TestOutAndBackIn(t *testing.T) {

	const ID = "/test1"

	ref := newRoute(ID)

	x, err := xml.MarshalIndent(ref, "", "  ")
	if err != nil {
		t.Error(err)
	}

	/*t.Log("ref as xml is :", string(x))*/

	var fresh Route //only empty fields

	err = xml.Unmarshal(x, &fresh)
	if err != nil {
		t.Error(err)
	}

	var x2 []byte
	x2, err = xml.MarshalIndent(fresh, "", "  ")
	if err != nil {
		t.Error(err)
	}

	t.Log("fresh as xml is:", string(x2))

	if string(x) != string(x2) {
		t.Error("not equal, sorry MAC")
	}

}

func TestPubSetup(t *testing.T) {

	var ps PubSetup
	ps.route_id = "/test1"
	ps.Branch = "R1"
	ps.Tag = "HEAD"
	ps.Created = "2012-12-23"
	ps.User = "pml"
	ps.Dest = 1
    ps.Comment = "Ny revisjon i dag, vi er så glad"

    x, err := xml.MarshalIndent(ps, "", "  ")
	if err != nil {
		t.Error(err)
	}

	t.Log("xml is:", string(x))

}

func TestSimplest(t *testing.T) {

	lc := new(LangCode)

	lc.Code = "asasa"
	lc.Desc = "asasdkjasdkljaskldjaskl"

	str, _ := xml.Marshal(lc)

	t.Log("str is :", string(str))
}
