---
---

## What is the tidyverse? 

The [tidyverse](https://www.tidyverse.org/) is an "opinonated collected of R packages designed for data science." There are multiple packages designed to tackle each stage of the data science workflow (importing, transforming, visualizing, modeling, etc.). All of the packages are unified by common design philosophies and data structures. 
{:.notes}

set of packages that share a high-level design philosophy and low-level grammar and data structures, so that learning one package makes it easier to learn the next

alternatives: base R, which prioritizes stability, and data.table which prioritizes concision and performance

===

## Core Tidyverse

Load the tidyverse meta-package using:



~~~r
library(tidyverse)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


These are the 8 packages now loaded into your environment:

| Package    | Purpose                       |  Prominent functions | 
|------------+-------------------------------+----------------------|
| `readr`    |  read flat files              | `read_csv`, `write_csv` |
| `tidyr`    |  reshaping                    | `pivot_longer`, `pivot_wider` |
| `dplyr`    |  wrangling                    | `filter`, `select`, `summarise` |
| `ggplot2`  |  visualization                | `ggplot`, `aes` |
| `stringr`  |  control character vectors    | `str_sub`, `str_pad` |
| `tibble`   |  opinionated data frames      | `glimpse`, `rownames_to_column`|
| `forcats`  |  control categorical data     | `fct_relevel`, `fct_anon` |
| `purrr`    |  functional programming       | `map`, `walk`, `pmap` |

===

## Expanded tidyverse

What took so long to install then? `install.packages("tidyverse")` also installs these 15 other packages:

| Package    | Purpose                       |
|------------+-------------------------------|
| `broom`     |                |
| `dbplyr`    |                      |
| `haven`     |                      |
| `hms`       |                  |
| `httr`      |      |
| `jsonlite`  |        |
| `lubridate` |       |
| `magrittr`  |         |
| `modelr`    | |
| `pillar`    | |
| `readxl`    | |
| `reprex`    | |
| `rlang`     | |
| `rvest`     | |
| `xml2`      | |

and their 66 dependencies including `fs`, `glue`, and `scales` which we will use in this lesson.

===

