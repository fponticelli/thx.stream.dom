#!/bin/sh
rm thx.stream.dom.zip
zip -r thx.stream.dom.zip hxml src demo doc/ImportStreamDom.hx extraParams.hxml haxelib.json LICENSE README.md
haxelib submit thx.stream.dom.zip