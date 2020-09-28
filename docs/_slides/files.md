---
---

## Sample Data

We'll be using the data from the `palmerpenguins` package. 

Put image and credits in here. 

Some brief info. 

The data in the package is organized into 2 data frames but for teaching purposes it is modified. 

===

There are separate CSV files for each sampling date with the same format and file naming convention. Our goal is to have the data from all 50 files into the same data frame, and add the date metadata from the filename into the table (which it is not currently).



~~~r
> list.files('data/penguins')
~~~
{:title="Console" .input}


~~~
 [1] "penguins_nesting-December-1-2009.csv" 
 [2] "penguins_nesting-December-3-2007.csv" 
 [3] "penguins_nesting-November-10-2007.csv"
 [4] "penguins_nesting-November-10-2008.csv"
 [5] "penguins_nesting-November-10-2009.csv"
 [6] "penguins_nesting-November-11-2007.csv"
 [7] "penguins_nesting-November-11-2008.csv"
 [8] "penguins_nesting-November-12-2007.csv"
 [9] "penguins_nesting-November-12-2009.csv"
[10] "penguins_nesting-November-13-2007.csv"
[11] "penguins_nesting-November-13-2008.csv"
[12] "penguins_nesting-November-13-2009.csv"
[13] "penguins_nesting-November-14-2008.csv"
[14] "penguins_nesting-November-14-2009.csv"
[15] "penguins_nesting-November-15-2007.csv"
[16] "penguins_nesting-November-15-2008.csv"
[17] "penguins_nesting-November-15-2009.csv"
[18] "penguins_nesting-November-16-2007.csv"
[19] "penguins_nesting-November-16-2009.csv"
[20] "penguins_nesting-November-17-2008.csv"
[21] "penguins_nesting-November-17-2009.csv"
[22] "penguins_nesting-November-18-2007.csv"
[23] "penguins_nesting-November-18-2009.csv"
[24] "penguins_nesting-November-19-2007.csv"
[25] "penguins_nesting-November-19-2009.csv"
[26] "penguins_nesting-November-20-2009.csv"
[27] "penguins_nesting-November-21-2007.csv"
[28] "penguins_nesting-November-21-2009.csv"
[29] "penguins_nesting-November-2-2008.csv" 
[30] "penguins_nesting-November-22-2007.csv"
[31] "penguins_nesting-November-22-2009.csv"
[32] "penguins_nesting-November-23-2009.csv"
[33] "penguins_nesting-November-24-2008.csv"
[34] "penguins_nesting-November-25-2008.csv"
[35] "penguins_nesting-November-25-2009.csv"
[36] "penguins_nesting-November-26-2007.csv"
[37] "penguins_nesting-November-27-2007.csv"
[38] "penguins_nesting-November-27-2009.csv"
[39] "penguins_nesting-November-28-2007.csv"
[40] "penguins_nesting-November-29-2007.csv"
[41] "penguins_nesting-November-30-2007.csv"
[42] "penguins_nesting-November-3-2008.csv" 
[43] "penguins_nesting-November-4-2008.csv" 
[44] "penguins_nesting-November-5-2008.csv" 
[45] "penguins_nesting-November-6-2008.csv" 
[46] "penguins_nesting-November-7-2008.csv" 
[47] "penguins_nesting-November-8-2008.csv" 
[48] "penguins_nesting-November-9-2007.csv" 
[49] "penguins_nesting-November-9-2008.csv" 
[50] "penguins_nesting-November-9-2009.csv" 
~~~
{:.output}



===

Load the `fs` package (non-core tidyverse) to work with the file system. Create a vector of filepaths with `dir_ls()`



~~~r
library(fs)
penguin_files <- dir_ls('data/penguins')
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

`fs` path objects are character vectors but a little smarter. Check out some specialized functions can extract or retrieve parts of path.  



~~~r
> penguin_files[1] %>% path_dir()
~~~
{:title="Console" .input}


~~~
[1] "data"
~~~
{:.output}


~~~r
> penguin_files[1] %>% path_ext_remove()
~~~
{:title="Console" .input}


~~~
data/ACS
~~~
{:.output}


~~~r
> penguin_files[1] %>% path_ext()
~~~
{:title="Console" .input}


~~~
[1] ""
~~~
{:.output}


See [here](https://fs.r-lib.org/articles/function-comparisons.html) for comparisons of fs, base, UNIX

===

We want to read in each file using the `read_csv` function in the `readr` package. 

Readr is the tidyverse package for reading in rectangular data like CSV or TSV into tidy formats. There are other tidyverse packages specifically for reading in data from Excel files (`readxl`), Google Drive files (`googledrive` and `googlesheets4`), databases (`DBI`), SPSS/Stata/SAS data (`haven`), and various web data formats (`httr`, `xml2`, `jsonlite`).
{:.notes}

The syntax for reading in one file would be 



~~~r
> read_csv(penguin_files[1])
~~~
{:title="Console" .input}


~~~
Parsed with column specification:
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

The approach to iteration in the tidyverse is by using `map` functions in the `purrr` package. 

Compared to the apply family of functions, map functions offer 1) predictable structure of return objects, and 2) consistent syntax for piped workflows.

The arguments to map are: 

* `.x`: the object to iterate over
* `.f`: the function to apply to each item in `.x`

===

Read all `penguin_files` into a list of dataframes called `pg_list` using:



~~~r
> map(.x = penguin_files, .f = read_csv)
~~~
{:title="Console" .input}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
Parsed with column specification:
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
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


Or use `~` to specify the function and arguments:



~~~r
>  map(.x = penguin_files, ~read_csv(.x))
~~~
{:title="Console" .input}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
Parsed with column specification:
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
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


===

Whereas `map` always returns a list, there are `map_*` functions for returning specific types of vectors (e.g. `map_chr` or `map_int`). Use `map_df` for returning *one* dataframe:



~~~r
pg_df <- map_df(penguin_files, ~read_csv(.x))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

Use the `col_types` argument in `read_csv` to ensure consistency across files. One way to specify col types is a character vector using: c, i, n, d, l, f, D, T, t, ?, _, -



~~~r
pg_df <- map_df(penguin_files, ~read_csv(.x, col_types = "cdcccccddddcddccc"))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}



===

Or use `spec_csv` to generate a column specification that can be passed to the col_types argument.



~~~r
my_col_types <- spec_csv(penguin_files[1])
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
Parsed with column specification:
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


~~~r
pg_df <- map_df(penguin_files, ~read_csv(.x, col_types = my_col_types))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

Another handy argument for `map_df` is `.id` for putting the names of each item of `.x` into a column. 



~~~r
pg_df <- map_df(penguin_files, ~read_csv(.x), .id = "filename")
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
Parsed with column specification:
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
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


~~~
Parsed with column specification:
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
Parsed with column specification:
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
Parsed with column specification:
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
  Comments = col_logical(),
  common = col_character(),
  latin = col_character()
)
~~~
{:.output}


===

Remember the `%>%` ? 

![]({{ site.baseurl }}/images/pipe.jpg){: width="40%"}  
Some note about how readability is one of the core tenets of the tidyverse and this is accomplished with piped workflows. The functions are designed to work together based on the first argument and the type of output returned. 
{:.notes}

===

Combine previous steps together without creating intermediate objects:



~~~r
pg_df <- dir_ls("data/penguins") %>%
  map_df(~read_csv(.x), .id = "filename")
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

### Exercise 1

Use purrr's `walk2` function to save a separate csv file for penguins from each island using a list of data frames and a vector of filenames. 

Hint: Check out the base `split` or (experimental) dplyr `group_split` function for creating the list. 

[View solution](#solution-1)
{:.notes}
