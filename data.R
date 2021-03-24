library(tidyverse)
library(lubridate)
library(hms)

t01 <- as_hms("08:00:00")
t02 <- as_hms("19:00:00")
n <- 10
set.seed(27)

sales <- tibble(c_id = 1:n,
                enter = runif(n, t01, t02) %>% as_hms(),
                exit = (enter + rbeta(n, 2, 2.5) * 7200) %>% as_hms(),
                revenue = time_length(exit - enter, unit = "hours") * 30 + rnorm(n, mean = 0, sd = 5)) %>%
  mutate(across(where(is_hms), round_hms, 60),
         revenue = round(revenue, 2)) %>%
  relocate(revenue, .before = enter)

sales %>%
  write_csv("sales.csv")
