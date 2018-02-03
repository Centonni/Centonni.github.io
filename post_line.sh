#!/bin/bash

# Adds lineanchors option to all codeblock Liquid tags

languages= java
posts="_posts"

for lang in "${languages}"
do
    :
    perl -pi -e "s/highlight $lang/highlight $lang lineanchors/g" $posts
done
