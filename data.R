library(tidyverse)
library(lubridate)

# Dataset 1

t01 <- now() - ddays(7)
t02 <- now()

set.seed(17)

event_df <- tibble(event = 1:10) %>%
  rowwise() %>%
  mutate(t = list(
    sort(runif(2, t01, t02)) %>%
      setNames(., c("t1", "t2"))
    )) %>%
  unnest_wider(t) %>%
  mutate(across(t1:t2, as_datetime))

event_df %>%
  write_rds("event_df.rds")

# Dataset 2

t01 <- as_datetime("2020-02-03 08:00:00")
t02 <- as_datetime("2020-02-03 19:00:00")

set.seed(27)

n <- 10

customer_df <- tibble(customer = 1:n,
       enter = runif(n, t01, t02) %>% as_datetime(),
       exit = enter + rbeta(n, 2, 2.5) * dhours(2),
       revenue = time_length(exit - enter, unit = "hours") * 30 + rnorm(n, mean = 0, sd = 15)) %>%
  mutate(revenue = if_else(revenue < 0, 0, revenue)) %>%
  relocate(revenue, .before = enter)

# customer_df %>%
#   mutate(revenue, l = time_length(exit - enter, unit = "hours")) %>%
#   ggplot(aes(l, revenue)) +
#   geom_point()

customer_df %>%
  write_rds("customer_df.rds")

customer_df %>%
  write_csv("customer_df.csv")
