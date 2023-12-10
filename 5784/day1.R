library(tidyverse)
#See the problem statement here: https://hanukkah.bluebird.sh/5784/1/
numberLetterKey <- list('a' = 2,
                        'b' = 2,
                        'c' = 2,
                        'd' = 3,
                        'e' = 3,
                        'f' = 3,
                        'g' = 4,
                        'h' = 4,
                        'i' = 4,
                        'j' = 5,
                        'k' = 5,
                        'l' = 5,
                        'm' = 6,
                        'n' = 6,
                        'o' = 6,
                        'p' = 7,
                        'q' = 7,
                        'r' = 7,
                        's' = 7,
                        't' = 8,
                        'u' = 8,
                        'v' = 8,
                        'w' = 9,
                        'x' = 9,
                        'y' = 9,
                        'z' = 9)
customers <- readRDS('customers.RDS')

letterToNum <- function(name){
  nameVect <- str_split_1(name, '')
  mapNums <- sapply(nameVect, function(x) numberLetterKey[x]) %>% unlist()
  mapNumsStr <- paste(mapNums, collapse='')
  return(mapNumsStr)
}

namePhoneData <- customers %>%
  select(name, phone) %>%
  mutate(phoneClean = str_remove_all(phone, pattern = '[^\\d]')) %>%
  mutate(lastName = sapply(strsplit(name, ' '), function(x) tolower(x[2]))) %>%
  mutate(lastNameNums = sapply(lastName, function(x) letterToNum(x))) %>%
  filter(lastNameNums %in% phoneClean) 

saveRDS(namePhoneData$phone, file = "detectivePhoneDay1.RDS") 

