suppressPackageStartupMessages(library(tidyverse))

udocs <- sub("\\.Rmd$", "", list.files("static/slides", pattern = "\\.Rmd$"))

since_modified <- function(file, units = "days") {
  mtime <- file.info(file)$mtime
  as.numeric(difftime(Sys.time(), mtime, tz = Sys.timezone(), units = units))
}

input1 <- normalizePath(sprintf("static/slides/%s.Rmd", udocs))
static_rmd <- since_modified(input1)
docs_html <- normalizePath(sprintf("docs/slides/%s.html", udocs), mustWork = FALSE)
docs_html <- since_modified(docs_html)

udocs1 <- input1[static_rmd < docs_html]
if (length(udocs1) > 0) {
  cat("\nUpdating", length(udocs1), "slides...", fill = TRUE)
  udocs2 <- sub("static/slides", "docs/slides", udocs1)
  sh <- Map(file.copy, udocs1, udocs2, overwrite = TRUE)
  
  if (!dir.exists("docs/slides/data")) {
    dir.create("docs/slides/data")
  }
  system("cp -rf static/slides/data/ docs/slides/data/")
  sh <- lapply(udocs2, rmarkdown::render)
} else {
  cat("\nAll slides are up to date!", fill = TRUE)
}

## cleanup
#unlink(sprintf("static/slides/%s.html", udocs))
unlink(list.files("docs/slides", pattern = "\\.Rmd$", full.names = TRUE))
unlink("static/slides/lib", recursive = TRUE)
unlink("docs/slides/lib", recursive = TRUE)
unlink("docs/slides/data", recursive = TRUE)
unlink("docs/data", recursive = TRUE)
unlink("docs/slides/R", recursive = TRUE)
unlink("docs/archives", recursive = TRUE)
unlink("docs/categories", recursive = TRUE)
unlink("docs/tags", recursive = TRUE)
unlink("docs/reading/stats-unplugged-cor.pdf", recursive = TRUE)
