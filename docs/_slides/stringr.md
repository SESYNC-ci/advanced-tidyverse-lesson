---
editor_options: 
  chunk_output_type: console
---

## Manipulate strings and dates

Another core tenet of the tidyverse is [tidy evaluation](https://adv-r.hadley.nz/evaluation.html), which facilitates:

- using names of data variables as if they were variables in your environment (referred to as *data masking*)
- identifying variables based on their position, name, or type (referred to as *tidy selection*)

In base R there is similar functionality using `attach(pg_df)` or `data = pg_df` arguments in functions like `lm`. Tidyverse functions take those ideas and make them consistent and operational in a reliable manner beyond usage in interactive programming. 
{:.notes}

===

Given this focus on variable names, let's make it easier to use them without special syntax by renaming the columns of `pg_df` to remove spaces and punctuation. 



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

Within [dplyr](){:.rlib} functions like `rename` where the data frame is always the first argument, tidy eval means you don't need to re-specify the data frame name when you refer to a specific column. For example, rename the column "studyName" to "study_name"



~~~r
pg_df <- rename(pg_df, study_name = studyName)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

Instead of changing each colujn individually, `rename_with` is a handy shortcut to do the same modification to all (or a collection of) column names. The arguments are: 

* a data frame
* a function to apply to each column name 
* a selection of column to rename (by default all columns)

===

## Manipulating strings

Before changing the names, we will test out functions in [stringr](){:.rlib} for manipulating character strings. Common tasks often involve pattern matching, which can be accomplished by specifying either an exact match, or via  [regular expressions](https://stringr.tidyverse.org/articles/regular-expressions.html).

For example, replace all of the spaces in a character string using either:



~~~r
str_replace_all("Body Mass (g)", pattern = " ", replacement = "_")
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
[1] "Body_Mass_(g)"
~~~
{:.output}


~~~r
str_replace_all("Body Mass (g)", pattern = "[:space:]", replacement = "_")
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
[1] "Body_Mass_(g)"
~~~
{:.output}


===

The regex pattern `[:punct:]` is a concise way to match all punctuation symbols at once.



~~~r
str_replace_all("Delta 15 N (o/oo)", pattern = "[:punct:]", replacement = "")
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
[1] "Delta 15 N ooo"
~~~
{:.output}


Use these functions as arguments to a piped sequence of `rename_with` functions to combine both transformations and convert to lower case in one fell swoop:



~~~r
pg_df <- pg_df %>%
  rename_with(~str_replace_all(.x, "[:punct:]", "")) %>%
  rename_with(~str_replace_all(.x, "[:space:]", "_")) %>%
  rename_with(~str_to_lower(.x))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}





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


Much improved!! Note that a more robust method of creating [syntactic names](https://principles.tidyverse.org/names-attribute.html#syntactic-names) can be accomplished using the `.name_repair` argument in `tibble::tibble` or `readxl::read_excel`.

===

## Format dates

Now let's work on putting the date information from the filenames into a properly formatted column of dates. Look at a sample of the data to evaluate: Is there a systematic way to extract the necessary information?



~~~r
> sample(pg_df$filename, 5)
~~~
{:title="Console" .input}


~~~
[1] "data/penguins/penguins_nesting-November-25-2009.csv"
[2] "data/penguins/penguins_nesting-November-27-2009.csv"
[3] "data/penguins/penguins_nesting-November-3-2008.csv" 
[4] "data/penguins/penguins_nesting-November-14-2008.csv"
[5] "data/penguins/penguins_nesting-November-16-2007.csv"
~~~
{:.output}


===

We can use pattern matching to identify and remove "data/penguins/penguins_nesting-" or (`|`) ".csv" using `str_remove_all`. Save a new vector to use for testing out date conversions. 



~~~r
egg_dates <- str_remove_all(string = pg_df$filename, 
    pattern = "(data/penguins/penguins_nesting-)|(.csv)")
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

[lubridate](){:.rlib} facilitates working with date formats. Can `as_date` automatically interpret "December-1-2009" as a date?



~~~r
library(lubridate)
egg_dates[1] %>% as_date()
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .no-eval .text-document}



===

As with the base `as.Date` function, unless dates are already specified using the [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) YYYY-MM-DD representation, date conversion with `lubridate::as_date` requires a character string defining the date using codes from the POSIX standard:

| code    | meaning          |
|---------+------------------|
| `%b`    |  Abbreviated month name in current locale   |
| `%B`    |  Full month name in current locale          |
| `%d`    |  Day of month as decimal number (01-31)     |
| `%j`    |  Day of year as decimal number (001-366)    |
| `%y`    |  Year without century (00-99)               |
| `%Y`    |  Year with century                          |

Note that interpretation of many POSIX codes depend on settings of your operating system, such as month or weekday names in different languages, whether weeks start on Sunday or Monday, or the default century for `%y`. Read more about format specification in the **Details** section of the base `strptime` function. 



~~~r
> ?strptime
~~~
{:title="Console" .no-eval .input}


===

Supply the pattern of the date format as a character string using the appropriate pattern:



~~~r
egg_dates[1] %>% as_date(format = "%B-%d-%Y")
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
[1] "2009-12-01"
~~~
{:.output}


As long as the components of a date are in a consistent order, the `guess_formats` function can help determine the appropriate pattern, by supplying the order of **m**onth, **d**ay, and **y**ear. 



~~~r
egg_dates[1] %>% guess_formats(orders = "mdy")
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

Just by knowing the order that months, days, and years appear, we can actually circumvent all of those previous steps to find and convert the date information right from the full filename using the function `mdy`.



~~~r
> pg_df$filename[1] %>% mdy()
~~~
{:title="Console" .input}


~~~
[1] "2009-12-01"
~~~
{:.output}


Use `mdy` to create a new column with sampling dates and then drop the filename column, using functions that take advantage of tidy eval data masking.



~~~r
pg_df <- pg_df %>% mutate(date = mdy(filename)) %>% select(-filename)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}




