---
---

## Loading data

This lesson uses data modified from the [palmerpenguins](https://allisonhorst.github.io/palmerpenguins/index.html) package, which provides a dataset about 3 penguin species collected at [Palmer Station Antarctica LTER](https://pal.lternet.edu/). 

![]({% include asset.html path="images/lter_penguins.png" %}){: width="75%"}  
*Credit: [Artwork by @allison_horst](https://www.allisonhorst.com/)*
{:.captioned}


===

For this lesson, the data has been split up into separate files -- one for each study date when nests were observed. The sampling date is included in the file name but not in the data itself. Each row contains data on characteristics and measurements associated with one observation of a study nest. 

Our goal is to read in all 50 of those files from the **penguins** folder into one data frame, and add the sampling date from each file name in the data. We will do this using `map` functions in [purrr](){:.rlib}, the tidyverse workhorse for iteration. The inputs we will need are:

* (1) a list of objects to iterate over, and 
* (2) the function to apply to each one. 

Before seeing `purrr::map` in action, we will explore the inputs. 

===

The list of objects to iterate over is a vector of file names, which can be created using `dir_ls` in [fs](){:.rlib}. This package contains functions to work with files, filepaths, and directories. Most functions are named based on their [unix equivalent](https://fs.r-lib.org/articles/function-comparisons.html), with the corresponding prefix `file_`, `path_`, or `dir_`. 

Create a vector with all of the file names in the data/penguins folder:



~~~r
library(fs)
penguin_files <- dir_ls('data/penguins')
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

If we were interested in only a subset of files in that directory, we could filter them by supplying a pattern to the argument `glob` or `regexp`, such as "only files with the word `penguin` in the name ending in `.csv`". 



~~~r
> dir_ls('data/penguins', glob = "*penguins*.csv")
~~~
{:title="Console" .no-eval .input}



===

The function to apply to each of the file names is `read_csv` in [readr](){:.rlib}, such as



~~~r
> read_csv(file = penguin_files[1])
~~~
{:title="Console" .input}


~~~

── Column specification ────────────────────────────────────────────────────────
cols(
  studyName = col_character(),
  `Sample Number` = col_double(),
  Region = col_character(),
  Island = col_character(),
  Stage = col_character(),
  `Individual ID` = col_character(),
  `Clutch Completion` = col_character(),
  `Culmen Length (mm)` = col_double(),
  `Culmen Depth (mm)` = col_double(),
  `Flipper Length (mm)` = col_double(),
  `Body Mass (g)` = col_double(),
  Sex = col_character(),
  `Delta 15 N (o/oo)` = col_double(),
  `Delta 13 C (o/oo)` = col_double(),
  Comments = col_character(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
# A tibble: 8 x 17
  studyName `Sample Number` Region Island Stage `Individual ID` `Clutch Complet…
  <chr>               <dbl> <chr>  <chr>  <chr> <chr>           <chr>           
1 PAL0910                93 Anvers Biscoe Adul… N18A1           Yes             
2 PAL0910                94 Anvers Biscoe Adul… N18A2           Yes             
3 PAL0910               105 Anvers Biscoe Adul… N24A1           Yes             
4 PAL0910               106 Anvers Biscoe Adul… N24A2           Yes             
5 PAL0910               117 Anvers Biscoe Adul… N36A1           Yes             
6 PAL0910               118 Anvers Biscoe Adul… N36A2           Yes             
7 PAL0910               119 Anvers Biscoe Adul… N38A1           No              
8 PAL0910               120 Anvers Biscoe Adul… N38A2           No              
# … with 10 more variables: `Culmen Length (mm)` <dbl>, `Culmen Depth
#   (mm)` <dbl>, `Flipper Length (mm)` <dbl>, `Body Mass (g)` <dbl>, Sex <chr>,
#   `Delta 15 N (o/oo)` <dbl>, `Delta 13 C (o/oo)` <dbl>, Comments <chr>,
#   common <chr>, latin <chr>
~~~
{:.output}


Note in the output message that the object created is a [tibble](https://r4ds.had.co.nz/tibbles.html), which is [slightly different](https://blog.rstudio.com/2016/03/24/tibble-1-0-0/) than a typical data frame. For example, the displayed portion in the console is easier to read and contains the data type in each column. 

As also suggested by the output message, the data type for each column is determined automatically. The default [parses](https://readr.tidyverse.org/articles/readr.html#vector-parsers) the first 1,000 rows of the table, but the `col_types` argument offers more control. One way to specify column types is a character string the same length as the number of columns:

| character   | data type       |
|-------------+------------------|
| `c`    |  character/string    |
| `i`    |  integer             |
| `n`    |  numeric             |
| `d`    |  double              |
| `l`    | logical              |
| `f`    | factor/categorical   |
| `D`    | date             |
| `T`    | date time        |
| `t`    | time       |
| `?`    | guess      |
| `_` or `-` | skip this column |



~~~r
pg_df1 <- read_csv(penguin_files[1], col_types = "cdcccccddddcddccc")
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

Or use `spec_csv` to generate a column specification object that can be passed to the col_types argument. 



~~~r
my_col_types <- spec_csv(penguin_files[1])
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}



~~~r
> my_col_types
~~~
{:title="Console" .input}


~~~
cols(
  studyName = col_character(),
  `Sample Number` = col_double(),
  Region = col_character(),
  Island = col_character(),
  Stage = col_character(),
  `Individual ID` = col_character(),
  `Clutch Completion` = col_character(),
  `Culmen Length (mm)` = col_double(),
  `Culmen Depth (mm)` = col_double(),
  `Flipper Length (mm)` = col_double(),
  `Body Mass (g)` = col_double(),
  Sex = col_character(),
  `Delta 15 N (o/oo)` = col_double(),
  `Delta 13 C (o/oo)` = col_double(),
  Comments = col_character(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


===

## Map functions

The approach to iteration in the tidyverse is `map` functions in [purrr](){:.rlib}. Compared to `*apply` functions, these offer **predictable return objects** and **consistent syntax**. 

The arguments to `map` are: 

* `.x` - a list of things to iterate over
* `.f` - what to do for each item in `.x`

`.f` can be either the name of an existing function, or an "anonymous" function created from a formula. 

===

Read each of the `penguin_files` into a list using `~` formula syntax:



~~~r
pg_list <- map(.x = penguin_files, .f =  ~ read_csv(.x, col_types = my_col_types))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

Whereas `map` always returns a list, `map_*` functions return specific types of vectors such as `map_chr` for character vectors or `map_int`for integer vectors. Use `map_dfr` for returning *one* dataframe:



~~~r
pg_df <- map_dfr(penguin_files, ~read_csv(.x, col_types = my_col_types))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}



===

Another handy argument for `map_dfr` is `.id`, which adds a column with the names of each item in `.x`. 



~~~r
pg_df <- map_dfr(penguin_files, ~read_csv(.x), .id = "filename")
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

## Combine operations with pipes


![pipe]({% include asset.html path="images/pipe.jpeg" %}){: width="50%"}

Remember the `%>%` ? 

Readability is one of the core tenets of the tidyverse and this is accomplished with piped workflows. The functions are designed to work together based on the first argument and the type of output returned. 
{:.notes}

===

Let's combine our previous steps together without creating intermediate objects:



~~~r
pg_df <- dir_ls("data/penguins") %>%
  map_dfr(~read_csv(.x), .id = "filename")
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


This code creates a vector of file names with `dir_ls()`, and then "maps" the `read_csv()` function over each file. The output of each `read_csv()` function is row-binded (i.e. combined) together into one dataframe called `pg_df`, with an additional column containing the filename that each row of data came from. 

===

