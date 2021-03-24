
<!-- README.md is generated from README.Rmd. Please edit that file -->

Below is a quick way to seamlessly integrate a graphical timeline into a
reactable. Works with `POSIXct` and `hms`.

## Copy below code.

``` r
library(tidyverse)
library(lubridate) # needed for time_length()
library(htmltools) # needed for div()

convert_timestamps <- function(t1, t2) {
  # extract timestamp range
  t01 <- min(t1)
  t02 <- max(t2)

  # normalize event timestamps within total range
  left <- time_length(t1 - t01)/time_length(t02 - t01)
  width <- time_length(t2 - t1)/time_length(t02 - t01)

  # splice values into list
  out <- list()

  for (i in 1:length(left)) {
    out[[i]] <- list(left[i], width[i])
  }

  out
}

create_timeline_bar <- function(left = 0, width = "100%", fill = "#00bfc4") {
  left <- scales::percent(left)
  width <- scales::percent(width)

  bar <- div(style = list(
    position = "absolute",
    left = left,
    background = fill,
    width = width,
    height = "140%")
  )

  chart <- div(style = list(
    flexGrow = 1,
    position = "relative",
    display = "flex",
    alignItems = "center",
    height = "100%"
  ),
  bar)

  div(style = list(
    height = "100%"
  ),
  chart)
}
```

## Usage Example

For more details, see my [blog
post](https://sccm.io/post/reactable-timeline/).

``` r
library(reactable)

sales <- readr::read_csv("https://raw.githubusercontent.com/sccmckenzie/reactable-timeline/master/sales.csv")

sales %>%
  mutate(timeline = convert_timestamps(enter, exit)) %>%
  reactable(columns = list(
              timeline = colDef(
                cell = function(value) {
                  create_timeline_bar(left = value[[1]], width = value[[2]])
                }
              )
            )
  )
```

![](readme-preview.png)
