# Load the FaaSr package (installed in container)
library(FaaSr)

# Override only the specific function you modified
faasr_register_workflow_github_repo_question <- function(check, repo){
  private <- FALSE
  return(private)
}

# Now run your script
faasr_tutorial <- faasr(json_path="test_workflow.json", env="faasr_env")
faasr_tutorial$register_workflow()