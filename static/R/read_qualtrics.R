
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
  stopifnot(is_csv(x))
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
  if (!is.character(x)) return(FALSE)
  o <- unique(x)
  if (all(is.na(o))) return(FALSE)
  o <- tfse::na_omit(o)
  if (length(o) > 5) return(FALSE)
  
  ## likert choices
  l <- c(
    ## strong[ly]
    "^agree\\s{0,}strong\\S{0,}$|^strong\\S{0,}\\s{0,}agree$", 
    "^disagree\\s{0,}strong\\S{0,}$|^strong\\S{0,}\\s{0,}disagree$", 
    ## agree/disagree
    "^agree$", "^disagree$", 
    ## neither (midpoint)
    "neither|undecided|neutral")
  
  ## look for any choice that's not missing or likert
  all(vapply(l, function(x) {
    any(!grepl(x, o, ignore.case = TRUE)), logical(1), USE.NAMES = FALSE)
  })
}


is_likert7 <- function(x) {
  if (!is.character(x)) return(FALSE)
  o <- unique(x)
  if (all(is.na(o))) return(FALSE)
  o <- tfse::na_omit(o)
  if (length(o) > 7) return(FALSE)
  
  ## likert choices
  l <- c(
    ## strong[ly]
       "^agree\\s{0,}strong\\S{0,}$|^strong\\S{0,}\\s{0,}agree$", 
    "^disagree\\s{0,}strong\\S{0,}$|^strong\\S{0,}\\s{0,}disagree$", 
    ## moderate[ly]
       "^agree\\s{0,}moderate\\S{0,}$|^moderate\\S{0,}\\s{0,}agree$", 
    "^disagree\\s{0,}moderate\\S{0,}$|^moderate\\S{0,}\\s{0,}disagree$", 
    ## slight[ly]
       "^agree\\s{0,}slight\\S{0,}$|^slight\\S{0,}\\s{0,}agree$", 
    "^disagree\\s{0,}slight\\S{0,}$|^slight\\S{0,}\\s{0,}disagree$", 
    ## agree/disagree
    "^agree$", "^disagree$", 
    ## neither (midpoint)
    "neither|undecided|neutral")
  
  ## look for any choice that's not missing or likert
  all(vapply(l, function(x) {
    any(!grepl(x, o, ignore.case = TRUE)), logical(1), USE.NAMES = FALSE)
  })
}

prep_char_vector <- function(x) {
  ## if list of single-length elems
  if (is.list(x) && all(lengths(x) == 1L)) {
    x <- unlist(x)
  }
  ## convert to char
  if (is.factor(x)) {
    x <- as.character(x)
  }
  ## trim whitespace
  if (is.character(x)) {
    x <- tfse::trim_ws(x)
  }
  x
}

recode_likert <- function(x) {
  ## prep/coerce to char (if factor of single-elem list)
  x <- prep_char_vector(x)
  ## proceed if char
  if (!is.character(x)) return(x)
  if (is_likert5(x)) {
    ## recode
    ifelse(
      ## strong[ly] agree = 5
      grepl("^agree\\s{0,}strong\\S{0,}$|^strong\\S{0,}\\s{0,}agree$", 
        x, ignore.case = TRUE), 5L,
    ifelse(
      ## agree = 4
      grepl("^agree$", x, ignore.case = TRUE), 4L,
    ifelse(
      ## neither = 3
      grepl("neither|undecided|neutral", x, ignore.case = TRUE), 3L,
    ifelse(
      ## agree = 2
      grepl("^disagree$", x, ignore.case = TRUE), 2L,
    ifelse(
      ## strong[ly] disagree = 1
      grepl("^disagree\\s{0,}strong\\S{0,}$|^strong\\S{0,}\\s{0,}disagree$", 
        x, ignore.case = TRUE), 1L, NA_integer_)))))
  } else if (is_likert7(x) && any(grepl("slight", x, ignore.case = TRUE))) {
    ## recode
    ifelse(
      ## strong[ly] agree = 7
      grepl("^agree\\s{0,}strong\\S{0,}$|^strong\\S{0,}\\s{0,}agree$", 
        x, ignore.case = TRUE), 7L,
    ifelse(
      ## agree = 6
      grepl("^agree$", x, ignore.case = TRUE), 5L,
    ifelse(
      ## slight[ly] agree = 6
      grepl("^agree\\s{0,}slight\\S{0,}$|^slight\\S{0,}\\s{0,}agree$", 
        x, ignore.case = TRUE), 4L,
    ifelse(
      ## neither = 4
      grepl("neither|undecided|neutral", x, ignore.case = TRUE), 4L,
    ifelse(
      ## slight[ly] agree = 3
      grepl("^disagree\\s{0,}slight\\S{0,}$|^slight\\S{0,}\\s{0,}disagree$", 
        x, ignore.case = TRUE), 3L,
    ifelse(
      ## agree = 2
      grepl("^disagree$", x, ignore.case = TRUE), 2L,
    ifelse(
      ## strong[ly] disagree = 1
      grepl("^disagree\\s{0,}strong\\S{0,}$|^strong\\S{0,}\\s{0,}disagree$", 
        x, ignore.case = TRUE), 1L, NA_integer_)))))))
  } else if (is_likert7(x)) {
    ## recode
    ifelse(
      ## strong[ly] agree = 7
      grepl("^agree\\s{0,}strong\\S{0,}$|^strong\\S{0,}\\s{0,}agree$", 
        x, ignore.case = TRUE), 7L,
    ifelse(
      ## moderate[ly] agree = 6
      grepl("^agree\\s{0,}moderate\\S{0,}$|^moderate\\S{0,}\\s{0,}agree$", 
        x, ignore.case = TRUE), 6L,
    ifelse(
      ## agree = 5
      grepl("^agree$", x, ignore.case = TRUE), 5L,
    ifelse(
      ## neither = 4
      grepl("neither|undecided|neutral", x, ignore.case = TRUE), 4L,
    ifelse(
      ## agree = 3
      grepl("^disagree$", x, ignore.case = TRUE), 2L,
    ifelse(
      ## moderate[ly] agree = 2
      grepl("^disagree\\s{0,}moderate\\S{0,}$|^moderate\\S{0,}\\s{0,}disagree$", 
        x, ignore.case = TRUE), 2L,
    ifelse(
      ## strong[ly] disagree = 1
      grepl("^disagree\\s{0,}strong\\S{0,}$|^strong\\S{0,}\\s{0,}disagree$", 
        x, ignore.case = TRUE), 1L, NA_integer_)))))))
  }
}

recode_likerts <- function(x) {
  x[1:ncol(x)] <- lapply(x, recode_likert)
  x
}


