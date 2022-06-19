#!/usr/bin/env bash

# Get Canadian Tire projects
projects=(
	adaptive-model
	admin-api
	admin-tools
	ansible-atlas
	data-lib
	data-loader
	data-processing
	ingestion
	knowledge-graph
	lemma-plugin
	metrics
	nlp
	pipeline-core
	rules-engine
	search
	search-api
	search-core
	search-proxy
	search-web
	spin-importer
	storage
)

for project in "${projects[@]}"
do
	git clone git@bitbucket.corp.ad.ctc:atlas/$project.git $HOME/Source/atlas/$project
done