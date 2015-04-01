#!/bin/sh
rm -f thx.stream.dom.zip
zip -r thx.stream.dom.zip hxml src demo doc/ImportStreamDom.hx extraParams.hxml haxelib.json LICENSE README.md -x "*/\.*"
haxelib submit thx.stream.dom.zip
