#!/bin/sh
hugo
cd public
git add .
git commit -m "Published"  
git push -u origin master
