
is_file <- function(x) {
  length(x) == 1 && is.character(x) && file.exists(x)
}

is_csv <- function(x) {
  is_file(x) && grepl("\\.csv$", x)
}



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
  x <- tibble::as_tibble(x, validate = FALSE)
  
  ## add text (other box entries) columns
  attr(x, "descriptions") <- vars
  x
}


recode_likert <- function(x) {
  if (!any(grepl("^agree$", x, ignore.case = TRUE))) return(x)
  ifelse(grepl("strongly agree|^agree strongly", x, ignore.case = TRUE), 5, 
    ifelse(grepl("^agree$", x, ignore.case = TRUE), 4,
      ifelse(grepl("neither", x, ignore.case = TRUE), 3, 
        ifelse(grepl("^disagree$", x, ignore.case = TRUE), 2,
          ifelse(grepl("strongly disagree|^disagree strongly", x, ignore.case = TRUE), 1, NA_real_)))))
}

recode_likerts <- function(x) {
  chr <- vapply(x, is.character, logical(1))
  x[chr] <- lapply(x[chr], recode_likert)
  x
}


