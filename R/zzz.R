# register the engine when package is loaded
.onLoad <- function(libname, pkgname){
  knitr::knit_engines$set(hint = eng_hint)
  
  bookdown <- getNamespace("bookdown")
  unlockBinding("gitbook_dependency", bookdown)
  bookdown$gitbook_dependency <- gitbook_dependency
  lockBinding("gitbook_dependency", bookdown)

}
