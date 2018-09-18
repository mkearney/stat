library(tidyverse)
since_modified <- function(x, units = "hours") {
  as.numeric(difftime(Sys.time(), file.info(x)$mtime, units = units))
}

full_rmds <- list.files("static/slides", full.names = TRUE, pattern = "\\.Rmd$")
rmds <- basename(full_rmds)
full_htmls <- list.files("docs/slides", full.names = TRUE, pattern = "\\.html$")
htmls <- basename(full_htmls)

comp_rmds <- full_rmds[match(sub("\\.Rmd", "", rmds), sub("\\.html", "", htmls))]
comp_htmls <- full_htmls[match(sub("\\.html", "", htmls), sub("\\.Rmd", "", rmds))]

since_html <- c(rep(NA_real_, length(rmds)), 
  as.numeric(difftime(
    file.info(full_htmls)$mtime,
    file.info(comp_rmds)$mtime, 
    units = "hours")))

since_rmd <- c(rep(NA_real_, length(htmls)), 
  as.numeric(difftime(
    file.info(full_rmds)$mtime,
    file.info(comp_htmls)$mtime, 
    units = "hours")))

fi <- data.frame(
  base_name = sub("\\.Rmd$|\\.html$", "", c(rmds, htmls)),
  name = c(rmds, htmls),
  path = c(full_rmds, full_htmls),
  type = c(rep("Rmd", length(rmds)), rep("html", length(htmls))),
  since_modified = c(since_modified(full_rmds), since_modified(full_htmls)),
  since_html = since_html,
  since_rmd = since_rmd,
  stringsAsFactors = FALSE
)

yesupdate <- fi %>%
  arrange(type) %>%
  select(base_name, since_modified) %>%
  group_by(base_name) %>%
  mutate(n = n()) %>%
  filter(n > 1) %>%
  summarise(since_rmd = since_modified[1] - since_modified[2]) %>%
  filter(since_rmd > 0) %>%
  pull(base_name)

fi$yesupdate <- fi$base_name %in% yesupdate

ustatic <- filter(fi, since_modified < 24)

udocs <- filter(fi, since_modified < .5 |
    (since_html > 0 & !is.na(since_html)) | 
    (since_rmd > 0 & !is.na(since_rmd)), 
  yesupdate)


for (i in seq_len(length(unique(udocs)))) {
  input <- normalizePath(sprintf("static/slides/%s.Rmd", unique(udocs$base_name)[i]))
  output1 <- normalizePath(sprintf("static/slides/%s.html", unique(udocs$base_name)[i]), mustWork = FALSE)
  output2 <- normalizePath(sprintf("docs/slides/%s.html", unique(udocs$base_name)[i]))
  rmarkdown::render(input)
  file.copy(output1, output2)
}
file.copy("static/slides/lib", "docs/slides", recursive = TRUE)
unlink(sprintf("static/slides/%s.html", unique(fi$base_name)))
unlink("static/slides/lib", recursive = TRUE)

