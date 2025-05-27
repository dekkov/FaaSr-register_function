#!/usr/bin/env python3

import argparse
import subprocess
import sys
import os
import json

def run_r_setup():
    """Set up R environment with necessary repositories"""
    setup_cmd = [
        "Rscript",
        "-e",
        'options(repos = c(CRAN = "https://cloud.r-project.org")); options(timeout=360);'
    ]
    try:
        subprocess.run(setup_cmd, check=True, capture_output=True, text=True)
    except subprocess.CalledProcessError as e:
        print(f"Error setting up R environment: {e}")
        print(f"Setup error: {e.stderr}")
        sys.exit(1)

def run_r_script(script_path, function_names=None):
    """
    Execute an R script with specified functions
    
    Args:
        script_path (str): Path to the R script
        function_names (list): List of function names to execute (optional)
    """
    if not os.path.exists(script_path):
        print(f"Error: R script not found at {script_path}")
        sys.exit(1)

    # First run the R setup
    run_r_setup()
    
    # Prepare R command
    r_cmd = ["Rscript"]
    
    # Add setup options directly before running the script
    r_cmd.extend([
        "-e",
        'options(repos = c(CRAN = "https://cloud.r-project.org")); options(timeout=360);'
    ])
    
    # Add the script path
    r_cmd.append(script_path)
    
    # If specific functions are provided, pass them as arguments
    if function_names:
        r_cmd.extend(function_names)

    try:
        # Execute the R script
        process = subprocess.run(
            r_cmd,
            check=True,
            text=True,
            capture_output=True
        )
        print(process.stdout)
        if process.stderr:
            print(process.stderr)
        
    except subprocess.CalledProcessError as e:
        print(f"Error executing R script: {e}")
        print(f"R script output: {e.stdout}")
        print(f"R script error: {e.stderr}")
        sys.exit(1)

def main():
    parser = argparse.ArgumentParser(description="Execute R functions from a script")
    parser.add_argument(
        "--script",
        "-s",
        required=True,
        help="Path to the R script file"
    )
    parser.add_argument(
        "--functions",
        "-f",
        nargs="+",
        help="Names of R functions to execute (optional)"
    )
    parser.add_argument(
        "--config",
        "-c",
        help="Path to JSON configuration file (optional)"
    )

    args = parser.parse_args()

    # If config file is provided, read it
    if args.config:
        try:
            with open(args.config, 'r') as f:
                config = json.load(f)
                # You can extend this to handle more configuration options
                if 'functions' in config:
                    args.functions = config['functions']
        except Exception as e:
            print(f"Error reading config file: {e}")
            sys.exit(1)

    run_r_script(args.script, args.functions)

if __name__ == "__main__":
    main()
