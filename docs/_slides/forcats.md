---
---

## Categorical data

R has a special data type for handling categorial data called factors. Because they had a reputation for causing trouble... 



~~~r
> default.stringsAsFactors()
~~~
{:title="Console" .input}


~~~
[1] FALSE
~~~
{:.output}


😲 this setting is new in R version 4 !!

Although `read_csv` had always defaulted strings to character data, there are situations where you may want to use factors, especially for modeling and plots -- essentially whenever you want character vectors to not be alphabetical. [forcats](){:.rlib} is intended to make this easier.

===

Species common names are in a character vector. 



~~~r
> class(pg_df$common)
~~~
{:title="Console" .input}


~~~
[1] "character"
~~~
{:.output}


Controlling the order in which the 3 species appear in a plot is done with factors. If the data are kept as characters, plots will be sorted alphabetically (i.e. the default ordering for factor levels in base R).



~~~r
> as.factor(pg_df$common) %>% levels()
~~~
{:title="Console" .input}


~~~
[1] "Adelie Penguin"    "Chinstrap penguin" "Gentoo penguin"   
~~~
{:.output}




~~~r
pg_df %>% 
  ggplot(aes(x = common)) +
  geom_bar()
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/forcats/unnamed-chunk-4-1.png" %})
{:.captioned}

===

`forcats::as_factor` uses instead the order in which the levels appear in your data:



~~~r
> as_factor(pg_df$common) %>% levels()
~~~
{:title="Console" .input}


~~~
[1] "Gentoo penguin"    "Chinstrap penguin" "Adelie Penguin"   
~~~
{:.output}


Convert `common` into a factor and remake the same bar plot. Notice the ordering of the bars compared to the previous graph. 



~~~r
pg_df <- pg_df %>% 
  mutate(common = as_factor(common))

pg_df %>% 
  ggplot(aes(x = common)) +
  geom_bar()
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/forcats/unnamed-chunk-6-1.png" %})
{:.captioned}


===

Use `fct_infreq` to order the levels by how frequently they appear in the dataset.



~~~r
pg_df %>% 
  mutate(common = fct_infreq(common)) %>%
  ggplot(aes(x = common)) +
  geom_bar()
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/forcats/unnamed-chunk-7-1.png" %})
{:.captioned}

===

Or more generally, `fct_reorder` to use a function(`.fun`) of a different variable (`.x`). Order **common** by each level's median `flipper_length_mm`:



~~~r
pg_df %>% 
  mutate(common = fct_reorder(common, 
    .x = flipper_length_mm, .fun = median, na.rm = TRUE)) %>%
  ggplot(aes(x = common, y = flipper_length_mm)) +
  geom_boxplot()
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/forcats/unnamed-chunk-8-1.png" %})
{:.captioned}

===

## All combinations of variables

To create a table with combinations of variables, use `expand` from the tidyr package. For example:



~~~r
> pg_df %>% expand(island, sex, common)
~~~
{:title="Console" .input}


~~~
# A tibble: 27 × 3
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
pars <- pg_df %>% expand(nesting(island, sex, common))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}



~~~r
> str(pars)
~~~
{:title="Console" .input}


~~~
tibble [13 × 3] (S3: tbl_df/tbl/data.frame)
 $ island: chr [1:13] "Biscoe" "Biscoe" "Biscoe" "Biscoe" ...
 $ sex   : chr [1:13] "FEMALE" "FEMALE" "MALE" "MALE" ...
 $ common: Factor w/ 3 levels "Gentoo penguin",..: 1 3 1 3 1 2 3 2 3 3 ...
~~~
{:.output}





