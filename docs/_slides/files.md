---
---

## Read in data

We'll be using the data modified from the [palmerpenguins](https://allisonhorst.github.io/palmerpenguins/index.html) package, which provides a dataset about 3 different species of penguins collected at [Palmer Station Antarctica LTER](https://pal.lternet.edu/). 

![]({% include asset.html path="images/lter_penguins.png" %}){: width="50%"}  
*Credit: [Artwork by @allison_horst](https://www.allisonhorst.com/)*
{:.captioned}


===

For this lesson, the data has been split up into separate files - one for each study date when nests were observed. The sampling date is included in the file name but not in the data itself. 

Our goal is to read in all 50 files from the **penguins** folder into one data frame, and include the date from each file name in the table. 

===

Load the `fs` package, which contains functions to work with files, filepaths, and directories. Most functions are named based on [their unix equivalent](https://fs.r-lib.org/articles/function-comparisons.html), with the corresponding prefix `file_`, `path_`, or `dir_`. 

Use `dir_ls` to create a vector of filepaths. 



~~~r
library(fs)
penguin_files <- dir_ls('data/penguins')
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


If we were interested in only a subset of files in that directory, we could filter them by supplying a pattern to the argument `glob` or `regexp`, such as "only files with the word `penguin` in the name ending in `.csv`. 

```
dir_ls('data/penguins', glob = "*penguins*.csv")
```

===

`fs` path objects are character vectors but a little smarter. Check out some specialized functions can extract or retrieve parts of path.  

any other arguments?



~~~r
> penguin_files[1] %>% path_dir()
~~~
{:title="Console" .input}


~~~
[1] "data/penguins"
~~~
{:.output}


~~~r
> penguin_files[1] %>% path_ext_remove()
~~~
{:title="Console" .input}


~~~
data/penguins/penguins_nesting-December-1-2009
~~~
{:.output}


~~~r
> penguin_files[1] %>% path_ext()
~~~
{:title="Console" .input}


~~~
[1] "csv"
~~~
{:.output}




===

We'll use the `read_csv` function in the `readr` package. 


===

Use the `col_types` argument in `read_csv` to ensure consistency across files. One way to specify col types is a character vector using these codes:

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
pg_df <- map_df(penguin_files, ~read_csv(.x, col_types = "cdcccccddddcddccc"))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}



===

Or use `spec_csv` to generate a column specification from the first file that can be passed to the col_types argument. 



~~~r
my_col_types <- spec_csv(penguin_files[1])
pg_df <- map_df(penguin_files, ~read_csv(.x, col_types = my_col_types))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

## Map functions

The approach to iteration in the tidyverse is by using `map` functions in the `purrr` package. 

Compared to the apply family of functions, map functions offer 

* predictable structure of return objects, and
* consistent syntax for piped workflows.

The arguments to map are: 

* `.x` - the object to iterate over
* `.f` - the thing to do for each item in `.x`

===

Read all `penguin_files` into a list using:

```
map(.x = penguin_files, .f = read_csv)
```

Or use `~` to specify the function and arguments:

```
 map(.x = penguin_files, ~read_csv(.x))
```

===

Whereas `map` always returns a list, there are `map_*` functions for returning specific types of vectors (e.g. `map_chr` or `map_int`). Use `map_df` for returning *one* dataframe:



~~~r
pg_df <- map_df(penguin_files, ~read_csv(.x))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}



===

Another handy argument for `map_df` is `.id` for putting the names of each item of `.x` into a column. 



~~~r
pg_df <- map_df(penguin_files, ~read_csv(.x), .id = "filename")
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
  map_df(~read_csv(.x), .id = "filename")
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

