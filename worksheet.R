# Worksheet for advanced tidyverse lesson
# install tidyverse if needed with:
# install.packages("tidyverse")
library(...)

# reading in data
library(...)

# create a vector of filepaths
penguin_files <- ...('data/penguins')

# read in first file
pg_df1 <- ...(penguin_files[1], ... = "cdcccccddddcddccc")

# create column specification
my_col_types <- ...(penguin_files[1])

# iterate read_csv function over all penguin_files
pg_list <- ...(... = penguin_files, ... =  ...)

# read into one data frame
pg_df <- ...(..., ...(.x, col_types = my_col_types))
# read into one data frame with filename column added
pg_df <- ...(penguin_files, ...)

# combine previous steps in pipe sequence
pg_df <- ...("data/penguins") ...
  ...(~read_csv(.x), .id = "filename")
  
  #### break for exercise 1 and 2 #####

# change one column name
pg_df <- ...(pg_df, study_name = ...)

# replace spaces
...("Body Mass (g)", pattern = ..., replacement = "_")
...("Body Mass (g)", pattern = ..., replacement = "_")

# replace special characters
...("Delta 15 N (o/oo)", pattern = ..., replacement = "")

# replace all column names
pg_df <- pg_df %>%
  ...(~str_replace_all(...)) %>%
  ...(~str_replace_all(...)) %>%
  ...(~...(.x))

# remove non-date characters
egg_dates <- str_remove_all(string = pg_df$filename, 
                            pattern = ...)

# load package for dates
library(...)

# test date conversion
egg_dates[1] %>% as_date()

# specify pattern of date
egg_dates[1] %>% as_date(... = ...)

# help with date conversion
egg_dates[1] %>% ...(orders = ...)

# convert date from entire filename string
pg_df$...[1] %>% ...()

# convert dates
pg_df <- pg_df %>% ...(date = ...(filename)) %>% select(-filename)

#### break for exercise 3 #####

# combine strings
library(...)
...("The biggest penguin measured ...max(pg_df$body_mass_g, na.rm = TRUE)... grams.")

# combine common and latin into new column
pg_df <- pg_df %>% 
  mutate(species = ...)

# make boxplot
pg_df %>% 
  ...(aes(x = species, y = delta_13_c_ooo)) +
  ...() +
  ...()

# italicize species
pg_df %>% 
  ggplot(aes(x = species, y = delta_13_c_ooo)) +
  geom_boxplot() +
  coord_flip() +
  theme(axis.text.y = element_text(...))

# devtools::install_github("wilkelab/ggtext")
library(...)

# add markdown formatting
pg_df %>% 
  mutate(species = glue("{common} (...{latin}...)")) %>%
  ggplot(aes(x = species, y = delta_13_c_ooo)) +
  geom_boxplot() +
  coord_flip()

# interpret as markdown
pg_df %>% 
  mutate(species = glue("{common} (*{latin}*)")) %>%
  ggplot(aes(x = species, y = delta_13_c_ooo)) +
  geom_boxplot() + coord_flip() +
  theme(...) 

# add linebreak
pg_df %>% 
  mutate(species = glue("{common}...(*{latin}*)")) %>%
  ggplot(aes(x = species, y = delta_13_c_ooo)) +
  geom_boxplot() + coord_flip() +
  theme(axis.text.y = element_markdown()) 

# add color
pg_df %>% 
  mutate(species = glue("<span ...='...:#009E73'>{common}</span><br>(*{latin}*)")) %>%
  ggplot(aes(x = species, y = delta_13_c_ooo)) +
  geom_boxplot() + coord_flip() +
  theme(axis.text.y = element_markdown())

# add more colors
library(...)

# make a new column of color
pg_df <- pg_df %>%
  mutate(color = ...(... "Gentoo penguin" ... "#1B9E77",
                     ... "Chinstrap penguin" ... "#D95F02",
                     ... "Adelie Penguin" ... "#7570B3"))
# use color in label
pg_df %>% 
  mutate(species = glue("{common}<br><i style='color:...'>({latin})</i>")) %>%
  ggplot(aes(x = species, y = delta_13_c_ooo)) +
  geom_boxplot() + coord_flip() +
  theme(axis.text.y = element_markdown())

# barplots
pg_df %>% 
  ggplot(aes(x = common)) +
  ...()

# convert common to factor
pg_df <- pg_df %>% 
  mutate(common = ...(common))

# replot
pg_df %>% 
  ggplot(aes(x = common)) +
  geom_bar()

# order factor by frequency
pg_df %>% 
  mutate(common = ...(common)) %>%
  ggplot(aes(x = common)) +
  geom_bar()

# order factor by median flipper length
pg_df %>% 
  mutate(common = ...(common, 
                  ... = flipper_length_mm, ... = median, na.rm = TRUE)) %>%
  ggplot(aes(x = common, y = flipper_length_mm)) +
  geom_boxplot()

# combinations of variables

pars <- pg_df %>% ...(...(island, sex, common))

