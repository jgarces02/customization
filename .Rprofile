### Basic ######################################################################################################

## R interactive prompt 
# options(prompt = "> ")
# options(continue = "+ ") 

## Load packages
library(BiocInstaller)
library(grDevices)
library(devtools)
library(dplyr)
library(ggplot2)
library(editheme)

## Load custom functions
# source("/Users/jgarces/google_drive/bioinformatica/codigos_varios/functionesJuanjo.R")

## This snippet allows you to tab-complete package names in "library()" or "require()" calls.
utils::rc.settings(ipck = TRUE)

## "refresh" will shut down the current session and start up a new one.
makeActiveBinding("refresh", function() { shell("Rgui"); q("no") }, .GlobalEnv)
makeActiveBinding("refresh", function() { system("R"); q("no") }, .GlobalEnv) 

## Customize path where packages will be installed
.libPaths("/mnt/beegfs/jgarces/software/r_packages")

### Customize functions #######################################################################################

## Create a new invisible environment for all the functions to go in so it doesn't clutter your workspace.
.env <- new.env()

## Single character shortcuts for summary() and head().
.env$s <- base::summary
.env$h <- utils::head

## ht==headtail, i.e., show the first and last 10 items of an object
.env$ht <- function(d) rbind(head(d,10),tail(d,10))

## Show the first 5 rows and first 5 columns of a data frame or matrix
.env$hh <- function(d) if(class(d)=="matrix"|class(d)=="data.frame") d[1:5,1:5]

## List files in a bash-way
.env$ll <- base::list.files

## Change the default behavior of "q()" to quit immediately and not save workspace.
.env$q <- function(save = "no", ...){
  quit(save = save, ...)
}

## List all functions in a package
.env$lsp <-function(package, all.names = FALSE, pattern) {
    package <- deparse(substitute(package))
    ls(
        pos = paste("package", package, sep = ":"),
        all.names = all.names,
        pattern = pattern
    )
}

## Open current windows directory
.env$wopen <- function(x){
  y <- getwd()
  y <- gsub("/", "\\\\", y)
  shell(paste0("explorer ", y), intern = TRUE) 
}

## To install a list of packages (from CRAN or Bioconductor simultaneously)
.env$install.packages.auto <- function(list_packages) { 
  for(x in list_packages){
    x <- as.character(substitute(x)) 
    if(isTRUE(x %in% .packages(all.available=TRUE))) { 
      eval(parse(text = sprintf("require(\"%s\")", x)))
    } else { 
      #update.packages(ask= FALSE) #update installed packages.
      eval(parse(text = sprintf("install.packages(\"%s\", dependencies = TRUE)", x)))
    }
    if(isTRUE(x %in% .packages(all.available=TRUE))) { 
      eval(parse(text = sprintf("require(\"%s\")", x)))
    } else {
      source("http://bioconductor.org/biocLite.R")
      #biocLite(character(), ask=FALSE) #update installed packages.
      eval(parse(text = sprintf("biocLite(\"%s\")", x)))
      eval(parse(text = sprintf("require(\"%s\")", x)))
    }
  }
}

## Adding a column and fill empty "cells" with NA values
.env$cbind.fill <- function(...){
  nm <- list(...) 
  nm <- lapply(nm, as.matrix)
  n <- max(sapply(nm, nrow)) 
  do.call(cbind, lapply(nm, function (x) 
    rbind(x, matrix(, n-nrow(x), ncol(x))))) 
}

## Opposite function to intersect(), all different values between two (or more) objects.
.env$outersect <- function(x, y, ...) {
  big.vec <- c(x, y, ...)
  duplicates <- big.vec[duplicated(big.vec)]
  setdiff(big.vec, unique(duplicates))
}

## Attach all the variables abov
attach(.env)

### Miscelaneaous ###############################################################################

.First <- function() {
  cat("Using library: ", .libPaths()[1])
  cat("Packages loaded: BiocInstaller, grDevices, devtools, dplyr, ggplot2, editheme")
  cat("\nSuccessfully loaded .Rprofile at", date(), "\n")
}

.Last <- function() {
  # save command history here?
  cat("\nGoodbye at ", date(), "\n")
}

## Put a bit of color in the terminal...
library(colorout)
setOutputColors256(
                   normal = 70,
                   number = 214,
                   string = 179,
                   const = 202,
                   stderror = 45,
                   error = 1, 
                   warn = 1
                  )
