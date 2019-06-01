#!/bin/bash

if [ $# -lt 1 ]; then
    echo "error"
    exit 1
fi

name=${1%%.*}
extension=${1##*.}
extension=${extension^^}


if [ ! -f "$1" ]; then
    echo "noo $1"
    exit 2
fi

mkdir -p "$name/fonts/$name"
fontforge -c "import fontforge;fontforge.open('$1').generate('$name/fonts/$name/$name.ttf')"
fontforge -c "import fontforge;fontforge.open('$1').generate('$name/fonts/$name/$name.eot')"
fontforge -c "import fontforge;fontforge.open('$1').generate('$name/fonts/$name/$name.svg')"
fontforge -c "import fontforge;fontforge.open('$1').generate('$name/fonts/$name/$name.woff')"

mkdir -p "$name/css/"
echo "@font-face {" >$name/css/$name.css
echo "    font-family: '$name';" >>$name/css/$name.css
echo "    src: url('../fonts/$name/$name.eot');" >>$name/css/$name.css
echo "    src: url('../fonts/$name/$name.eot?#iefix') format('embedded-opentype')," >>$name/css/$name.css
echo "    url('../fonts/$name/$name.woff') format('woff')," >>$name/css/$name.css
echo "    url('../fonts/$name/$name.ttf') format('truetype')," >>$name/css/$name.css
echo "    url('../fonts/$name/$name.svg#lorabold') format('svg');" >>$name/css/$name.css
echo "}" >>$name/css/$name.css

cd "$name"
zip -r ../$name.zip fonts/ css/
cd ..
rm -rf "$name"
