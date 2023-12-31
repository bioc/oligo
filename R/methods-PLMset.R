setClass('oligoPLM',
         representation(chip.coefs='matrix',
                        probe.coefs='numeric',
                        weights='matrix',
                        residuals='matrix',
                        se.chip.coefs='matrix',
                        se.probe.coefs='numeric',
                        residualSE='numeric',
                        geometry='numeric',
                        method='character',
                        manufacturer='character',
                        annotation='character',
						phenoData='AnnotatedDataFrame', #$added GH
						description='MIAME', # added GH
						protocolData='AnnotatedDataFrame', #added Guido
                        narrays='integer',
                        nprobes='integer',
                        nprobesets='integer')
         )

### ADDED GH
setMethod('phenoData', 'oligoPLM',
          function(object){
              object@phenoData
          })

setMethod('description', 'oligoPLM',
          function(object){
              object@description
          })

setMethod('protocolData', 'oligoPLM',
          function(object){
              object@protocolData
          })
### END ADDED GH

## suggestion by Guido (thanks!!!!)
setGeneric('opset2eset', function(object) standardGeneric('opset2eset'))
setMethod('opset2eset', 'oligoPLM',
          function(object){
              new("ExpressionSet",
                  exprs =  coef(object),
                  se.exprs =  se(object),
                  phenoData = phenoData(object),
                  annotation = annotation(object),
                  experimentData = description(object),
                  protocolData =  protocolData(object))
          })
          

setMethod('ncol', 'oligoPLM',
          function(x){
              x@narrays
          })

setGeneric('nprobes', function(object) standardGeneric('nprobes'))
setMethod('nprobes', 'oligoPLM',
          function(object){
              object@nprobes
          })

setGeneric('nprobesets', function(object) standardGeneric('nprobesets'))
setMethod('nprobesets', 'oligoPLM',
          function(object){
              object@nprobesets
          })

setMethod('coef', 'oligoPLM',
          function(object){
              object@chip.coefs
          })

setGeneric('coef<-', function(object, value) standardGeneric('coef<-'))
setReplaceMethod('coef', 'oligoPLM',
                 function(object, value){
                     object@chip.coefs <- value
                     object
                 })

setGeneric('coefs.probe', function(object) standardGeneric('coefs.probe'))
setMethod('coefs.probe', 'oligoPLM',
          function(object){
              object@probe.coefs
          })

setGeneric('coefs.probe<-', function(object, value) standardGeneric('coefs.probe<-'))
setReplaceMethod('coefs.probe', 'oligoPLM',
                 function(object, value){
                     object@probe.coefs <- value
                     object
                 })

setMethod('weights', 'oligoPLM',
          function(object, ...){
              object@weights
          })

setGeneric('weights<-', function(object, value) standardGeneric('weights<-'))
setReplaceMethod('weights', 'oligoPLM',
                 function(object, value){
                     object@weights <- value
                     object
                 })

setMethod('residuals', 'oligoPLM',
          function(object){
              object@residuals
          })

setGeneric('residuals<-', function(object, value) standardGeneric('residuals<-'))
setReplaceMethod('residuals', 'oligoPLM',
                 function(object, value){
                     object@residuals <- value
                     object
                 })

setGeneric('se', function(object) standardGeneric('se'))
setMethod('se', 'oligoPLM',
          function(object){
              object@se.chip.coefs
          })

setGeneric('se<-', function(object, value) standardGeneric('se<-'))
setReplaceMethod('se', 'oligoPLM',
                 function(object, value){
                     object@se.chip.coefs <- value
                     object
                 })

setGeneric('se.probe', function(object) standardGeneric('se.probe'))
setMethod('se.probe', 'oligoPLM',
          function(object){
              object@se.probe.coefs
          })

setGeneric('se.probe<-', function(object, value) standardGeneric('se.probe<-'))
setReplaceMethod('se.probe', 'oligoPLM',
                 function(object, value){
                     object@se.probe.coefs <- value
                     object
                 })

setGeneric('residualSE', function(object) standardGeneric('residualSE'))
setMethod('residualSE', 'oligoPLM',
          function(object){
              object@residualSE
          })

setGeneric('residualSE<-', function(object, value) standardGeneric('residualSE<-'))
setReplaceMethod('residualSE', 'oligoPLM',
                 function(object, value){
                     object@residualSE <- value
                     object
                 })

setGeneric('geometry', function(object) standardGeneric('geometry'))
setMethod('geometry', 'oligoPLM',
          function(object){
              object@geometry
          })

setGeneric('geometry<-', function(object, value) standardGeneric('geometry<-'))
setReplaceMethod('geometry', 'oligoPLM',
                 function(object, value){
                     object@geometry <- value
                     object
                 })

setGeneric('method', function(object) standardGeneric('method'))
setMethod('method', 'oligoPLM',
          function(object){
              object@method
          })

setGeneric('method<-', function(object, value) standardGeneric('method<-'))
setReplaceMethod('method', 'oligoPLM',
                 function(object, value){
                     object@method <- value
                     object
                 })

setGeneric('manufacturer', function(object) standardGeneric('manufacturer'))
setMethod('manufacturer', 'oligoPLM',
          function(object){
              object@manufacturer
          })

setGeneric('manufacturer<-', function(object, value) standardGeneric('manufacturer<-'))
setReplaceMethod('manufacturer', 'oligoPLM',
                 function(object, value){
                     object@manufacturer <- value
                     object
                 })

##setGeneric('annotation', function(object) standardGeneric('annotation'))
setMethod('annotation', 'oligoPLM',
          function(object){
              object@annotation
          })

##setGeneric('annotation<-', function(object, value) standardGeneric('annotation<-'))
setReplaceMethod('annotation', 'oligoPLM',
                 function(object, value){
                     object@annotation <- value
                     object
                 })

setMethod("show", "oligoPLM",
          function(object) {

              ## Add preprocessing info
              message("Probe Level Model")
              message("Method..............: ", object@method)
              message("# Samples...........: ", ncol(object))
              message("# Probes (processed): ", nprobes(object))
              message("# Probesets.........: ", nprobesets(object))
              message("Annotation..........: ", annotation(object))
          })

## fix names(theMat)
setMethod("boxplot",signature(x="oligoPLM"),
          function(x, type=c("NUSE", "RLE", "weights", "residuals"),
                   col=darkColors(ncol(x)), range=0, ylim, ...){
            type <- match.arg(type)
            if (type == 'NUSE'){
                theMat <- NUSE(x, type='values')
                candYL <- c(.95, 1.10)
            }else if (type == 'RLE'){
                theMat <- RLE(x, type='values')
                candYL <- c(-.75, .75)
            }else if (type == 'weights'){
                theMat <- weights(x)
                theMat <- theMat[!is.na(theMat[,1]),,drop=FALSE]
                candYL <- c(0, 1)
            }else{
                theMat <- residuals(x)
                theMat <- theMat[!is.na(theMat[,1]),,drop=FALSE]
                candYL <- c(-1, 1)
            }
            if (missing(ylim)) ylim <- candYL
            theMat <- as.data.frame(theMat)
            boxplot(theMat, col=col, range=range, ylim=ylim, ...)
          })


RLE <- function(obj, type=c('plot', 'values', 'stats'), ylim=c(-.75, .75),
                range=0, col=darkColors(ncol(obj)), ...){
    RLE <- sweep(coef(obj), 1, rowMedians(coef(obj)), '-')
    type <- match.arg(type)
    if (type=='plot'){
        boxplot(as.data.frame(RLE), ylab='RLE', range=range, ylim=ylim, col=col, ...)
        abline(h=0, lty=2)
    }else if (type=='stats'){
      RLE <- apply(RLE, 2, quantile, c(0, .25, .50, .75, 1))
    }
    invisible(RLE)
}

NUSE <- function(obj, type=c('plot', 'values', 'stats'), ylim=c(.95, 1.10),
                 range=0, col=darkColors(ncol(obj)), ...){
    if (is.null(se(obj)))
        stop('This Probe Level Model does not allow for computation of NUSE')
    NUSE <- sweep(se(obj), 1, rowMedians(se(obj)), '/')
    type <- match.arg(type)
    if (type == 'plot'){
        boxplot(as.data.frame(NUSE), ylab='NUSE', range=range, ylim=ylim, col=col, ...)
        abline(h=1, lty=2)
    }else if (type == 'stats'){
      NUSE <- apply(NUSE, 2, quantile, c(0, .25, .50, .75, 1))
    }
    invisible(NUSE)
}

setMethod('image', 'oligoPLM',
          function(x, which=1, type=c('weights', 'residuals', 'pos.residuals', 'neg.residuals', 'sign.residuals'), col, main, ...){
              type <- match.arg(type)
              geom <- geometry(x)

              ## NimbleGen is slightly harder
              if (tolower(manufacturer(x)) != "affymetrix"){
                  conn <- db(get(annotation(x)))
                  tbls <- dbGetQuery(conn, "SELECT tbl FROM table_info WHERE tbl LIKE '%feature' AND row_count > 0")[[1]]
                  theInfo <- lapply(tbls, function(tb) dbGetQuery(conn, paste("SELECT x, y, fid FROM", tb)))
                  theInfo <- do.call("rbind", theInfo)
                  theInfo <- theInfo[order(theInfo[["fid"]]), ]
                  idx <- geom[1]*(theInfo[["x"]]-1)+theInfo[["y"]]
              }

              if (type == 'weights'){
                  theMat <- weights(x)[, which]
                  candCols <- rev(seqColors(2560))
                  candMain <- 'Weights'
              }else if (type == 'residuals'){
                  theMat <- residuals(x)[, which]
                  candCols <- divColors(2560)
                  candMain <- 'Residuals'
              }else if (type == 'pos.residuals'){
                  theMat <- pmax(residuals(x)[, which], 0)
                  candCols <- seqColors2(2560)
                  candMain <- 'Positive Residuals'
              }else if (type == 'neg.residuals'){
                  theMat <- pmin(residuals(x)[, which], 0)
                  candCols <- rev(seqColors(2560))
                  candMain <- 'Negative Residuals'
              }else{
                  theMat <- sign(residuals(x)[, which])
                  candCols <- divColors(2)
                  candMain <- 'Sign of Residuals'
              }
              candMain <- paste(candMain, colnames(x@chip.coefs)[which], sep=' - ')
              if (tolower(manufacturer(x)) != 'affymetrix'){
                  theMat0 <- matrix(NA, nrow=geom[1], ncol=geom[2])
                  theMat0[idx] <- theMat[theInfo$fid]
                  theMat <- theMat0
                  rm(theMat0)
                  theMat <- theMat[,geom[2]:1]
              }else{
                  dim(theMat) <- geom
              }
              if (missing(col)){
                  col <- candCols
                  rm(candCols)
              }
              if (missing(main)){
                  main <- candMain
                  rm(candMain)
              }
              image(theMat, col=col, yaxt='n', xaxt='n', main=main, ...)
          }
)
