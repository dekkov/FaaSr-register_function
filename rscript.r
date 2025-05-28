# Load the FaaSr package (installed in container)
library(FaaSr)

# Override the faasr_collect_sys_env function to get GitHub token from workflow environment
faasr_collect_sys_env <- function(faasr, cred){
  
  # Check the computeservers.
  for (faas_cred in names(faasr$ComputeServers)){
    # For GitHub Actions, get token from environment variable set by workflow
    if (faasr$ComputeServers[[faas_cred]]$FaaSType=="GitHubActions"){
      cred_name <- faasr$ComputeServers[[faas_cred]]$Token
      if (is.null(cred_name)){
        cred_name <- paste0(faas_cred, "_TOKEN")
      }
      if (is.null(cred[[cred_name]])){
        # Try to get from environment variable (set by GitHub Actions workflow)
        real_cred <- Sys.getenv(cred_name)
        if (real_cred != ""){
          cred[[cred_name]] <- real_cred
        } else {
          # If not found in environment, this is expected in workflow context
          # The token will be provided by the GitHub Actions environment
          message(paste0("GitHub token ", cred_name, " will be provided by workflow environment"))
        }
      }
    
    # if it is openwhisk, use key type for "API.key"
    } else if (faasr$ComputeServers[[faas_cred]]$FaaSType=="OpenWhisk"){
      cred_name <- faasr$ComputeServers[[faas_cred]]$API.key
      if (is.null(cred_name)){
        cred_name <- paste0(faas_cred, "_API_KEY")
      }
      if (is.null(cred[[cred_name]])){
        real_cred <- Sys.getenv(cred_name)
        if (real_cred == ""){
          ask_cred <- askpass::askpass(paste0("Enter keys for ", cred_name))
          ask_cred_list <- list(ask_cred)
          names(ask_cred_list) <- cred_name
          do.call(Sys.setenv, ask_cred_list)
          cred[[cred_name]] <- ask_cred
        } else{
          cred[[cred_name]] <- real_cred
        }
      }
      
    # if it is Lambda, use key types for "AccessKey" and "SecretKey"
    } else if (faasr$ComputeServers[[faas_cred]]$FaaSType=="Lambda"){
      cred_name_ac <- faasr$ComputeServers[[faas_cred]]$AccessKey
      if (is.null(cred_name_ac)){
        cred_name_ac <- paste0(faas_cred, "_ACCESS_KEY")
      }
      if (is.null(cred[[cred_name_ac]])){
        real_cred <- Sys.getenv(cred_name_ac)
        if (real_cred == ""){
          ask_cred <- askpass::askpass(paste0("Enter keys for ", cred_name_ac))
          ask_cred_list <- list(ask_cred)
          names(ask_cred_list) <- cred_name_ac
          do.call(Sys.setenv, ask_cred_list)
          cred[[cred_name_ac]] <- ask_cred
        } else{
          cred[[cred_name_ac]] <- real_cred
        }
      }
      
      cred_name_sc <- faasr$ComputeServers[[faas_cred]]$SecretKey
      if (is.null(cred_name_sc)){
        cred_name_sc <- paste0(faas_cred, "_SECRET_KEY")
      }
      if (is.null(cred[[cred_name_sc]])){
        real_cred <- Sys.getenv(cred_name_sc)
        if (real_cred == ""){
          ask_cred <- askpass::askpass(paste0("Enter keys for ", cred_name_sc))
          ask_cred_list <- list(ask_cred)
          names(ask_cred_list) <- cred_name_sc
          do.call(Sys.setenv, ask_cred_list)
          cred[[cred_name_sc]] <- ask_cred
        } else{
          cred[[cred_name_sc]] <- real_cred
        }
      }
    }
  }
  
  # Check the DataStores.
  for (data_cred in names(faasr$DataStores)){
    cred_name_ac <- faasr$DataStores[[data_cred]]$AccessKey
    if (is.null(cred_name_ac)){
      cred_name_ac <- paste0(data_cred, "_ACCESS_KEY")
    }
    cred_name_sc <- faasr$DataStores[[data_cred]]$SecretKey
    if (is.null(cred_name_sc)){
      cred_name_sc <- paste0(data_cred, "_SECRET_KEY")
    }
    if (!is.null(faasr$DataStores[[data_cred]]$Anonymous)){
      if (isTRUE(faasr$DataStores[[data_cred]]$Anonymous)){
        next
      }
    }
    if (is.null(cred[[cred_name_ac]])){
      real_cred <- Sys.getenv(cred_name_ac)
      if (real_cred == ""){
        ask_cred <- askpass::askpass(paste0("Enter keys for ", cred_name_ac))
        ask_cred_list <- list(ask_cred)
        names(ask_cred_list) <- cred_name_ac
        do.call(Sys.setenv, ask_cred_list)
        cred[[cred_name_ac]] <- ask_cred
      } else{
        cred[[cred_name_ac]] <- real_cred
      }
    }
    if (is.null(cred[[cred_name_sc]])){
      real_cred <- Sys.getenv(cred_name_sc)
      if (real_cred == ""){
        ask_cred <- askpass::askpass(paste0("Enter keys for ", cred_name_sc))
        ask_cred_list <- list(ask_cred)
        names(ask_cred_list) <- cred_name_sc
        do.call(Sys.setenv, ask_cred_list)
        cred[[cred_name_sc]] <- ask_cred
      } else{
        cred[[cred_name_sc]] <- real_cred
      }
    }
  }
  return(cred)
}

# Override only the specific function you modified
faasr_register_workflow_github_repo_question <- function(check, repo){
  private <- FALSE
  return(private)
}

# Now run your script
faasr_tutorial <- faasr(json_path="test_workflow.json", env="faasr_env.txt")
faasr_tutorial$register_workflow()