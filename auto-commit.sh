#!/bin/bash

# Prompt user for commit message
echo "This will automatically commit and push all changes to the main branch."
read -p "Enter commit message: " commit_message

# Execute git commands
git add .
git commit -m "$commit_message"
git push -u origin main
