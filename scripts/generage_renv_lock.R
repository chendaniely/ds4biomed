pkgs <- renv::dependencies()
renv::snapshot(packages = unique(pkgs$Package))
