---
---

## Summary

As you have seen, some core principles of the tidyverse

* Packages are united by common design structures so they work together (e.g. tidy evaluation)
* Functions emphasize *modularity* so you can break complex problems into small parts
* Functions emphasize *consistency* so you can easily expect what they will return
* Designed to write code that is **easy to read** and interpret

These are some of the cool functions we learned about

| Function    | Package |  Usage    | Base R version |
|-------------+---------+--------+----------------|
| `map` & friends | purrr|  iterate over objects | sapply, lapply |
| `glue` | glue | combining strings | paste0 |
| `case_when` | dplyr | if else | if else |
|-------------+---------+--------+----------------|
| `dir_ls` | fs | list files in a directory | list.files |
| `spec_csv` | readr |  column specification  | ? |
| `rename_with` | dplyr | use a function to rename columns | ? |
| `mdy` & friends | lubridate | smart date guessing | as.Date |
| `element_markdown()` | ggplot2 | plot text formatting | ? |
| `show_col` | scales | display colors | ? |
| `fct_reorder` | forcats | reorder factors | levels, reorder |
| `expand` & friends | tidyr | generate variable combinations | expand.grid |

Some other topics about the tidyverse that are worth looking into but we didn't cover here:

* **tidymodels** - A framework for modeling and machine learning using tidy principles, including a [website](https://www.tidymodels.org/) extensive resources to learn about creating and tuning models. [broom](){:.rlib} installs with tidyverse and is helpful for tidying up output from commonly used models such as `lm` or `cor.test`
* Deeper into **rlang** - To learn more about using tidy evaluation in functions, refer to this [dplyr vignette](https://dplyr.tidyverse.org/articles/programming.html#one-or-more-user-supplied-expressions), the documentation and cheatsheet for [rlang](https://rlang.r-lib.org/), or [one](https://www.youtube.com/watch?v=nERXS3ssntw) of [these](https://www.youtube.com/watch?v=2-gknoyjL3A) [videos](https://www.youtube.com/watch?v=2BXPLnLMTYo) from the tidyverse developers. 
* Functions in [purrr](){:.rlib} to manipulate lists, and [list columns](https://r4ds.had.co.nz/many-models.html#list-columns-1) in [tibble](){:.rlib} data frames that can be nested and unnested
* Interval, period, and duration objects in [lubridate](){:.rlib}

