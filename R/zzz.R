# register the engine when package is loaded
.onLoad <- function(libname, pkgname){
  knitr::knit_engines$set(hint = eng_hint)
}
