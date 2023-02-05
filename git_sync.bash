#!/bin/bash

# Function to automate the process of committing and pushing changes to a Github repository
push_to_github() {
  local repo_path=$1
  local repo_name=$2

  # Navigating to the repository folder
  cd $repo_path

  # Adding every change to Git
  git add .

  # Commiting changes with default message
  timestamp=$(date)
  git commit -m "Automatic commit: $timestamp"

  # Pushing changes
  git push origin master

  echo "Pushed changes to $repo_name repository"
}

# Getting the .env file data
source .env


# Main script
for repo in "${REPOS[@]}"; do
  push_to_github $repo
done
