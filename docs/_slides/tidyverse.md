---
---

## What is the tidyverse? 

The [tidyverse](https://www.tidyverse.org/) is *an opinionated collection of R packages designed for data science*. There are multiple packages designed to tackle each stage of the data science workflow (depicted below), unified by common design philosophies and data structures. 

![]({% include asset.html path="images/tidy-packages.png" %}){: width="75%"}  
*How tidyverse packages fit into a canonical data science workflow.  [source](https://rviews.rstudio.com/2017/06/08/what-is-the-tidyverse/)*
{:.captioned}

Because packages share a high-level design philosophy and low-level grammar and data structures, learning one package should make it easier to learn the next. Tidyverse packages are designed to work best with [tidy](https://r4ds.had.co.nz/tidy-data.html) data frames, and emphasize **readability**, **consistency**, and **modularity**.

These are not strictly alternatives but you might compare it to using either: only using base R, which prioritizes stability (i.e. doesn't change as quickly), or [data.table](https://rdatatable.gitlab.io/data.table/), which prioritizes speed and concise syntax. 

If you want to up with new developments in the tidyverse, check out their [blog](https://www.tidyverse.org/blog/), videos from the [RStudio conferences](https://rstudio.com/resources/rstudioconf-2020/), or follow the developers on Twitter. 

===

## Core Tidyverse

Load the tidyverse meta-package using:



~~~r
library(tidyverse)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
── Attaching packages ──────────── tidyverse 1.3.0 ──
~~~
{:.output}


~~~
✓ ggplot2 3.3.2     ✓ purrr   0.3.4
✓ tibble  3.0.3     ✓ dplyr   1.0.2
✓ tidyr   1.1.2     ✓ forcats 0.5.0
✓ readr   1.3.1     
~~~
{:.output}


~~~
── Conflicts ─────────────── tidyverse_conflicts() ──
x dplyr::filter() masks stats::filter()
x dplyr::lag()    masks stats::lag()
~~~
{:.output}


This loads the 8 "core" tidyverse packages into your environment:

| Package    | Purpose                       |  Prominent functions | 
|------------+-------------------------------+----------------------|
| `readr`    |  read flat files              | `read_csv`, `write_csv` |
| `tidyr`    |  reshaping                    | `pivot_longer`, `pivot_wider` |
| `dplyr`    |  wrangling                    | `filter`, `select`, `summarize` |
| `ggplot2`  |  visualization                | `ggplot`, `aes` |
| `stringr`  |  control character vectors    | `str_sub`, `str_pad` |
| `tibble`   |  opinionated data frames      | `glimpse`, `rownames_to_column`|
| `forcats`  |  categorical data             | `fct_relevel`, `fct_anon` |
| `purrr`    |  iteration                    | `map`, `walk`, `pmap` |

===

## Expanded tidyverse

When you run `install.packages("tidyverse")` it also installs a number of other packages with more specialized uses, as well as many package dependencies such as [fs](){:.rlib} and [scales](){:.rlib}.  

| Purpose    | Packages                       |
|------------+-------------------------------|
| Importing data | `DBI`, `dbplyr`, `haven`, `httr`, `readxl`, `rvest`, `jsonlite`, `xml2` |
| Wrangling specific types of data | `lubridate`, `hms`, `blob` | 
| General programming | `magrittr`, `glue`, `reprex`, `rlang` |
| Modeling | `broom`, `modelr` |
| Under the hood | `pillar`, `rlang`, `cli`, `crayon` |

Use `tidyverse_deps(recursive = TRUE)` to see a list of all 89 tidyverse packages and dependencies. 

===

