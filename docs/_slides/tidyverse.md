---
---

## What is the tidyverse? 

The [tidyverse](https://www.tidyverse.org/) is an "opinonated collected of R packages designed for data science." There are multiple packages designed to tackle each stage of the data science workflow (importing, transforming, visualizing, modeling, etc.). All of the packages are unified by common design philosophies and data structures. 
{:.notes}

set of packages that share a high-level design philosophy and low-level grammar and data structures, so that learning one package makes it easier to learn the next

alternatives: base R, which prioritizes stability, and data.table which prioritizes concision and performance

Load the tidyverse meta-package using



~~~r
library(tidyverse)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}



===

## Core Tidyverse

These are the 8 packages that are loaded with `library(tidyverse)`

| Package    | Purpose                       |
|------------+-------------------------------|
| `readr`    |  read flat files              |
| `tidyr`    |  reshaping                    |
| `dplyr`    |  wrangling                    |
| `ggplot2`  |  visualization                |
| `stringr`  | control character vectors     |
| `tibble`   | opinionated data frames       |
| `forcats`  | control categorical data      |
| `purrr`    | functional programming        |

===

## Expanded tidyverse

`install.packages("tidyverse")` also installs 15 other packages

- `broom`, `dbplyr`, `haven`, `hms`, `httr`, `jsonlite`, `lubridate`, `magrittr`, `modelr`, `pillar`, `readxl`, `reprex`, `rlang`, `rvest`, `xml2`

and their 66 dependencies

- including `fs`, `glue`, `scales`, `RColorBrewer`

===

