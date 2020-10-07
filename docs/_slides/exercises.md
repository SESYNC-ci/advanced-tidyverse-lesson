---
editor_options: 
  chunk_output_type: console
---

## Exercises

===

### Exercise 1

Instead of returning an output of a specific type, the `walk` functions in purrr carry out a side effect (like displaying or saving a plot) without returning an object to your environment. Read about [map variants](https://purrr.tidyverse.org/reference/map2.html) that take multiple inputs, then use an appropriate function to save separate csv files for data about penguins from each of the studied islands using a list of data frames and a vector of filenames. 

Hint: Check out the base `split` or dplyr `group_split` function for creating a list of data frames. 

[View solution](#solution-1)
{:.notes}

===

### Exercise 2

Check out some specialized functions in [fs](){:.rlib} for extracting parts of [filepaths](https://fs.r-lib.org/articles/function-comparisons.html#path-functions.

Remove `"data/penguins/"` and  `".csv"` from the filename strings using only functions in fs.

[View solution](#solution-2)
{:.notes}

===

### Exercise 3

The following vector `dates` represents 3 periods of time. Convert it into a list of 3 separate date vectors each split into the start and end dates of each period. 



~~~r
> dates <- c("2007-12-03 to 2009-12-01", 
+            "2007 November 30 to 2009 October",
+            "1999 to 2010")
~~~
{:title="Console" .input}


Hint: check out the `truncation` argument in `ymd`. 

[View solution](#solution-3)
{:.notes}

### Exercise 4

Also use the different colors for each species within the plot geometry layer. 

Hint: You will need a `scale_` function

[View solution](#solution-4)
{:.notes}

===

### Exercise 5

Convert all character columns except for "comment" to factors using one mutate function. 

Hint: Check out the [across](https://dplyr.tidyverse.org/articles/programming.html) function

[View solution](#solution-5)
{:.notes}

===

### Exericse 6

Expand the `pars` data frame with a column of 10 model names for each of the unique combinations of island, sex, and species that appear in the data set. (should result in a 4 x 130 data frame)

[View solution](#solution-6)
{:.notes}

===

### Exercise 7

Use different images (such as from [phylopic.org](http://phylopic.org/)) to include in the labels representing each penguin species.

[View solution](#solution-7)
{:.notes}

## Solutions

===

### Solution 1



~~~r
> filenames <- glue::glue("{unique(pg_df$island)}.csv")
> pg_df %>% 
+   dplyr::group_split(island) %>% 
+   walk2(filenames, ~write_csv(.x, .y))
~~~
{:title="Console" .no-eval .input}


[Return](#exercise-1)
{:.notes}

### Solution 2



~~~r
> pg_df$filename %>% 
+   fs::path_ext_remove() %>%
+   fs::path_file()
~~~
{:title="Console" .no-eval .input}


[Return](#exercise-2)
{:.notes}

### Solution 3



~~~r
> dates %>% 
+   str_split("to", n = 2, ) %>% 
+   map(~str_trim(.x)) %>% 
+   map(~ymd(.x, truncated = 2))
~~~
{:title="Console" .no-eval .input}


[Return](#exercise-3)
{:.notes}

### Solution 4



~~~r
> pg_df %>%
+   mutate(species = glue("{common}<br><i style='color:{color}'>({latin})</i>")) %>%
+   ggplot(aes(x = species, y = delta_13_c_ooo)) +
+   geom_boxplot(aes(fill = color), alpha = 0.75) + 
+   scale_fill_identity() + # tricky! 
+   coord_flip() +
+   theme(axis.text.y = element_markdown())
~~~
{:title="Console" .no-eval .input}


[Return](#exercise-4)
{:.notes}


### Solution 5



~~~r
> pg_df %>% 
+   mutate(across(where(is.character) & !contains("comment"), as_factor))
~~~
{:title="Console" .no-eval .input}


[Return](#exercise-4)
{:.notes}

### Solution 6



~~~r
> library(magrittr)
> model_names <- glue("model_{letters[1:10]}")
> pars %<>% crossing(model_names)
~~~
{:title="Console" .no-eval .input}


[Return](#exercise-6)
{:.notes}

### Solution 7

You're on your own so far!

[Return](#exercise-7)
{:.notes}
