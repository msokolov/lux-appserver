import module namespace test = "http://luxdb.net/test" at "test.xqy";

(: this causes Saxon to raise a ClassCastException in some internal code :)

test:test("")
