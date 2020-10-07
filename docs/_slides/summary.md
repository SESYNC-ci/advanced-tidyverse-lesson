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

* **tidymodels** especially the broom package
* **rlang** - To learn more about using tidy evaluation in functions, refer to this [dplyr vignette](https://dplyr.tidyverse.org/articles/programming.html#one-or-more-user-supplied-expressions), the documentation and cheatsheet for [rlang](https://rlang.r-lib.org/), or one [of](https://www.youtube.com/watch?v=nERXS3ssntw) [these](https://www.youtube.com/watch?v=2-gknoyjL3A) [videos](https://www.youtube.com/watch?v=2BXPLnLMTYo) from a tidyverse developer. 
* **list columns** for nesting and unnesting things within data frames
* Functions for modifying lists and parts of lists in purrr
* Interval, period, and duration objects in lubridate

