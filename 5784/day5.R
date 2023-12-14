library(tidyverse)
#See problem statement here: https://hanukkah.bluebird.sh/5784-speedrun/5/

customers <- readRDS('customers.RDS')

catProducts <- readRDS('products.RDS') %>%
  filter(type == 'PET') %>%
  mutate(desc = tolower(desc)) %>%
  filter(str_detect(desc, 'cat food'))

catOrdersItems <- readRDS('ordersItems.RDS') %>%
  filter(sku %in% catProducts$sku) %>%
  group_by(orderid) %>%
  summarize(totalItems = sum(qty)) %>%
  filter(totalItems >= 10)

orders <- readRDS('orders.RDS')

catOrders <- inner_join(orders, catOrdersItems, by = 'orderid')
catLady <- customers %>%
  filter(customerid == catOrders$customerid[1])