#!/usr/bin/env bash

## just build on a loop so i can see what is fooked
clear
haxe build.hxml
sleep 5

sh $(basename $0) && exit