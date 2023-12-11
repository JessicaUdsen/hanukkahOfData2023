library(tidyverse)
#See problem statement here: https://hanukkah.bluebird.sh/5784/4/

customers <- readRDS('customers.RDS')
orders <- readRDS('orders.RDS')
order_items <- readRDS('ordersItems.RDS')
products <- readRDS('products.RDS') %>%
  filter(type == 'BKY')

bakerySKUs <- bakeryProducts$sku
  
bakeryOrderItems <- order_items %>%
  filter(sku %in% bakerySKUs) %>%
  select(orderid, sku)
bakeOrderIds <- bakeryOrderItems$orderid

bakeryOrders <- orders %>%
  select(orderid, customerid, ordered) %>%
  filter(orderid %in% bakeOrderIds) %>%
  mutate(date = date(ordered))

firstBakeOrders <- bakeryOrders %>% 
  group_by(date) %>%
  summarize(minTime = min(ordered)) 
firstBakeOrdersFinal <- bakeryOrders %>%
  filter(ordered %in% firstBakeOrders$minTime) %>%
  mutate(hour = hour(ordered)) %>%
  filter(hour == 4)

custCount <- firstBakeOrdersFinal %>%
  group_by(customerid) %>%
  summarize(numOrders = n()) %>%
  inner_join(customers, by = 'customerid')

maxOrders <- max(custCount$numOrders)
candidates <- custCount %>%
  filter(numOrders == maxOrders)

saveRDS(candidates$phone[1],'earlyBirdPhoneDay4.RDS')


