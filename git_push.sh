#!/bin/bash


if [ "$#" -ne 1 ]; then
	echo "[!] Usage: ${0} path"
	exit
fi

echo "[*]Working...." | lolcat 


root_directory=$1

# Function to push changes for a Git repository
push_changes() {
  cd "$1" || return
  git pull
  git add .
  git commit -m "Auto-commit changes"
  git push
  cd - > /dev/null || return
}

# Function to recursively search and push Git repositories
search_and_push() {
  local dirs=()
  dirs+=("$1"/*)

  for dir in "${dirs[@]}"; do
	if [[ -d "$dir/.git" ]]; then
	  echo "Pushing changes in $dir"
	  push_changes "$dir"
	fi
  done
}

# Prompt user to confirm
read -p "This script will recursively search and push Git repositories. Do you want to continue? (y/n) " -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
  search_and_push "$root_directory"
  echo "All repositories have been updated!"
else
  echo "Operation canceled."
fi