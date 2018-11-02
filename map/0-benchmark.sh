#!/bin/bash

echo 'elm-lint does not transform. this is just a benchmark'

cd graphql
elm-lint init
time elm-lint | grep "SimplifyPiping"

time ~/rooibos-future/main -d . -filter .erl -templates ~/rooibos-future/catalogue/elm/elm-lint/simplify-piping/
git checkout -- .
cd ..


