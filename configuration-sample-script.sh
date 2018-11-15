#!/bin/bash

cd ods-configuration-sample

if [[ `git status --porcelain` ]]; then
  echo "updating configuration ..."
  git pull origin master
else
    if[]; 
  echo "configuration is up to date"
fi

echo "Copy sample config to configuration directory?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) #cp -r ../ods-configuration-sample/. ../ods-configuration;
              rsync -av --exclude='../ods-configuration-sample/.git' --exclude='path2/to/exclude' ../ods-configuration-sample/ ../ods-configuration;
              find ../ods-configuration -name '*.sample' -type f | while read NAME ; do mv "${NAME}" "${NAME%.sample}"; done; 
              break;;
        No )  exit;;
    esac
done
 

  
 
 