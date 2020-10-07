---
---

## Combining strings

The next goal is to compare data about the 3 different penguin species using boxplots, using the format "Common name (*Latin name*)" in axis labels. The first task will be to make a new column that combines the common and Latin names from those respective columns:



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

[glue](){:.rlib} is the tidyverse equivalent of `paste`/`paste0` for putting data and strings together. Expressions in `{ }` are evaluated as R code, such as:



~~~r
library(glue)
glue("The biggest penguin measured {max(pg_df$body_mass_g, na.rm = TRUE)} grams.")
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
The biggest penguin measured 6300 grams.
~~~
{:.output}


===

Combine the common and (latin) names into a new column called species. 



~~~r
pg_df <- pg_df %>% 
  mutate(species = glue("{common} ({latin})"))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}



~~~r
> head(pg_df$species)
~~~
{:title="Console" .input}


~~~
Gentoo penguin (Pygoscelis papua)
Gentoo penguin (Pygoscelis papua)
Gentoo penguin (Pygoscelis papua)
Gentoo penguin (Pygoscelis papua)
Gentoo penguin (Pygoscelis papua)
Gentoo penguin (Pygoscelis papua)
~~~
{:.output}


===

Make a sideways boxplot comparing δ<sup>13</sup>C (‰) across species. Rotate the graph to better display the labels:



~~~r
pg_df %>% 
  ggplot(aes(x = species, y = delta_13_c_ooo)) +
  geom_boxplot() +
  coord_flip()
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/ggtext/unnamed-chunk-5-1.png" %})
{:.captioned}

Formatting the entire label is possible by modifying a theme element: 



~~~r
pg_df %>% 
  ggplot(aes(x = species, y = delta_13_c_ooo)) +
  geom_boxplot() +
  coord_flip() +
  theme(axis.text.y = element_text(face = "italic"))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/ggtext/unnamed-chunk-6-1.png" %})
{:.captioned}

However, until recently, italicizing *only* the Latin name was [much less straightforward](https://stackoverflow.com/a/39282593).

===

ggtext allows for using (limited) markdown syntax within the plot labels. This functionality will soon be in `ggplot2` but for now install and load ggtext.



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
![ ]({% include asset.html path="images/ggtext/unnamed-chunk-8-1.png" %})
{:.captioned}

===

In order to apply the formatting, specify that this theme element should be interpreted as markdown. Recall that the X and Y axes are flipped! 



~~~r
pg_df %>% 
  mutate(species = glue("{common} (*{latin}*)")) %>%
  ggplot(aes(x = species, y = delta_13_c_ooo)) +
  geom_boxplot() + coord_flip() +
  theme(axis.text.y = element_markdown()) 
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/ggtext/unnamed-chunk-9-1.png" %})
{:.captioned}

===

The other html/markdown styles that can be interpreted are: line break, italics, bold, colors, fonts, super/subscript, and images.



~~~r
pg_df %>% 
  mutate(species = glue("{common}<br>(*{latin}*)")) %>%
  ggplot(aes(x = species, y = delta_13_c_ooo)) +
  geom_boxplot() + coord_flip() +
  theme(axis.text.y = element_markdown()) 
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/ggtext/unnamed-chunk-10-1.png" %})
{:.captioned}

===

Because there is no markdown syntax for font color, html syntax is required to change font color:



~~~r
pg_df %>% 
  mutate(species = glue("<span style='color:#009E73'>{common}</span><br>(*{latin}*)")) %>%
  ggplot(aes(x = species, y = delta_13_c_ooo)) +
  geom_boxplot() + coord_flip() +
  theme(axis.text.y = element_markdown())
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/ggtext/unnamed-chunk-11-1.png" %})
{:.captioned}

===

Explore color codes using the [scales](){:.rlib} package, which underlies many other functions you may be using in ggplot figures already. 



~~~r
library(scales)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}



~~~r
> show_col(viridis_pal()(3))
~~~
{:title="Console" .input}
![ ]({% include asset.html path="images/ggtext/unnamed-chunk-13-1.png" %})
{:.captioned}


~~~r
> show_col((brewer_pal(type = "qual", palette = "Dark2"))(3))
~~~
{:title="Console" .input}
![ ]({% include asset.html path="images/ggtext/unnamed-chunk-14-1.png" %})
{:.captioned}

===

In order to use a different color for each penguin species, we will add a new column to the data frame with the color hex code for each using a series of conditional statements with `dplyr`'s `case_when` function. 



~~~r
> case_when(LHS ~ RHS, ...)
~~~
{:title="Console" .no-eval .input}


This will create a new vector of Right Hand Side (RHS) values based on whether cases evaluate to TRUE with the Left Hand Side (LHS). It can be handy for the purpose of labeling different classes of a continuous variable such as:



~~~r
> case_when(
+   x < 10 ~ "small",
+   x >= 10 & x < 20 ~ "medium",
+   x >= 20 ~ "large")
~~~
{:title="Console" .no-eval .input}



===

Add in the colors we identified from the Dark2 palette in a new column called color, using conditional statements to filter rows for each penguin species. Use color hex codes as the replacement value.



~~~r
pg_df <- pg_df %>%
  mutate(color = case_when(common == "Gentoo penguin" ~ "#1B9E77",
                           common == "Chinstrap penguin" ~ "#D95F02",
                           common == "Adelie Penguin" ~ "#7570B3"))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


The arguments to `case_when` are evaluated in order, so it is advised to list them from most specific to most general. If there were rows with other or NA values for the common name, we could designate what goes in the color column for those rows by adding a last conditional such as `TRUE ~ "#000000"`.  
{:.notes}

===

Then use glue to include the species-specific color value in the axis label.



~~~r
pg_df %>% 
  mutate(species = glue("{common}<br><i style='color:{color}'>({latin})</i>")) %>%
  ggplot(aes(x = species, y = delta_13_c_ooo)) +
  geom_boxplot() + coord_flip() +
  theme(axis.text.y = element_markdown())
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/ggtext/unnamed-chunk-18-1.png" %})
{:.captioned}


