---
---




~~~r
> default.stringsAsFactors()
~~~
{:title="Console" .input}


~~~
[1] FALSE
~~~
{:.output}


😲 this is new in R version 4 !!

we used read_csv so it was that way anyway, but there are situations where you may want to use factors, especially for MODELING and PLOTS. essentially when you want character vectors to not be alphabetical. The `forcats` package is intended to make this easier.

===

The column with the species common names is a character vector



~~~r
> str(pg_df$common)
~~~
{:title="Console" .input}


~~~
 chr [1:344] "Gentoo penguin" "Gentoo penguin" "Gentoo penguin" ...
~~~
{:.output}


Plots will be sorted alphabetically, like the default ordering for factor levels in base R.



~~~r
> as.factor(pg_df$common) %>% levels()
~~~
{:title="Console" .input}


~~~
[1] "Adelie Penguin"    "Chinstrap penguin" "Gentoo penguin"   
~~~
{:.output}




~~~r
> pg_df %>% 
+   ggplot(aes(x = common)) +
+   geom_bar()
~~~
{:title="Console" .input}
![ ]({% include asset.html path="images/forcats/unnamed-chunk-4-1.png" %})
{:.captioned}

===

Forcats `as_factor` uses the order in which the levels appear in your data



~~~r
> as_factor(pg_df$common) %>% levels()
~~~
{:title="Console" .input}


~~~
[1] "Gentoo penguin"    "Chinstrap penguin" "Adelie Penguin"   
~~~
{:.output}


Use this to make common into a factor. Does this change the barplot?



~~~r
> pg_df <- pg_df %>% 
+   mutate(common = as_factor(common))
> 
> pg_df %>% 
+   ggplot(aes(x = common)) +
+   geom_bar()
~~~
{:title="Console" .input}
![ ]({% include asset.html path="images/forcats/unnamed-chunk-6-1.png" %})
{:.captioned}

{:.fragment} Instead of alphabetical, the levels are now in the order they appeared in the dataset. 

===

Use `fct_infreq` to instead order the levels by how frequently they appear in the dataset.



~~~r
> pg_df %>% 
+   mutate(common = fct_infreq(common)) %>%
+   ggplot(aes(x = common)) +
+   geom_bar()
~~~
{:title="Console" .input}
![ ]({% include asset.html path="images/forcats/unnamed-chunk-7-1.png" %})
{:.captioned}

===

Or more generally, `fct_reorder` to use a different variable. In this case let's order **common** by each level's median `flipper_length_mm`.



~~~r
> pg_df %>% 
+   mutate(common = fct_reorder(common, 
+     flipper_length_mm, median, na.rm = TRUE)) %>%
+   ggplot(aes(x = common, y = flipper_length_mm)) +
+   geom_boxplot()
~~~
{:title="Console" .input}


~~~
Warning: Removed 2 rows containing non-finite values (stat_boxplot).
~~~
{:.output}
![ ]({% include asset.html path="images/forcats/unnamed-chunk-8-1.png" %})
{:.captioned}

===

To create a table with combinations of variables, use `expand` from the tidyr package. For example:



~~~r
> pg_df %>% expand(island, sex, common)
~~~
{:title="Console" .input}


~~~
# A tibble: 27 x 3
   island sex    common           
   <chr>  <chr>  <fct>            
 1 Biscoe FEMALE Gentoo penguin   
 2 Biscoe FEMALE Chinstrap penguin
 3 Biscoe FEMALE Adelie Penguin   
 4 Biscoe MALE   Gentoo penguin   
 5 Biscoe MALE   Chinstrap penguin
 6 Biscoe MALE   Adelie Penguin   
 7 Biscoe <NA>   Gentoo penguin   
 8 Biscoe <NA>   Chinstrap penguin
 9 Biscoe <NA>   Adelie Penguin   
10 Dream  FEMALE Gentoo penguin   
# … with 17 more rows
~~~
{:.output}


To only include the combinations of variables that do appear in your data, put the column names inside of the `nesting` helper function.



~~~r
> pars <- pg_df %>% expand(nesting(island, sex, common))
~~~
{:title="Console" .input}



## Exercise 5

Convert all character columns except for "comment" to factors using one mutate function. 

Hint: Check out the [across](https://dplyr.tidyverse.org/articles/programming.html) function

[View solution](#solution-5)
{:.notes}

## Exericse 6

Expand the `pars` data frame with a column of 10 model names for each of the unique combinations of island, sex, and species that appear in the data set. (should result in a 4 x 130 data frame)

[View solution](#solution-6)
{:.notes}


