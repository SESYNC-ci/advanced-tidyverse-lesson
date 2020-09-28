---
---

## Tidy evaluation

Another core tenet of the tidyverse is *tidy evaluation* via data masking, which facilitates:

- using variable/column names without having to refer to data frame name
- identifying variables based on their position, name, or type

In base R there is similar functionality using `attach(pg_df)` or `data = pg_df` arguments in functions like `lm`. Tidyverse functions take those ideas and make them consistent and operational in a reliable manner beyond usage in interactive programming.
{:.notes}

===

We will rename the columns of our data frame to remove spaces and punctuation.



~~~r
> names(pg_df)
~~~
{:title="Console" .input}


~~~
 [1] "filename"            "studyName"           "Sample Number"      
 [4] "Region"              "Island"              "Stage"              
 [7] "Individual ID"       "Clutch Completion"   "Culmen Length (mm)" 
[10] "Culmen Depth (mm)"   "Flipper Length (mm)" "Body Mass (g)"      
[13] "Sex"                 "Delta 15 N (o/oo)"   "Delta 13 C (o/oo)"  
[16] "Comments"            "common"              "latin"              
~~~
{:.output}



===

We could rename each individually using `dplyr`'s `rename`, but `rename_with` is a handy shortcut if you want to do the same thing to every column name:

```
rename_with(.data = pg_df, .fn = ...)
```

We will use functions in the core tidyverse `stringr` package to manipulate the column name strings. 

===

## Pattern replacement 

Replaces spaces with underscore characters ("_") either with exact pattern or [regular expressions](https://stringr.tidyverse.org/articles/regular-expressions.html). Test out function on one column name:



~~~r
> str_replace_all("Body Mass (g)", pattern = " ", replacement = "_")
> str_replace_all("Body Mass (g)", pattern = "[:space:]", replacement = "_")
~~~
{:title="Console" .no-eval .input}


===

Similarly, can remove all punctuation using the regex pattern `[:punct:]`



~~~r
> str_replace_all("Delta 15 N (o/oo)", pattern = "[:punct:]", replacement = "")
~~~
{:title="Console" .no-eval .input}


Combine both transformations and add a new one (convert to lower case) in one fell swoop:



~~~r
pg_df <- pg_df %>%
  rename_with(~str_replace_all(.x, "[:punct:]", "")) %>%
  rename_with(~str_replace_all(.x, "[:space:]", "_")) %>%
  rename_with(~str_to_lower(.x))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


Check out the new column names:



~~~r
> names(pg_df)
~~~
{:title="Console" .input}


~~~
 [1] "filename"          "studyname"         "sample_number"    
 [4] "region"            "island"            "stage"            
 [7] "individual_id"     "clutch_completion" "culmen_length_mm" 
[10] "culmen_depth_mm"   "flipper_length_mm" "body_mass_g"      
[13] "sex"               "delta_15_n_ooo"    "delta_13_c_ooo"   
[16] "comments"          "common"            "latin"            
~~~
{:.output}


Much improved!!

===

## Format dates

Now let's work on putting the date information from the filenames into a properly formatted column of dates. Look at a sample of the data to evaluate: Is there a systematic way to extract the necessary information?



~~~r
> sample(pg_df$filename, 5)
~~~
{:title="Console" .input}


~~~
[1] "data/penguins/penguins_nesting-November-23-2009.csv"
[2] "data/penguins/penguins_nesting-November-15-2009.csv"
[3] "data/penguins/penguins_nesting-November-8-2008.csv" 
[4] "data/penguins/penguins_nesting-November-15-2009.csv"
[5] "data/penguins/penguins_nesting-November-28-2007.csv"
~~~
{:.output}


===

Every file name is the same besides the date, so we can remove those exact characters. Save to a vector. 



~~~r
egg_dates <- str_remove_all(string = pg_df$filename, 
    pattern =  "(data/penguins_nesting-)|(.csv)")
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

Can these be automatically converted to date format?



~~~r
> as.Date(egg_dates)
~~~
{:title="Console" .no-eval .input}



===

Lubridate can make some smart guesses about date formats with a little bit of help: the order **m**onth, **d**ay, **y*ear. 



~~~r
library(lubridate)
mdy(egg_dates)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
  [1] "2009-12-01" "2009-12-01" "2009-12-01" "2009-12-01" "2009-12-01"
  [6] "2009-12-01" "2009-12-01" "2009-12-01" "2007-12-03" "2007-12-03"
 [11] "2007-12-03" "2007-12-03" "2007-12-03" "2007-12-03" "2007-11-10"
 [16] "2007-11-10" "2007-11-10" "2007-11-10" "2008-11-10" "2008-11-10"
 [21] "2009-11-10" "2009-11-10" "2009-11-10" "2009-11-10" "2007-11-11"
 [26] "2007-11-11" "2008-11-11" "2008-11-11" "2008-11-11" "2008-11-11"
 [31] "2007-11-12" "2007-11-12" "2007-11-12" "2007-11-12" "2007-11-12"
 [36] "2007-11-12" "2007-11-12" "2007-11-12" "2009-11-12" "2009-11-12"
 [41] "2007-11-13" "2007-11-13" "2007-11-13" "2007-11-13" "2007-11-13"
 [46] "2007-11-13" "2008-11-13" "2008-11-13" "2008-11-13" "2008-11-13"
 [51] "2008-11-13" "2008-11-13" "2008-11-13" "2008-11-13" "2008-11-13"
 [56] "2008-11-13" "2008-11-13" "2008-11-13" "2009-11-13" "2009-11-13"
 [61] "2009-11-13" "2009-11-13" "2008-11-14" "2008-11-14" "2008-11-14"
 [66] "2008-11-14" "2008-11-14" "2008-11-14" "2008-11-14" "2008-11-14"
 [71] "2008-11-14" "2008-11-14" "2009-11-14" "2009-11-14" "2007-11-15"
 [76] "2007-11-15" "2007-11-15" "2007-11-15" "2008-11-15" "2008-11-15"
 [81] "2008-11-15" "2008-11-15" "2009-11-15" "2009-11-15" "2009-11-15"
 [86] "2009-11-15" "2009-11-15" "2009-11-15" "2009-11-15" "2009-11-15"
 [91] "2009-11-15" "2009-11-15" "2007-11-16" "2007-11-16" "2007-11-16"
 [96] "2007-11-16" "2007-11-16" "2007-11-16" "2007-11-16" "2007-11-16"
[101] "2007-11-16" "2007-11-16" "2007-11-16" "2007-11-16" "2007-11-16"
[106] "2007-11-16" "2007-11-16" "2007-11-16" "2009-11-16" "2009-11-16"
[111] "2009-11-16" "2009-11-16" "2009-11-16" "2009-11-16" "2009-11-16"
[116] "2009-11-16" "2009-11-16" "2009-11-16" "2008-11-17" "2008-11-17"
[121] "2008-11-17" "2008-11-17" "2009-11-17" "2009-11-17" "2009-11-17"
[126] "2009-11-17" "2009-11-17" "2009-11-17" "2009-11-17" "2009-11-17"
[131] "2009-11-17" "2009-11-17" "2007-11-18" "2007-11-18" "2009-11-18"
[136] "2009-11-18" "2009-11-18" "2009-11-18" "2009-11-18" "2009-11-18"
[141] "2009-11-18" "2009-11-18" "2009-11-18" "2009-11-18" "2009-11-18"
[146] "2009-11-18" "2009-11-18" "2009-11-18" "2007-11-19" "2007-11-19"
[151] "2007-11-19" "2007-11-19" "2009-11-19" "2009-11-19" "2008-11-02"
[156] "2008-11-02" "2008-11-02" "2008-11-02" "2008-11-02" "2008-11-02"
[161] "2009-11-20" "2009-11-20" "2009-11-20" "2009-11-20" "2009-11-20"
[166] "2009-11-20" "2007-11-21" "2007-11-21" "2007-11-21" "2007-11-21"
[171] "2009-11-21" "2009-11-21" "2009-11-21" "2009-11-21" "2009-11-21"
[176] "2009-11-21" "2009-11-21" "2009-11-21" "2009-11-21" "2009-11-21"
[181] "2009-11-21" "2009-11-21" "2007-11-22" "2007-11-22" "2009-11-22"
[186] "2009-11-22" "2009-11-22" "2009-11-22" "2009-11-22" "2009-11-22"
[191] "2009-11-22" "2009-11-22" "2009-11-22" "2009-11-22" "2009-11-23"
[196] "2009-11-23" "2009-11-23" "2009-11-23" "2009-11-23" "2009-11-23"
[201] "2008-11-24" "2008-11-24" "2008-11-24" "2008-11-24" "2008-11-24"
[206] "2008-11-24" "2008-11-24" "2008-11-24" "2008-11-25" "2008-11-25"
[211] "2008-11-25" "2008-11-25" "2009-11-25" "2009-11-25" "2009-11-25"
[216] "2009-11-25" "2009-11-25" "2009-11-25" "2007-11-26" "2007-11-26"
[221] "2007-11-26" "2007-11-26" "2007-11-27" "2007-11-27" "2007-11-27"
[226] "2007-11-27" "2007-11-27" "2007-11-27" "2007-11-27" "2007-11-27"
[231] "2007-11-27" "2007-11-27" "2007-11-27" "2007-11-27" "2007-11-27"
[236] "2007-11-27" "2007-11-27" "2007-11-27" "2007-11-27" "2007-11-27"
[241] "2009-11-27" "2009-11-27" "2009-11-27" "2009-11-27" "2009-11-27"
[246] "2009-11-27" "2009-11-27" "2009-11-27" "2009-11-27" "2009-11-27"
[251] "2007-11-28" "2007-11-28" "2007-11-28" "2007-11-28" "2007-11-28"
[256] "2007-11-28" "2007-11-28" "2007-11-28" "2007-11-29" "2007-11-29"
[261] "2007-11-29" "2007-11-29" "2007-11-29" "2007-11-29" "2007-11-29"
[266] "2007-11-29" "2007-11-29" "2007-11-29" "2008-11-03" "2008-11-03"
[271] "2008-11-03" "2008-11-03" "2008-11-03" "2008-11-03" "2008-11-03"
[276] "2008-11-03" "2007-11-30" "2007-11-30" "2007-11-30" "2007-11-30"
[281] "2008-11-04" "2008-11-04" "2008-11-04" "2008-11-04" "2008-11-04"
[286] "2008-11-04" "2008-11-04" "2008-11-04" "2008-11-04" "2008-11-04"
[291] "2008-11-04" "2008-11-04" "2008-11-05" "2008-11-05" "2008-11-06"
[296] "2008-11-06" "2008-11-06" "2008-11-06" "2008-11-06" "2008-11-06"
[301] "2008-11-06" "2008-11-06" "2008-11-06" "2008-11-06" "2008-11-06"
[306] "2008-11-06" "2008-11-07" "2008-11-07" "2008-11-08" "2008-11-08"
[311] "2008-11-08" "2008-11-08" "2008-11-08" "2008-11-08" "2008-11-08"
[316] "2008-11-08" "2007-11-09" "2007-11-09" "2007-11-09" "2007-11-09"
[321] "2007-11-09" "2007-11-09" "2007-11-09" "2007-11-09" "2008-11-09"
[326] "2008-11-09" "2008-11-09" "2008-11-09" "2008-11-09" "2008-11-09"
[331] "2008-11-09" "2008-11-09" "2008-11-09" "2008-11-09" "2008-11-09"
[336] "2008-11-09" "2008-11-09" "2008-11-09" "2008-11-09" "2008-11-09"
[341] "2009-11-09" "2009-11-09" "2009-11-09" "2009-11-09"
~~~
{:.output}


===

The POSIX date standard specifies codes for various components of dates and times, which can be used for the `format` argument in `as_date`



~~~r
> guess_formats("December-1-2009", orders = "mdy")
> as_date(egg_dates, format = "%B-%d-%Y")
~~~
{:title="Console" .input}


===

Combine the string manipulation and date conversion: 



~~~r
pg_df <- pg_df %>%
  mutate(egg_date = str_remove_all(filename,
          "(data/penguins_nesting-)|(.csv)")) %>%
  mutate(egg_date = mdy(egg_date))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}




