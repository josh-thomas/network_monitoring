#!/bin/bash

# Default values for the flags
use_apt=0
run_in_background=0

# Function to display script usage
display_help() {
    echo "Usage: $0 [-use_apt {0|1}] [-run_in_background {0|1}] [-h|--help]"
    echo "Options:"
    echo "  -run_in_background {0|1}: Specify whether to run python3 main.py in the background. Default is 0 but should be set to 1 for RBP usage."
    echo "  -h, --help: Display this help message."
    exit 0
}

# Process command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -use_apt)
            use_apt="$2"
            shift
            shift
            ;;
        -h|--help)
            display_help
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Create a virtual environment
python3 -m venv venv

# Activate the virtual environment
source venv/bin/activate
echo "Installing requirements..."
python3 -m pip install -r requirements.txt

# Activte node exporter
echo "Installing node exporter..."
source ./setupNodeExporter.sh
echo "All packages installed!"

# Prompting the user for RP_name
read -p "Enter the value for RP_name environment variable: " RP_name
export RP_name=$RP_name

# Run main
source venv/bin/activate
if [ "$run_in_background" -eq 1 ]; then
    echo "Running main.py in the background"
    python3 main.py &
else
    echo "Running main.py"
    python3 main.py
fi
