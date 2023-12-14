library(tidyverse)
#Read problem statement: https://hanukkah.bluebird.sh/5784-speedrun/6/

orders <- readRDS('orders.RDS')
ordersItems <- readRDS('ordersItems.RDS')
customers <- readRDS('customers.RDS')
products <- readRDS('products.RDS')


orders <- orders %>%
  select(orderid, customerid, ordered)

products <- products %>%
  select(sku, wholesale_cost)

ordersItems <- inner_join(ordersItems, products, by = 'sku') %>%
  mutate(unitProfit = unit_price - wholesale_cost) %>%
  inner_join(orders, by = 'orderid')

customers <- customers %>%
  select(customerid, name, phone)

meanUnitProfits <- ordersItems %>%
  group_by(sku) %>%
  mutate(meanUnitProfit = mean(unitProfit)) %>%
  mutate(stDevProfit = sd(unitProfit)) %>%
  ungroup() %>%
  mutate(normProfit = (unitProfit-meanUnitProfit)/stDevProfit)

meanUnitProfits$normProfit[is.na(meanUnitProfits$normProfit)] <- 0

salesDaysTable <- meanUnitProfits %>%
  filter(normProfit < -2) 

#salesDaysTable gives us order data from days where the profit per item are more than 2 st devs
#lower than the average for the product, so these are steep sales days. Now count the number of 
#orders from customers on these days and see who comes out on top.

bargainHunters <- salesDaysTable %>%
  group_by(customerid) %>%
  summarize(numberOrders = n()) %>%
  arrange(desc(numberOrders)) %>%
  inner_join(customers, by = 'customerid') %>%
  head()

saveRDS(bargainHunters$phone[[1]], 'bargainHunterPhoneDay6.RDS')
