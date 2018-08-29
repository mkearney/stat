
is_file <- function(x) {
  length(x) == 1 && is.character(x) && file.exists(x)
}

is_csv <- function(x) {
  is_file(x) && grepl("\\.csv$", x)
}


#' read qualtrics CSV
#' 
#' Reads and formats data exported from qualtrics.
#' 
#' @param Path to CSV exported from Qualtrics
#' @return A tibble
#' @export
read_qualtrics <- function(x) {
  ## check to make sure it's a valid csv file
  is_csv(x)
  ## read first three rows
  vars <- read.csv(x, header = TRUE, stringsAsFactors = FALSE)
  x <- vars[c(3:nrow(vars)), ]
  vars <- vars[1, , drop = TRUE]
  tmp <- tempfile(fileext = ".csv")
  write.csv(x, tmp, row.names = FALSE)
  x <- suppressMessages(readr::read_csv(tmp))
  ## rename some columns
  old <- c("StartDate", "EndDate", "Duration..in.seconds.", "LocationLatitude","LocationLongitude")
  new <- c("start",     "end",     "duration",              "lat",             "lng")
  names(x)[names(x) %in% old] <- new
  
  ## lowercase names
  names(x) <- tolower(names(x))
  
  ## convert to tibble
  x <- tibble::as_tibble(x)
  
  ## add text (other box entries) columns
  attr(x, "descriptions") <- vars
  x
}

is_likert5 <- function(x) {
  if (is.factor(x)) {
    x <- as.character(x)
  }
  if (!is.character(x)) return(FALSE)
  o <- unique(x)
  if (length(o) > 6) return(FALSE)
  if (all(is.na(o))) return(FALSE)
  l <- c("^agree\\s?strong\\S{0,}$|^strong\\S{0,}\\s?agree$", 
    "^disagree\\s?strong\\S{0,}$|^strong\\S{0,}\\s?disagree$", 
    "^agree$", "^disagree$", "^neither")
  all(vapply(l, function(x) any(!grepl(x, o, ignore.case = TRUE)), logical(1), USE.NAMES = FALSE))
}

recode_likert <- function(x) {
  if (!is_likert5(x)) return(x)
  ifelse(grepl("^agree\\s?strong\\S{0,}$|^strong\\S{0,}\\s?agree$", x, ignore.case = TRUE), 5, 
    ifelse(grepl("^agree$", x, ignore.case = TRUE), 4,
      ifelse(grepl("^neither", x, ignore.case = TRUE), 3, 
        ifelse(grepl("^disagree$", x, ignore.case = TRUE), 2,
          ifelse(grepl("^disagree\\s?strong\\S{0,}$|^strong\\S{0,}\\s?disagree$", 
                       x, ignore.case = TRUE), 1, NA_real_)))))
}

recode_likerts <- function(x) {
  x[1:ncol(x)] <- lapply(x, recode_likert)
  x
}


