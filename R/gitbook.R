#' The replacement function
gitbook_dependency = function(table_css) {
  assets = bookdown_file('resources', 'gitbook')
  owd = setwd(assets); on.exit(setwd(owd), add = TRUE)
  app = if (file.exists('js/app.min.js')) 'app.min.js' else 'app.js'
  list(jquery_dependency(), 
       htmltools::htmlDependency(name = "webex",
                                 version = "0.1",
                                 src = system.file("", package = "webex"),
                                 script = c("js/webex.js", "js/psystats.js"),
                                 stylesheet = c("css/webex.css", "css/psystats.css")), 
      htmltools::htmlDependency(
    'gitbook', '2.6.7', src = assets,
    stylesheet = file.path('css', c(
      'style.css', if (table_css) 'plugin-table.css', 'plugin-bookdown.css',
      'plugin-highlight.css', 'plugin-search.css', 'plugin-fontsettings.css'
    )),
    script = file.path('js', c(
      app, 'lunr.js', 'plugin-search.js', 'plugin-sharing.js',
      'plugin-fontsettings.js', 'plugin-bookdown.js', 'jquery.highlight.js'
    ))
  ))
}

