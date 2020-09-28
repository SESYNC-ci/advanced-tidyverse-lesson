---
---

## Glue

Our data contain both the common and Latin names for the 3 penguin species. We will combine them into one column to use for labeling in a plot.



~~~r
> pg_df %>% select(common, latin) %>% distinct()
~~~
{:title="Console" .input}


~~~
# A tibble: 3 x 2
  common            latin                
  <chr>             <chr>                
1 Gentoo penguin    Pygoscelis papua     
2 Chinstrap penguin Pygoscelis antarctica
3 Adelie Penguin    Pygoscelis adeliae   
~~~
{:.output}



===

**glue** is the tidyverse package for pasting strings together. Expressions in `{ }` are evaluated as R code. 



~~~r
library(glue)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}





~~~r
> glue("{pg_df$common} ({pg_df$latin})")
~~~
{:title="Console" .input}


===

Make species a new column in the data frame using `mutate`



~~~r
pg_df <- pg_df %>% 
  mutate(species = glue("{common} ({latin})"))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

Make a sideways boxplot comparing δ^{13}C ‰ carbon isotope values by species. Rotate the graph to better display the labels




~~~r
pg_df %>% 
  ggplot(aes(x = species, y = delta_13_c_ooo)) +
  geom_boxplot() +
  coord_flip()
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/ggtext/unnamed-chunk-5-1.png" %})
{:.captioned}

===

We will now use markdown syntax within the plot labels to italicize *only* the Latin name part of the label. This functionality will soon be in `ggplot2` but for now install from ggtext



~~~r
# devtools::install_github("wilkelab/ggtext")
library(ggtext)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

Remember markdown syntax? 



~~~r
pg_df %>% 
  mutate(species = glue("{common} (*{latin}*)")) %>%
  ggplot(aes(x = species, y = delta_13_c_ooo)) +
  geom_boxplot() +
  coord_flip()
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/ggtext/unnamed-chunk-7-1.png" %})
{:.captioned}

===

Specify that this theme element should be interpreted as markdown. Recall that we flipped the X and Y axes! 



~~~r
pg_df %>% 
  mutate(species = glue("{common} (*{latin}*)")) %>%
  ggplot(aes(x = species, y = delta_13_c_ooo)) +
  geom_boxplot() + coord_flip() +
  theme(axis.text.y = element_markdown()) 
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/ggtext/unnamed-chunk-8-1.png" %})
{:.captioned}

===

Can also use some more html tags: line break, italics, bold, colors, fonts, super/subscript, images



~~~r
pg_df %>% 
  mutate(species = glue("{common}<br>(*{latin}*)")) %>%
  ggplot(aes(x = species, y = delta_13_c_ooo)) +
  geom_boxplot() + coord_flip() +
  theme(axis.text.y = element_markdown()) 
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/ggtext/unnamed-chunk-9-1.png" %})
{:.captioned}

===

Did you say color??



~~~r
pg_df %>% 
  mutate(species = glue("{common}<br><i style='color:#009E73'>({latin})</i>")) %>%
  ggplot(aes(x = species, y = delta_13_c_ooo)) +
  geom_boxplot() + coord_flip() +
  theme(axis.text.y = element_markdown())
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/ggtext/unnamed-chunk-10-1.png" %})
{:.captioned}

===

Explore color codes using the `scales` package, which underlies many other functions you may be using in ggplot figures already. 



~~~r
library(scales)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}



~~~r
> show_col(viridis_pal()(3))
~~~
{:title="Console" .input}
![ ]({% include asset.html path="images/ggtext/unnamed-chunk-12-1.png" %})
{:.captioned}


~~~r
> show_col((brewer_pal(type = "qual", palette = "Dark2"))(3))
~~~
{:title="Console" .input}
![ ]({% include asset.html path="images/ggtext/unnamed-chunk-13-1.png" %})
{:.captioned}

===

In order to use a different color for each penguin species, we will add a new column to the data frame with the color hex code for each using a series of conditional statements with `dplyr`'s `case_when` function. 

```
case_when(LHS ~ RHS, ...)
```

This will create a new vector of Right Hand Side values based on whether cases evaluate to TRUE with the Left Hand Side. Extra cases will either be NA, or add a TRUE ~ "default" as last else. 
{:.notes}

===

Add in the colors from the Dark2 palette



~~~r
pg_df <- pg_df %>%
  mutate(color = case_when(common == "Gentoo penguin" ~ "#1B9E77",
                           common == "Chinstrap penguin" ~ "#D95F02",
                           common == "Adelie Penguin" ~ "#7570B3"))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

Then use glue to include the value from the `color` column in the species label.



~~~r
pg_df %>% 
  mutate(species = glue("{common}<br><i style='color:{color}'>({latin})</i>")) %>%
  ggplot(aes(x = species, y = delta_13_c_ooo)) +
  geom_boxplot() + coord_flip() +
  theme(axis.text.y = element_markdown())
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/ggtext/unnamed-chunk-15-1.png" %})
{:.captioned}

### Exericse 3

Also use the different colors for each species within the plot geometry layer. 

Hint: You will need a `scale_` function

[View solution](#solution-3)
{:.notes}

### Exercise 4

*Bonus fun!* 

Use the proper notation for the isotope ratio in the X axis label. 

[View solution](#solution-4)
{:.notes}