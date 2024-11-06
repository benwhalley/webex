html_clean <- function(fig_width = 6,
                       fig_height = 6,
                       fig_caption = TRUE,
                       highlight = "kate",
                       lightbox = TRUE,
                       thumbnails = TRUE,
                       gallery = FALSE,
                       toc = TRUE,
                       toc_depth = 2,
                       use_bookdown = FALSE,
                       pandoc_args = NULL,
                       md_extensions = NULL,
                       mathjax = "default",
                       ...) {
  rmdformats:::html_template(
    template_name = "html_clean",
    template_path = "templates/template.html",
    # html_dependency_clean provides a list, this is different from rmd_formats
    template_dependencies = html_dependency_clean(),
    pandoc_args = pandoc_args,
    fig_width = fig_width,
    fig_height = fig_height,
    fig_caption = fig_caption,
    highlight = highlight,
    lightbox = lightbox,
    thumbnails = thumbnails,
    gallery = gallery,
    toc = toc,
    toc_depth = toc_depth,
    use_bookdown = use_bookdown,
    md_extensions = md_extensions,
    mathjax = mathjax,
    ...
  )
}

# html_clean js and css
html_dependency_clean <- function() {
  
  list(
    htmltools::htmlDependency(name = "clean",
                              version = "0.1",
                              src = system.file("templates/html_clean", package = "rmdformats"),
                              script = "clean.js",
                              stylesheet = "clean.css"),
       htmltools::htmlDependency(name = "webex",
                                 version = "0.1",
                                 src = system.file("", package = "webex"),
                                 script = c("js/webex.js",
                                            "js/micromodal.min.js", 
                                            "js/psystats.js", 
                                            "js/diff_match_patch.js"),
                                 
                                 stylesheet = c("css/webex.css", 
                                                "css/psystats.css", 
                                                "css/video.css"))
       
       
  )
}
  
  
  
