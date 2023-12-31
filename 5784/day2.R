library(tidyverse)
#Read problem statement here: https://hanukkah.bluebird.sh/5784-speedrun/2/

orders_items <- readRDS('ordersItems.RDS')
orders <- readRDS('orders.RDS')
customers <- readRDS('customers.RDS')
products <- readRDS('products.RDS')

customers <- customers %>%
  select(customerid, name, phone) %>%
  mutate(initials = sapply(strsplit(name, ' '), function(x) paste0(str_sub(x[1], 1, 1), str_sub(x[2], 1, 1)))) %>%
  filter(initials == 'DS')

orders <- orders %>%
  select(orderid, customerid, ordered) %>%
  mutate(ordered = year(ordered)) %>%
  filter(ordered == 2017)

custOrders <- customers %>%
  inner_join(orders, by = 'customerid') 

relProductIDs <- products %>%
  mutate(desc = tolower(desc)) %>%
  filter(str_detect(desc, pattern = 'coffee')|str_detect(desc, pattern = 'bagel')) %>%
  select(sku, desc)

relOrders <- relProductIDs %>%
  inner_join(orders_items, by = 'sku') %>%
  inner_join(custOrders, by = 'orderid') 

saveRDS(relOrders$phone[[1]], 'contractorsPhoneDay2.RDS')