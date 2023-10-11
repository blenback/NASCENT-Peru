
#get basic dir names from valpar.ch folder
Base_dirs <- list.dirs("X:/CH_ValPar.CH", recursive = FALSE, full.names = FALSE)

#create dirs under the peru project (base_dir from global_env)
sapply(Base_dirs, function(x){dir.create(paste0(Base_dir, "/", x))})

#Create a dir for modelling as a sub dir in workspaces
Modelling_dir <- paste0(Base_dir, "/", Base_dirs[3], "/02_modelling")
dir.create(Modelling_dir)

#within this create sub dirs for data and data_collab
Data_dir <- paste0(Modelling_dir, "/Data")
Data_collab_dir <- paste0(Modelling_dir, "/Data_collab")
dir.create(Data_dir)
dir.create(Data_collab_dir)







lastupdate <- file.info('.gitignore')$ctime