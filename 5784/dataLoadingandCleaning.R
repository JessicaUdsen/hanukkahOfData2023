library(tidyverse)

#At product type based on letters in SKU
products <- read_csv('./5784-speedrun/noahs-products.csv') %>%
  mutate(type = str_extract(sku, '[a-zA-Z]+'))
saveRDS(products, 'products.RDS')

customers <- read_csv('./5784-speedrun/noahs-customers.csv')
saveRDS(customers, 'customers.RDS')

#Orders data comes in two files that could be merged
orders <- read_csv('./5784-speedrun/noahs-orders.csv')
saveRDS(orders, 'orders.RDS')
ordersItems <- read_csv('./5784-speedrun/noahs-orders_items.csv')
saveRDS(ordersItems, 'ordersItems.RDS')
