#' Create an engine to allow block-style hints: like ```{hint} button text / hint text
#' The first line of the block is used as the button text, all other lines are rendered 
#' as markdown and included in the hidden-by-default div
#' @export
eng_hint = function(options) {
  button <- paste0("<button class='solution-button'>", knitr::knit(textConnection(options$code[1])), "</button>", collapse = "\n")
  hint <- knitr::knit(textConnection(paste(c(options$code[-1], "\n\n"))))
  paste(c("<div class='solution'>",
          button, hint, "</div>"),
        collapse = '\n')
}

#' Create fill-in-the-blank question
#'
#' @param answer The correct answer
#' @param width Width of the input box in characters. Defaults to the length of the longest answer.
#' @param num whether the input is numeric, in which case allow for leading zeroes to be omitted
#' @param calculator whether the input should be eval'd in the local javascript environment. Defaults to `num``
#' @param calculator_digits number significant digits to show
#' @param tol the tolerance within which numeric answers will be accepts; i.e. (response - true.answer) < tol = a correct response. Implies num=TRUE
#' @param ignore_case Whether to ignore case (capitalization)
#' @param ignore_ws Whether to ignore white space
#' @param regex Whether to use regex to match answers (concatenates all answers with `|` before matching)
#' @details Writes html code that creates an input box widget. Call this function inline in an RMarkdown document. See the Web Exercises RMarkdown template for examples.
#' @export
fitb <- function(answer, 
                 width = calculated_width, 
                 num = FALSE,
                 tol=NULL,
                 calculator = num,
                 calculator_digits = 4,
                 ignore_case = FALSE,
                 ignore_ws = TRUE, 
                 regex=FALSE) {
  
  
  if(!is.null(tol)){
    num <- TRUE
  } 

  if (num) {
    answer2 <- strip_lzero(answer)
    answer <- union(answer, answer2)
  }
  
  # if width not set, calculate it from max length answer, up to limit of 100. 
  # Add 6 spaces if calculation =TRUE to allow space to enter calculations
  calculated_width <- max(2, min(100, max(purrr::map_int(answer, nchar))))
  qid <-  round(runif(1, 0, 10^6))
  answers <- jsonlite::toJSON(as.character(answer))
  paste0(
    "<span class='webex-fitb' id = 'Q", qid ,"' >",
    "<input ",
    "class='solveme ",
         ifelse(ignore_ws, " nospaces", ""),
         ifelse(ignore_case, " ignorecase", ""),
         ifelse(calculator, " calculator", ""),
         ifelse(regex, " regex ", ""),
    "'", 
    ifelse(!is.null(tol), paste0(" data-tol=", tol, ""), ""),
    paste0(" data-digits=", calculator_digits, ""),
          " size=", width, " ",
          " style='width:", width, "em;' ",
         " data-answer='", answers, "'/>",
         "<span class='solvedme'></span>",
    "</span>"
         )
}
fitb(answer=2)
#' Create multiple choice question
#'
#' @param opts Vector of alternatives. The correct answer is the element(s) of this vector named 'answer'. See the Web Exercises RMarkdown template for examples.
#' @details Writes html code that creates an option box widget. Call this function inline in an RMarkdown document. See the Web Exercises RMarkdown template for examples.
#' @export
mcq <- function(opts) {
  ix <- which(names(opts) == "answer")
  if (length(ix) == 0) {
    stop("MCQ has no correct answer")
  }
  answers <- jsonlite::toJSON(as.character(opts[ix]))
  options <- paste0(" <option>",
                    paste(c("", opts), collapse = "</option> <option>"),
                    "</option>")
  paste0("<select class='solveme' data-answer='", answers, "'>",
         options, "</select>")
}

#' Create true-or-false question
#'
#' @param answer Logical value TRUE or FALSE, corresponding to the correct answer.
#' @details Writes html code that creates an option box widget with TRUE or FALSE as alternatives. Call this function inline in an RMarkdown document. See the Web Exercises RMarkdown template for examples.
#' @export
torf <- function(answer) {
  opts <- c("TRUE", "FALSE")
  if (answer)
    names(opts) <- c("answer", "")
  else
    names(opts) <- c("", "answer")
  mcq(opts)
}

#' Create a modal with hint content
modal_template <- '
<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#{modalid}">
{label}
</button>

<!-- Modal -->
<div class="modal fade" id="{modalid}" tabindex="-1" role="dialog" aria-labelledby="{modalid}Label" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <!-- 
      <div class="modal-header">
        <h5 class="modal-title" id="{modalid}Label">Modal title</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
    -->
      <div class="modal-body">
{tip}
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary">Save changes</button>
      </div>
    </div>
  </div>
</div>
'


quicktip <- function(label="Show tips", tip = "TIP TEXT HERE") {
  whisker::whisker.render(modal_template, list(tip=tip, modalid=runif(1, 1, 1e7)) )
}
quicktip()


#' Create button revealing hidden HTML content
#'
#' @param button_text Text to appear on the button that reveals the hidden content
#' @seealso \code{unhide}
#' @details Writes HTML to create a content that is revealed by a button press. Call this function inline in an RMarkdown document. Any content appearing after this call up to an inline call to \code{unhide()} will only be revealed when the user clicks the button. See the Web Exercises RMarkdown Template for examples.
#' @export
hide <- function(button_text = "Solution") {
  paste0("\n<div class='solution'><button class='solution-button'>", button_text, "</button>\n")
}

#' End hidden HTML content
#'
#' @seealso \code{hide}
#' @details Call this function inline in an RMarkdown document to mark the end of hidden content (see the Web Exercises RMarkdown Template for examples).
#' @export
unhide <- function() {
  paste0("\n</div>\n")
}

#' Round up from .5
#'
#' @param x a numeric string (or number that can be converted to a string)
#' @param digits integer indicating the number of decimal places (`round`) or significant digits (`signif`) to be used.
#' @details Implements rounding using the "round up from .5" rule, which is more conventional than the "round to even" rule implemented by R's built-in \code{\link{round}} function. This implementation was taken from (https://stackoverflow.com/a/12688836).
#' @export
round2 = function(x, digits = 0) {
  posneg = sign(x)
  z = abs(x)*10^digits
  z = z + 0.5
  z = trunc(z)
  z = z/10^digits
  z*posneg
}

#' Strip leading zero from numeric string
#'
#' @param x a numeric string (or number that can be converted to a string)
#' @return a string with leading zero removed
#' @export
strip_lzero <- function(x) {
  sub("^([+-]*)0\\.", "\\1.", x)
}





