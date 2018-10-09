


slides <- "https://stat.mikewk.com/slides/07-slides.html"
assign <- "https://stat.mikewk.com/assignment/06-hw.Rmd"


date <- gsub("\\s", "", format(Sys.Date(), "%b %e"))
topic <- "lm-anova"
coursedir <- paste0("journ-8016-", date, "-", topic)

home_dir <- normalizePath("~")

## functions to help find desktop
back_one <- function(x) normalizePath(file.path(x, ".."))
has_desktop <- function(x) {
  "Desktop" %in% list.dirs(x, full.names = FALSE, recursive = FALSE)
}
list_dirs <- function(d, depth = 1, all = FALSE) {
  i <- 1
  while (i <= depth) {
    d <- list.dirs(d, recursive = FALSE)
    if (!all) {
      d <- d[grep("^\\.", basename(d), invert = TRUE)]
    }
    i <- i + 1
  }
  d
}
has_perm <- function(x) {
  x <- suppressWarnings(file.mode(x))
  x > as.octmode("700")
}


## start with home_dir
d <- home_dir

## find desktop
while (!has_desktop(d)) {
  d_ <- back_one(d)
  if (identical(d, d_)) break
  d <- d_
}

## if still no desktop, try current working directory
if (!has_desktop(d)) {
  d <- getwd()
}

## now try to find desktop
while (!has_desktop(d)) {
  d_ <- back_one(d)
  if (identical(d, d_)) break
  d <- d_
}


if (.Platform$OS.type == "windows") {
  d <- "C:/Users"
  username <- Sys.getenv("USERNAME")
  if (!identical(username, "")) {
    d <- paste0(d, "/", username)
  }
  ds <- list_dirs(d, 3)
  ds <- grep("Desktop", ds, value = TRUE)
  if (length(ds) > 0 && any(has_perm(ds))) {
    d <- ds[which(has_perm(ds))[1]]
  }
}

if (!grepl("Desktop$", d) && has_desktop(d)) {
  d <- file.path(d, "Desktop")
}

## if still no desktop, then use home directory
if (!grepl("Desktop$", d)) {
  d <- home_dir
}

d <- file.path(d, coursedir)
dd <- d
i <- 1L

while (dir.exists(dd)) {
  dd <- paste0(d, "-", i)
  i <- i + 1
}

tmp <- tempfile()

download.file("https://github.com/mkearney/stat/archive/master.zip", 
  tmp)

dir.create(dd)

unzip(tmp, exdir = dd)

file.rename(file.path(dd, "stat-master"), file.path(dd, "stat"))

## open with Rstudio
browseURL(file.path(dd, "stat", "stat.Rproj"))
