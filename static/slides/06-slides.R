library(mwk)

x <- sample(0:100, 200, replace = TRUE)
o <- order(x)
x <- x[o]
y <- seq_along(x) + runif(length(x), -100, 100)
ggplot(data.frame(x, y), aes(x = x, y = y)) + 
  geom_point() + 
  labs(x = "X variable", y = "Y variable", title = "Scatter plot of y by x",
    subtitle = "Randomly generated values for demonstration only", 
    caption = theme_mwk_caption_text()) + 
  ggsave("img/06-1.png", width = 6, height = 4, units = "in")
ggplot(data.frame(x, y), aes(x = x, y = y)) + 
  geom_point() + 
  labs(x = "X variable", y = "Y variable", title = "Scatter plot of y by x",
    subtitle = "Randomly generated values for demonstration only", 
    caption = theme_mwk_caption_text()) + 
  geom_smooth(method = "lm", se = FALSE) + 
  ggsave("img/06-2.png", width = 6, height = 4, units = "in")

x <- sample(0:100, 25, replace = TRUE)
o <- order(x)
x <- x[o]
y <- seq_along(x) + runif(length(x), -100, 100)
ggplot(data.frame(x, y), aes(x = x, y = y)) + 
  geom_point() + 
  labs(x = "X variable", y = "Y variable", title = "Scatter plot of y by x",
    subtitle = "Randomly generated values for demonstration only", 
    caption = theme_mwk_caption_text()) + 
  ggsave("img/06-3.png", width = 6, height = 4, units = "in")
ggplot(data.frame(x, y), aes(x = x, y = y)) + 
  geom_point() + 
  labs(x = "X variable", y = "Y variable", title = "Scatter plot of y by x",
    subtitle = "Randomly generated values for demonstration only", 
    caption = theme_mwk_caption_text()) + 
  geom_smooth(method = "lm", se = FALSE) + 
  ggsave("img/06-4.png", width = 6, height = 4, units = "in")


x <- sample(0:100, 200, replace = TRUE)
o <- order(x)
x <- x[o]
y <- 1 + runif(length(x), -100, 100)
ggplot(data.frame(x, y), aes(x = x, y = y)) + 
  geom_point() + 
  labs(x = "X variable", y = "Y variable", title = "Scatter plot of y by x",
    subtitle = "Randomly generated values for demonstration only", 
    caption = theme_mwk_caption_text()) + 
  ggsave("img/06-5.png", width = 6, height = 4, units = "in")
ggplot(data.frame(x, y), aes(x = x, y = y)) + 
  geom_point() + 
  labs(x = "X variable", y = "Y variable", title = "Scatter plot of y by x",
    subtitle = "Randomly generated values for demonstration only", 
    caption = theme_mwk_caption_text()) + 
  geom_smooth(method = "lm", se = FALSE) + 
  ggsave("img/06-6.png", width = 6, height = 4, units = "in")


## count data
x <- c(0, sample(1:30, 175, replace = TRUE), sample(41:100, 25, replace = TRUE), 100)
o <- order(x)
x <- x[o]
y <- seq_along(x) + rnorm(length(x), -50, 50)
y[150:200] <- y[150:200] - seq_len(51)
ggplot(data.frame(x, y), aes(x = x, y = y)) + 
  geom_point() + 
  labs(x = "X variable", y = "Y variable", title = "Scatter plot of y by x",
    subtitle = "Randomly generated values for demonstration only", 
    caption = theme_mwk_caption_text()) + 
  ggsave("img/06-7.png", width = 6, height = 4, units = "in")
ggplot(data.frame(x, y), aes(x = x, y = y)) + 
  geom_point() + 
  labs(x = "X variable", y = "Y variable", title = "Scatter plot of y by x",
    subtitle = "Randomly generated values for demonstration only", 
    caption = theme_mwk_caption_text()) + 
  geom_smooth(method = "lm", se = FALSE) + 
  ggsave("img/06-8.png", width = 6, height = 4, units = "in")


