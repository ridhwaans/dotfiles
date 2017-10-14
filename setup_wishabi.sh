#!/usr/bin/env bash

# Get Flipp projects
projects=(
	pushback
	editorials
	module-templates
	fadmin
	HealthCheck-2.0
	flyer_availability_service
	auction_house
	marketing_automation
	groda
	editorials_automation
	backflipp
	biggerdata
	merchants
	qa_data
	qa
	qa_process
)

for project in "${projects[@]}"
do
	git clone git@github.com:wishabi/$project.git $HOME/Source/wishabi/$project
done