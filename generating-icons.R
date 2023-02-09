library(magick)
library(tidyverse)

rdm <- readLines("README.md")

urls <- str_subset(rdm, "simpleicons") %>%
  str_remove_all('<img src=\"') %>%
  str_remove_all('" alt=.*')


for (i in urls){
  name <- i %>%
    str_remove('https://simpleicons.org/icons/') %>%
     str_remove('.svg')

  # dark mode
  rsvg::rsvg(i,
             width = 45, height = 45) %>%
    image_read() %>%
    # image_negate() %>%
    image_write(path = paste0("icons/", name, "-light-mode.png"), format = "png")

  # light mode
  rsvg::rsvg(i,
             width = 45, height = 45) %>%
    image_read() %>%
    image_negate() %>%
    image_write(path = paste0("icons/", name, "-dark-mode.png"), format = "png")
}

lines <- c()
for (i in urls){
  name <- i %>%
    str_remove('https://simpleicons.org/icons/') %>%
    str_remove('.svg')

  lines <- c(lines, paste0('![',
         name, '](https://github.com/vktrsmnv/vktrsmnv/raw/main/icons/',
         name, '-light-mode.png#gh-light-mode-only)'),
    paste0('![',
           name, '](https://github.com/vktrsmnv/vktrsmnv/raw/main/icons/',
           name, '-dark-mode.png#gh-dark-mode-only)'))

}

c(rdm[1:30], lines, rdm[31:length(rdm)]) %>% writeLines(con = "README.md")
