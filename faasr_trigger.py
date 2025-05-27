import subprocess
import sys
import os

def run_r_script(script_path):
    """
    Run an R script and capture its output
    
    Args:
        script_path (str): Path to the R script
        
    Returns:
        tuple: Return code and output from the R script
    """
    try:
        # Check if the R script exists
        if not os.path.exists(script_path):
            raise FileNotFoundError(f"R script not found: {script_path}")
        
        # Default R installation paths on Windows
        possible_r_paths = [
            r"C:\Program Files\R\R-4.3.2\bin\Rscript.exe",
            r"C:\Program Files\R\R-4.3.1\bin\Rscript.exe",
            r"C:\Program Files\R\R-4.3.0\bin\Rscript.exe"
        ]
        
        # Find the first existing Rscript executable
        rscript_path = None
        for path in possible_r_paths:
            if os.path.exists(path):
                rscript_path = path
                break
                
        if rscript_path is None:
            raise FileNotFoundError("Could not find Rscript.exe. Please ensure R is installed and provide the correct path.")
        
        # Run the R script using Rscript
        process = subprocess.Popen(
            [rscript_path, script_path],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        
        # Get the output and error messages
        output, error = process.communicate()
        
        # Print the output
        if output:
            print("Output from R script:")
            print(output)
            
        # Print any errors
        if error:
            print("Errors/Warnings from R script:")
            print(error)
            
        return process.returncode, output
        
    except FileNotFoundError as e:
        print(f"Error: {e}")
        return 1, None
    except subprocess.CalledProcessError as e:
        print(f"Error running R script: {e}")
        return e.returncode, None
    except Exception as e:
        print(f"Unexpected error: {e}")
        return 1, None

if __name__ == "__main__":
    # Default script path
    script_path = "rscript.r"
    
    # Allow script path to be specified as command line argument
    if len(sys.argv) > 1:
        script_path = sys.argv[1]
    
    
    # Run the R script
    return_code, output = run_r_script(script_path)
    
    # Exit with the appropriate return code
    sys.exit(return_code)
