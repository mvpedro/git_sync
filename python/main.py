import os
import subprocess

# Load the environment file
env_file = '.env'

# Check if the environment file exists
if not os.path.exists(env_file):
    # If not, throw an error and exit
    print("Error: .env file not found")
    exit(1)

# Read the environment file and store each line as an array
with open(env_file) as f:
    env = f.readlines()

# Create a hash table to store the environment variables
env_vars = {}

# Loop through each line in the environment file
for line in env:
    # Skip lines that don't start with "REPO_URL" or "REPO_PATH"
    if not (line.startswith("REPO_URL") or line.startswith("REPO_PATH")):
        continue

    # Split the line into a key and a value
    key, value = line.split("=")

    # Store the key and value in the environment hash table
    env_vars[key.strip()] = value.strip()

# Create a list to store the repository names
repo_names = []

# Loop through each key in the environment hash table
for key in env_vars.keys():
    # Check if the key starts with "REPO_URL_"
    if key.startswith("REPO_URL_"):
        # Get the name of the repository
        repo_name = key[9:]

        # Add the repository name to the list
        repo_names.append(repo_name)

# Loop through each repository name in the list
for repo_name in repo_names:
    # Get the URL and path of the repository from the environment hash table
    repo_url = env_vars[f"REPO_URL_{repo_name}"]
    repo_path = env_vars[f"REPO_PATH_{repo_name}"]

    # Check if the local repository exists
    if not os.path.exists(repo_path):
        # If not, clone the repository
        print(f"Cloning {repo_name}...")
        subprocess.run(["git", "clone", repo_url, repo_path], check=True)
    else:
        # If it does exist, update it
        print(f"Updating {repo_name}...")
        os.chdir(repo_path)
        subprocess.run(["git", "pull"], check=True)
        subprocess.run(["git", "add", "."], check=True)
        subprocess.run(["git", "commit", "-m", "Automatic commit from git-sync script"], check=True)
        subprocess.run(["git", "push"], check=True)
