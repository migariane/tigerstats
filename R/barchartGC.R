#' @title Easy barcharts from raw and tabular data

#' @description Wrapper for \code{\link[lattice]{barchart}} in package \code{lattice}.  Creates a barchart from raw data, 
#' using formula-data syntax similar to that of \code{\link{xtabs}}.  There are very few options.
#' 
#' @rdname barchartGC
#' @usage barchartGC(x,data=NULL,type="frequency",main=NULL)
#' @param x Either a formula or a table.  If formula, it must be of the form ~var or ~var1+var2.
#' @param data Usually a data frame that supplies the variables in \code{x}.
#' @param type Possible values are "frequency" and "percent".
#' @param main An optional title
#' @return A trellis object describing the barchart.
#' @export
#' @author Homer White \email{hwhite0@@georgetowncollege.edu}
#' @examples
#' data(m111survey)
#' barchartGC(~sex,data=m111survey)
#' 
#' #percentage barchart:
#' barchartGC(~sex+seat,data=m111survey,type="percent")
#' 
#' #From tabulated data:
#' sexseat <- xtabs(~sex+seat,data=m111survey)
#' barchartGC(sexseat,type="percent",main="Sex and Seating Preference")
barchartGC <-
  function(x,data=NULL,
           type="frequency",main=NULL)  { 
    
    
    if (is(x,"formula"))  { #we have a formula
      
      prsd <- ParseFormula(x)
      pullout <- as.character(prsd$rhs)
      
      if (length(pullout) == 1) {  #one variable
        varname <- pullout[1]
        variable <- data[,varname]
        tab <- xtabs(~variable)
        if (type=="frequency") {
          return(barchart(tab,horizontal=F,main=main))
        }
        if (type=="percent") {
        perctab <- 100*tab/sum(tab)
        return(barchart(perctab,horizontal=F,ylab="Percent",main=main))
          }      
      }
      
      if (length(pullout)==3) { #two variables
        expname <- pullout[2]
        respname <- pullout[3]
        explanatory <- data[,expname]
        response <- data[,respname]
        tab <- with(data,table(explanatory,response))
        if (type=="frequency") {
          return(barchart(tab,stack=F,horizontal=F,auto.key=T,main=main))
        }
        if (type=="percent") {
          perctab <- 100*prop.table(tab,margin=1)
          return(barchart(perctab,horizontal=F,stack=F,ylab="Percent",auto.key=T,main=main))
        }   
      }
      
      
    } #end check for formula
      
    
    if (!is(x,"formula")) {  #we have tabular data
      
      if (length(dim(x))==1) {#one variable
        if (type=="frequency") {
          return(barchart(x,horizontal=F))
        }
        if (type=="percent") {
          perctab <- 100*x/sum(x)
          return(barchart(perctab,horizontal=F,ylab="Percent",main=main))
        }     
      }
      if (length(dim(x))>1) {#two variables
        if (type=="frequency") {
          return (barchart(x,stack=F,horizontal=F,auto.key=T,main=main))
        }
        if (type=="percent") {
          perctab <- 100*prop.table(x,margin=1)
          return(barchart(perctab,horizontal=F,stack=F,ylab="Percent",auto.key=T,main=main))
        }
      }
        
    } # end tabular processing
    
  } #ned barchartGC