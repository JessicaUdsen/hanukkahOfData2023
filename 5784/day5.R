library(tidyverse)
#See problem statement here: https://hanukkah.bluebird.sh/5784/5/

statenIslandCustomers <- readRDS('customers.RDS') %>%
  filter(str_detect(citystatezip, 'Staten Island')) %>%
  select(customerid, name, citystatezip, phone)

catProducts <- readRDS('products.RDS') %>%
  filter(type == 'PET') %>%
  mutate(desc = tolower(desc)) %>%
  filter(str_detect(desc, 'cat'))

catOrdersItems <- readRDS('ordersItems.RDS') %>%
  filter(sku %in% catProducts$sku) %>%
  select(orderid, sku)

catOrders <- readRDS('orders.RDS') %>%
  select(orderid, customerid) %>%
  inner_join(catOrdersItems, by = 'orderid') %>%
  inner_join(statenIslandCustomers, by = 'customerid')

catLady <- catOrders %>%
  group_by(customerid) %>%
  summarize(totalCatOrders = n()) %>%
  arrange(desc(totalCatOrders)) %>%
  inner_join(statenIslandCustomers, by = 'customerid')

saveRDS(catLady$phone[2], 'catLadyPhoneDay5.RDS')
