#!/bin/bash

DATE=$( date +%Y-%m-%d )

pip freeze > requirements.txt

git add .
git commit -m "$DATE"
git push origin master
