# Worksheet for advanced tidyverse lesson

#### INTRODUCTION ######
# install tidyverse if needed
# install.packages("tidyverse")

# load the tidyverse meta-package
library(tidyverse)

#### READ IN DATA ######
# load fs package
library(fs)
# create a vector of filepaths
penguin_files <- dir_ls('data/penguins')

# Read all files into one data frame
pg_df <- map_df(penguin_files, ~read_csv(.x))

# Read all files into one data frame
# with specified file types
pg_df <- map_df(penguin_files, ~read_csv(.x, col_types = "cdcccccddddcddccc"))

# Create a column specification 
# from the first file
my_col_types <- spec_csv(penguin_files[1])
# use this specification to read in files
pg_df <- map_df(penguin_files, ~read_csv(.x, col_types = my_col_types))

# Read all files into one data frame
# and add column with filepaths
pg_df <- map_df(penguin_files, ~read_csv(.x), .id = "filename")

# Create filepaths vector and read in 
# using one piped operation
pg_df <- dir_ls('data/penguins/') %>%
  map_df(~read_csv(.x), .id = 'filename')

names(pg_df)

#### PATTERN REPLACEMENT ######

# test out replacements
str_replace_all("Body Mass (g)", pattern = " ", replacement = "_")
str_replace_all("Body Mass (g)", pattern = "[:space:]", replacement = "_")
str_replace_all("Delta 15 N (o/oo)", pattern = "[:punct:]", replacement = "")

# Replace all column names using functions
pg_df <- pg_df %>%
  rename_with(~str_replace_all(.x, "[:punct:]", "")) %>%
  rename_with(~str_replace_all(.x, "[:space:]", "_")) %>%
  rename_with(~str_to_lower(.x))

# Formatting dates
# remove all non-date related characters in filenames
egg_dates <- str_remove_all(string = pg_df$filename, 
        pattern =  "(data/penguins/penguins_nesting-)|(.csv)")

# load package for working with dates
library(lubridate)

mdy(egg_dates)
mdy(pg_df$filename)

# add a column with dates
pg_df <- pg_df %>%
  mutate(egg_date = mdy(filename))
         
# load package for putting strings together
library(glue)

# Combine common name and latin name
# into a new column species 
# with latin name in parentheses
pg_df <- pg_df %>% 
  mutate(species = glue("{common} ({latin})"))

# Boxplot of plot d13C by species
pg_df %>% 
  ggplot(aes(x = species, y = delta_13_c_ooo)) +
  geom_boxplot() +
  coord_flip()

# load ggtext library
library(ggtext)

# Create species column with markdown syntax
# for italics around latin name
pg_df %>% 
  mutate(species = glue("{common} (*{latin}*)")) %>%
  ggplot(aes(x = species, y = delta_13_c_ooo)) +
  geom_boxplot() + coord_flip() +
  theme(axis.text.y = element_markdown()) 

# add in a line break to the species label
pg_df %>% 
  mutate(species = glue("{common}<br>(*{latin}*)")) %>%
  ggplot(aes(x = species, y = delta_13_c_ooo)) +
  geom_boxplot() + coord_flip() +
  theme(axis.text.y = element_markdown()) 

# format the latin name with color
pg_df %>% 
  mutate(species = glue("{common}<br><i style='color:#009E73'>({latin})</i>")) %>%
  ggplot(aes(x = species, y = delta_13_c_ooo)) +
  geom_boxplot() + coord_flip() +
  theme(axis.text.y = element_markdown())

# load the package that...
library(scales)

# check out colors in the viridis palette
show_col(viridis_pal()(3))
# check out colors in the Dark2 qualitative palette
show_col((brewer_pal(type = "qual", palette = "Dark2"))(3))

# add a color column with ...
pg_df <- pg_df %>%
  mutate(color = case_when(common == "Gentoo penguin" ~ "#1B9E77",
                           common == "Chinstrap penguin" ~ "#D95F02",
                           common == "Adelie Penguin" ~ "#7570B3"))

# Use different colors for each species name
pg_df %>% 
  mutate(species = glue("{common}<br><i style='color:{color}'>({latin})</i>")) %>%
  ggplot(aes(x = species, y = delta_13_c_ooo)) +
  geom_boxplot() + coord_flip() +
  theme(axis.text.y = element_markdown())

#### Factor Manipulation ####

# convert common column to a factor
pg_df <- pg_df %>% 
     mutate(common = as_factor(common))

# plot number of observations by species
pg_df %>% 
  ggplot(aes(x = common)) +
  geom_bar()

pg_df %>% 
  mutate(common = fct_infreq(common)) %>%
  ggplot(aes(x = common)) +
  geom_bar()

pg_df %>% 
    mutate(common = fct_reorder(common, 
           flipper_length_mm, median, na.rm = TRUE)) %>%
     ggplot(aes(x = common, y = flipper_length_mm)) +
     geom_boxplot()

# tidyr expand
pars <- pg_df %>% expand(nesting(island, sex, common))

