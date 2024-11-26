#!/bin/bash

# Step 1: Detect modified .qmd files
modified_files=$(git diff --name-only HEAD | grep '.qmd')

if [ -z "$modified_files" ]; then
  echo "No .qmd files have been modified. Nothing to deploy."
  exit 0
fi

# Step 2: Render each modified .qmd file
for file in $modified_files; do
  echo "Rendering $file..."
  quarto render "$file"
done

# Step 3: Switch to gh-pages branch
echo "Switching to gh-pages branch..."
git checkout gh-pages

# Step 4: Deploy updated .html files
for file in $modified_files; do
  html_file="_site/${file%.qmd}.html"
  if [ -f "$html_file" ]; then
    cp "$html_file" .
    echo "Deployed ${file%.qmd}.html"
    git add "${file%.qmd}.html"
  fi
done

# Step 5: Commit and push changes
git commit -m "Incremental update for modified files"
git push origin gh-pages

# Step 6: Switch back to master branch
git checkout master
echo "Incremental deployment completed!"
