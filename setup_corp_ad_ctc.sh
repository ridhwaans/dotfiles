#!/usr/bin/env bash

# Get Canadian Tire projects
projects=(
)

for project in "${projects[@]}"
do
	git clone git@bitbucket.corp.ad.ctc:atlas/$project.git $HOME/Source/atlas/$project
done