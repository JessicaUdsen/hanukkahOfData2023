library(tidyverse)
#See problem statement here https://hanukkah.bluebird.sh/5784/3/

rabbitYears <- seq(from= 1903, to = 2023, by = 12)
customers <- readRDS('customers.RDS')

petersonPhone <- readRDS('contractorsPhoneDay2.RDS')
peterson <- customers %>%
  filter(phone == petersonPhone)

relevantCustomers <- customers %>%
  select(name, phone, birthdate, address, citystatezip) %>%
  filter(citystatezip == peterson$citystatezip) %>%
  mutate(birthyear = year(birthdate)) %>%
  filter(birthyear %in% rabbitYears) %>%
  mutate(gemini = sapply(birthdate, function(x){
    year(x) <- 2023
    if(x %within% interval(ymd('2023-06-21'), ymd('2023-07-22'))){
      return(1)
    }else{
      return(0)
    }
  })) %>%
  filter(gemini == 1)

saveRDS(relevantCustomers$phone, 'neighborPhoneDay3.RDS')


