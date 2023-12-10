library(tidyverse)

#At product type based on letters in SKU
products <- read_csv('noahs-products.csv') %>%
  mutate(type = str_extract(sku, '[a-zA-Z]+'))
saveRDS(products, 'products.RDS')

customers <- read_csv('noahs-customers.csv')
saveRDS(customers, 'customers.RDS')

#Orders data comes in two files that could be merged
orders <- read_csv('noahs-orders.csv')
saveRDS(orders, 'orders.RDS')
ordersItems <- read_csv('noahs-orders_items.csv')
saveRDS(ordersItems, 'ordersItems.RDS')
