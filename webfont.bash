#!/bin/bash

if [ $# -lt 1 ]; then
    echo "error"
    exit 1
fi

path=$(dirname $1)
cd "$path"

name=$(basename ${1%%.*})
extension=${1##*.}
extension=${extension^^}

if [ ! -f "$1" ]; then
    echo "noo $1"
    exit 2
fi

mkdir -p "$path/$name/fonts/$name"
fontforge -c "import fontforge;fontforge.open('$1').generate('$path/$name/fonts/$name/$name.ttf')"
fontforge -c "import fontforge;fontforge.open('$1').generate('$path/$name/fonts/$name/$name.eot')"
fontforge -c "import fontforge;fontforge.open('$1').generate('$path/$name/fonts/$name/$name.svg')"
fontforge -c "import fontforge;fontforge.open('$1').generate('$path/$name/fonts/$name/$name.woff')"

mkdir -p $path/$name/css/
echo "@font-face {" >$path/$name/css/$name.css
echo "    font-family: '$name';" >>$path/$name/css/$name.css
echo "    src: url('../fonts/$name/$name.eot');" >>$path/$name/css/$name.css
echo "    src: url('../fonts/$name/$name.eot?#iefix') format('embedded-opentype')," >>$path/$name/css/$name.css
echo "    url('../fonts/$name/$name.woff') format('woff')," >>$path/$name/css/$name.css
echo "    url('../fonts/$name/$name.ttf') format('truetype')," >>$path/$name/css/$name.css
echo "    url('../fonts/$name/$name.svg#lorabold') format('svg');" >>$path/$name/css/$name.css
echo "}" >>$path/$name/css/$name.css

cd "$path/$name"
zip -r ../$name.zip fonts/ css/
cd ..
dir=$(pwd)
dir=${dir: -7}
if [ "$dir" == "uploads" ]; then
    echo "-- removing $name"
    rm -rf "$name"
fi
