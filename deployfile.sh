#!/bin/bash
quarto render $1
git checkout gh-pages
cp _site/$1.html .
git add $1.html
git commit -m "Update $1.html"
git push origin gh-pages
git checkout master
