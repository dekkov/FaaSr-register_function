#!/usr/bin/env Rscript

source('rstudio_setup_script.txt')
faasr_tutorial <- faasr(json_path="test_workflow.json", env="faasr_env")
print(faasr_tutorial)