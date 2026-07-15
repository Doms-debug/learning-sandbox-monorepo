# Terminal style portfolio

This repository contains the frontend code for my personal portfolio; Main goal was to build fully automated CI/CD pipeline to master DevOps operations; It only later turned out to be nice way to represent myself:)

The interface simulates a command-line terminal

## Technologies

* HTML5
* CSS3
* JavaScript
* Python

## Features

* Dark and light theme toggle
* Tab-based navigation
* Responsive layout
* External GitHub contributions graph

## Infrastructure

* Hosting: GCP
* Infrastructure as code: Terraform
* CI/CD: GitHub Actions

## Deployment

Changes merged to the main branch trigger a GitHub Actions workflow; This workflow synchronizes local files with the Google Cloud Storage bucket

The synchronization excludes the PDF resume file; This keeps personal data out of the public repository

## Local setup

1. Clone this repository
2. Open the index.html file in any web browser