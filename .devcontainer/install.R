#! /usr/local/bin/Rscript
# install R dependencies

# We could use renv.lock approach here instead, but will force re-creation of environment from scratch
# Does not provide a good way to ensure that sf/terra/gdalcubes are installed from source while other packages can be binary
# Likewise, pak insists on installing old gdal from apt instead of respecting system library source builds
# install.packages("pak")
install.packages(c("rstac", "spData", "earthdatalogin", "quarto", "aws.s3", "tmap", "reticulate"))
remotes::install_github('r-tmap/tmap', upgrade=FALSE)

#pak::pkg_install("httpgd")
#pak::pkg_install(c("IRkernel", "languageserver"))
#IRkernel::installspec()

