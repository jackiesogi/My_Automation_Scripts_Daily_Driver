#!/bin/bash

# Variables
REPO_PATH="$HOME/Downloads/gitrepo/coreutils"  # Local path to the repository
LAST_COMMIT_FILE="$REPO_PATH/.last_commit"  # File to store the last processed commit hash
LOG_FILE="$REPO_PATH/commit_log.html"  # Log file to store commit explanations in HTML format

# Navigate to the repository
cd "$REPO_PATH" || exit

# Fetch the latest changes
git pull

# Get the latest commit hash
LATEST_COMMIT=$(git log -n 1 --format="%H")

# Check if there are new commits
if [ -f "$LAST_COMMIT_FILE" ]; then
    LAST_COMMIT=$(cat "$LAST_COMMIT_FILE")
else
    LAST_COMMIT=""
fi

# Prepare to collect commit information
if [ "$LATEST_COMMIT" != "$LAST_COMMIT" ]; then
    # Store the latest commit hash
    echo "$LATEST_COMMIT" > "$LAST_COMMIT_FILE"

    # Get commit message, long description, and diff
    COMMIT_MESSAGE=$(git log -n 1 --format="%s")
    COMMIT_DESC=$(git log -n 1 --format="%b")

    # Get the list of files changed in the commit
    FILES_CHANGED=$(git diff --name-only "$LAST_COMMIT" "$LATEST_COMMIT")
else
    echo "Up to date, explaining the latest commit..."

    # Even if up to date, explain the latest commit
    COMMIT_MESSAGE=$(git log -n 1 --format="%s")
    COMMIT_DESC=$(git log -n 1 --format="%b")

    # Use `git show` to get the diff for the latest commit
    FILES_CHANGED=$(git show --name-only --pretty=format: "$LATEST_COMMIT")
    fi

# Start preparing the Markdown content
MARKDOWN_CONTENT="\
# Commit: $LATEST_COMMIT

### Description
$COMMIT_MESSAGE

$COMMIT_DESC

"

# Loop through each file and gather diff and explanation
for FILE in $FILES_CHANGED; do
    # Get the diff for the file
    FILE_DIFF=$(git diff "$LAST_COMMIT" "$LATEST_COMMIT" -- "$FILE")

    # If there are no differences, use `git show` to get the diff for the latest commit
    if [ -z "$FILE_DIFF" ]; then
        FILE_DIFF=$(git show "$LATEST_COMMIT" -- "$FILE")
    fi

    # Prepare the request content for LLM (explanation request)
    REQUEST_CONTENT="\
        File: $FILE
            Commit message: $COMMIT_MESSAGE
            Commit description: $COMMIT_DESC
            File diff: $FILE_DIFF

            Please provide a detailed explanation of these changes, including:
            1. The purpose of the changes and how they fit into the overall project architecture.(Title: Why Change?)
            2. An introduction to any foundational concepts related to this change, for instance, the function or macro's usage and purpose before and after changing.(Title: foundational concepts)
            3. Any background information that might help a contributor who is not yet familiar with the project to understand the context.(Title: for newbies) 
            4. Output it as plain text and do not use markdown syntax."

    # Get the explanation for the file using the `chatgpt` command
    FILE_EXPLANATION=$(chatgpt -q "$REQUEST_CONTENT")

    # Add the file section to the Markdown content
    MARKDOWN_CONTENT+="

## File Changed: $FILE

### git diff output 

\`\`\`diff
$FILE_DIFF
\`\`\`


$FILE_EXPLANATION
"
done

# echo "$MARKDOWN_CONTENT"

# exit 0

# Convert Markdown to HTML using pandoc
HTML_CONTENT=$(echo "$MARKDOWN_CONTENT" | pandoc -f markdown -t html)

# Log the HTML explanation
echo "$HTML_CONTENT" > "$LOG_FILE"

# Display the HTML explanation using Zenity
zenity --text-info --title="Latest Commit in $(basename "$REPO_PATH")" --width=800 --height=600 --html --filename="$LOG_FILE"

