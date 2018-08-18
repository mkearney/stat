
if (FALSE) {
  conf <- buildrcourse:::class_config("JOURN 8016", name = "Mike Kearney",
    job_title = "Assistant Professor, Journalism Studies | Data Science & Analytics",
    institution = "University of Missouri", gravatar_email = "mike.wayne.kearney@gmail.com",
    twitter = "kearneymw", institution_short = "Mizzou",
    department = "School of Journalism",
    department_url = "Https://journalism.missouri.edu",
    repo = "mkearney/journ8016")
  
  mu <- buildrcourse::class_dates_mizzou("2018-19", "Fall", "T")
  j <- buildrcourse::class_schedule(class_name = "journ8016")
  #writeLines(conf, "config.toml")
}

blogdown::hugo_build()
x <- blogdown::serve_site()
blogdown::stop_server(x)

?httr::oauth_app
getOption("encoding")
