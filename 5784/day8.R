library(tidyverse)
#See problem statement here: https://hanukkah.bluebird.sh/5784-speedrun/8/

customers <- readRDS('customers.RDS')
collectibles <- readRDS('products.RDS') %>%
  filter(type == 'COL')

ordersItems <- readRDS('ordersItems.RDS') %>%
  filter(sku %in% collectibles$sku)
orders <- readRDS('orders.RDS') %>%
  inner_join(ordersItems, by = 'orderid') %>%
  select(orderid, customerid, sku) %>%
  group_by(customerid) %>%
  summarize(n_distinct(sku)) %>%
  filter(`n_distinct(sku)` == length(unique(collectibles$sku))) %>%
  inner_join(customers, by = 'customerid')