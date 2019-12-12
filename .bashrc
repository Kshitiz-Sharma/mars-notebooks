###
# Sample .bashrc file to demonstrate setup of mars-notebook
# Append content from this file to your bashrc. Change the paths to reflect your installation
###

export MARS_HOME="/tmp/mars-notebooks" # Change this to directory where mars.sh is located

source "$MARS_HOME/mars.sh" # Initialize the framework

# Scan for notebooks
mars-scan-notebooks /tmp/mynotebooks1 # Change this to where you've store your notebooks
mars-scan-notebooks /tmp/mynotebooks2

# Load notebooks automatically. This can be skipped and notebooks can be loaded later by running these commands explicitly
# The notebook must end with a .sh.md extension
# Example: if notebook name is "copy-files.sh.md" use "load copy-files"
mars-load notebook1 # Change this to the name of your notebook
mars-load notebook2
