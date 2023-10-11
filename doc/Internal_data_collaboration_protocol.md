# Internal Data collaboration protocol

We need to share data between us effectively but at the same time minimise the risk of unintended data losses/overwrites. As such we will utilise duplicate locations on the PLUS_projects server as well as cloud syncing through ETH polybox.

In the project folder on the server I have set up two data folders:

1.  PERU_SwissRE\\03_workspaces\\02_modelling\Data
2.  PERU_SwissRE\\03_workspaces\\02_modelling\Data\_collab\

The first `Data` folder is the 'production' folder that we will only copy data to once it has been finalised and checked. This means that none of us should delte/overwirite files in this folder without checking with the others. I will prepare an R function specifically to do the update of modified files only. This folder is legacy folder with which we can restire data from if needed. As it is on the server it will automatically be back-upped at ETH

`Data_collab` is effectively our working folder, in the sense that it will be how we all sync the data to our local machines for more efficient operations on the spatial data. In this regard I have set up this folder to sync to ETH Polybox. This means that all of us should work from our local copies of the folder synced with the Polybox desktop client. It is likely that we will quickly reach the 50GB storage limit but we will address that when we come to it.
