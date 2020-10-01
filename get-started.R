library(fs)
fs::file_copy("/nfs/public-data/training/tidyverse-worksheet.R",
              "tidyverse-worksheet.R")

file.symlink("/nfs/public-data/training", to = "data")
dir_ls('data/penguins')
