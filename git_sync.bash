#!/bin/bash

# Function to automate the process of committing and pushing changes to a Github repository
push_to_github() {
  local repo_path=""
  local repo_name=""

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

# Main script
push_to_github closed-repo closed-repo
push_to_github open-repo open-repo
