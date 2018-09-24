#' Knitr function to convert to an HTML document
#' 
#' Format for converting from R Markdown to an HTML document including classroom exercises.
#' Basically just adds dependencies to rmdformats::html_clean
#'
#' @export
html_clean <- function(..., 
                       lightbox = FALSE,
                       thumbnails = FALSE,
                       gallery = FALSE) {
  
  extra_dependencies <- list(
    htmltools::htmlDependency(name = "webex",
                              version = "0.1",
                              src = system.file("", package = "webex"),
                              script = c("js/webex.js", "js/psystats.js"),
                              stylesheet = c("css/webex.css", "css/psystats.css")))
  
  ## Merge "extra_dependencies"
  extra_args <- list(...)
  if ("extra_dependencies" %in% names(extra_args)) {
    extra_dependencies <- append(extra_dependencies, extra_args[["extra_dependencies"]])
    extra_args[["extra_dependencies"]] <- NULL
  }
  
  ## Call rmarkdown::html_document
  html_document_args <- list(
    extra_dependencies = extra_dependencies
  )
  
  html_document_args <- append(html_document_args, extra_args)
  
  html_document_args['lightbox'] <- lightbox
  html_document_args['thumbnails'] <- thumbnails
  html_document_args['gallery'] <- gallery
  
  do.call(rmdformats::html_clean, html_document_args)
  
}

