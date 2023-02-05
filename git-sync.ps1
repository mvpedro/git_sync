Write-Output "CLOSED_REPO_NAME: $env:CLOSED_REPO_NAME"
Write-Output "CLOSED_REPO_FOLDER: $env:CLOSED_REPO_FOLDER"


# Load the environment file
$envFile = "$PSScriptRoot\.env"

# Check if the environment file exists
if (!(Test-Path -Path $envFile)) {
    # If not, throw an error and exit
    Write-Error "Error: .env file not found"
    exit 1
}

# Read the environment file and store each line as an array
$env = Get-Content $envFile

# Loop through each line in the environment file
foreach ($line in $env) {
    # Skip lines that don't start with "REPO_URL" or "REPO_PATH"
    if (!($line.StartsWith("REPO_URL") -or $line.StartsWith("REPO_PATH"))) {
        continue
    }

    # Split the line into a key and a value
    $key, $value = $line.Split("=")

    # Store the key and value in a hash table
    $env[$key] = $value
}

# Create a regular expression to match repository URLs
$repoUrlRegex = "^REPO_URL_(.*)$"

# Loop through each key in the environment hash table
foreach ($key in $env.Keys) {
    # Check if the key matches the repository URL pattern
    if ($key -match $repoUrlRegex) {
        # Get the name of the repository
        $repo = $matches[1]

        # Get the URL and path of the repository from the environment hash table
        $url = $env["REPO_URL_$repo"]
        $path = $env["REPO_PATH_$repo"]

        # Check if the local repository exists
        if (!(Test-Path -Path $path)) {
            # If not, clone the repository
            git clone $url $path
        }
        else {
            # If it does exist, update it
            Set-Location $path
            git pull
            git add .
            git commit -m "Automatic commit from git-sync script"
            git push
        }
    }
}