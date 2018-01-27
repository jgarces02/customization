### Basics ##################################################################################################


## Adding a column and fill empty "cells" with NA values (as rbind.fill, from plyr)
cbind.fill <- function(...){
  nm <- list(...) 
  nm <- lapply(nm, as.matrix)
  n <- max(sapply(nm, nrow)) 
  do.call(cbind, lapply(nm, function (x) 
    rbind(x, matrix(, n-nrow(x), ncol(x))))) 
}

## To install a list of packages (from CRAN or Bioconductor simultaneously)
install.packages.auto <- function(list_packages) { 
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

## Volcano plot with colors according cut-off (https://goo.gl/2aSEhc)
# No termina de funcionar correctamente (no colorea con naranjas)...
volcanoPlot <- function(data, logFC_filter = 1, pvalue_filter = .5, pch = 20, main = "Volcano plot", xlim = c(-2.5,2), labels = TRUE, cex = .8){
  with(data, plot(logFC, -log10(P.Value), pch = pch, main = main, xlim = xlim))
  with(subset(data, P.Value < pvalue_filter ), points(logFC, -log10(P.Value), pch = pch, col = "red"))
  with(subset(data, abs(logFC) > logFC_filter), points(logFC, -log10(P.Value), pch = pch, col = "orange"))
  with(subset(data, P.Value < pvalue_filter & abs(logFC) > logFC_filter), points(logFC, -log10(P.Value), pch = pch, col = "green"))
  if(labels == "FALSE"){
  }else{
    with(subset(data, P.Value < pvalue_filter & abs(logFC) > logFC_filter), textxy(logFC, -log10(P.Value), labs = GeneName, cex = cex))
  }
}

## To download attributes from BIOMART
biomart.download <- function(attributes_list, values = "", name_file = "biomart_db"){
  ensembl <- useMart("ensembl", dataset = "hsapiens_gene_ensembl")
  biomart_db <- getBM(attributes = attributes_list, values = values, mart = ensembl)
  write.table(biomart_db, file = paste0(name_file, ".txt"), sep = "\t", quote = FALSE, row.names = FALSE)
  print(paste0("Biomart dataset save as -> ", paste0(name_file, ".txt")))
}

## To create a density plot and color by quantiles
# algo no funciona, no coge las opciones pasadas a fun, solo rowMedians
densityPlot.color <- function(data, fun = "rowMedians", probs = c(0.1, 0.25, 0.5, 0.75, 0.9)){
  if(fun == "rowMeans"){
    data1 <- as.data.frame(cbind(data, rowMeans = rowMeans(data)))
    dens <- density(data1$rowMeans)
    df <- data.frame(x = dens$x, y = dens$y)
    quantiles <- quantile(data1$rowMeans, prob = probs)
    df$quant <- factor(findInterval(df$x, quantiles))
    }
  if(fun == "rowMax"){
    data1 <- as.data.frame(cbind(data, rowMax = rowMax(data)))
    dens <- density(data1$rowMax)
    df <- data.frame(x = dens$x, y = dens$y)
    quantiles <- quantile(data1$rowMax, prob = probs)
    df$quant <- factor(findInterval(df$x, quantiles))
    }
  if(fun == "rowMin"){
    data1 <- as.data.frame(cbind(data, rowMin = rowMin(data)))
    dens <- density(data1$rowMin)
    df <- data.frame(x = dens$x, y = dens$y)
    quantiles <- quantile(data1$rowMin, prob = probs)
    df$quant <- factor(findInterval(df$x, quantiles))
    }
  else{
    cat("By default rowMedians() are used, for other functions type \"rowMeans\", \"rowMax\" or \"rowMin\"")
    data1 <- as.data.frame(cbind(data, rowMedians = rowMedians(data)))
    dens <- density(data1$rowMedians)
    df <- data.frame(x = dens$x, y = dens$y)
    quantiles <- quantile(data1$rowMedians, prob = probs)
    df$quant <- factor(findInterval(df$x, quantiles))
    }
  ggplot(df, aes(x,y)) + 
  geom_ribbon(aes(ymin = 0, ymax = y, fill = quant)) + 
  scale_x_continuous(breaks = quantiles) + 
  scale_fill_brewer(guide = "none")
}

## Opposite function to intersect(), all different values between two (or more) objects.
outersect <- function(x, y, ...) {
  big.vec <- c(x, y, ...)
  duplicates <- big.vec[duplicated(big.vec)]
  setdiff(big.vec, unique(duplicates))
}
