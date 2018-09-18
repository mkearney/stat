library(tidyverse)

udocs <- sub("\\.Rmd$", "", list.files("static/slides", pattern = "\\.Rmd$"))

for (i in seq_along(udocs)) {
  input1 <- normalizePath(sprintf("static/slides/%s.Rmd", udocs[i]))
  input2 <- normalizePath(sprintf("docs/slides/%s.Rmd", udocs)[i], mustWork = FALSE)
  file.copy(input1, input2)
  rmarkdown::render(input2)
}
unlink(sprintf("static/slides/%s.html", udocs))
unlink(sprintf("docs/slides/%s.Rmd", udocs))
unlink("static/slides/lib", recursive = TRUE)
unlink("docs/slides/lib", recursive = TRUE)
unlink("docs/slides/data", recursive = TRUE)
unlink("docs/data", recursive = TRUE)
unlink("docs/slides/R", recursive = TRUE)
unlink("docs/archives", recursive = TRUE)
unlink("docs/categories", recursive = TRUE)
unlink("docs/tags", recursive = TRUE)
unlink("docs/reading/stats-unplugged-cor.pdf", recursive = TRUE)
