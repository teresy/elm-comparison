#!/bin/bash

echo 'elm-lint does not transform. this is just a benchmark'

cd take-home
elm-lint init
time elm-lint | grep "Access to property"

mv elm-stuff /tmp # won't count the initial run against elm-lint.
mv LintConfig.elm /tmp

time ~/rooibos-future/main -d . -filter .elm -templates ~/rooibos-future/catalogue/elm/elm-lint/simplify-property-access
git checkout -- .

mv /tmp/elm-stuff .
mv /tmp/LintConfig.elm .

cd ..
