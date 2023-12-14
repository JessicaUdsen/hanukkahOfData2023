library(tidyverse)
#Read problem statement here: https://hanukkah.bluebird.sh/5784-speedrun/7/

#Get customer info for bargain hunter again
bargainHunterPhone <- readRDS('bargainHunterPhoneDay6.RDS')
customers <- readRDS('customers.RDS')
bargainHunter <- customers %>%
  filter(phone == bargainHunterPhone)

#Let's filter the products- if they exchanged things that come in different colors, 
#I'm guessing it has to be either COL, TOY. or HOM 
products <- readRDS('products.RDS') %>%
  filter(type == 'HOM' | type == 'COL' | type == 'TOY')

orderItems <- readRDS('ordersItems.RDS')
orders <- readRDS('orders.RDS')
ordersBH <- orders %>%
  filter(customerid == bargainHunter$customerid[1]) %>%
  mutate(date = date(ordered)) %>%
  select(orderid, customerid, ordered, date)
orderItemsBH <- orderItems %>%
  inner_join(products, by = 'sku') %>%
  select(orderid, sku, desc) %>%
  inner_join(ordersBH, by = 'orderid')

#I can already see in orderItems that the items with colors associated with them have 
#parentheses 
orderItemsBH <- orderItemsBH %>%
  filter(str_detect(desc, "\\("))

basicDesc <- orderItemsBH$desc %>%
  str_split(' \\(') %>%
  sapply(function(desc) desc[1]) %>%
  unlist()

orderItemsBH <- orderItemsBH %>%
  mutate(basicDesc = basicDesc)

products <- products %>%
  filter(str_detect(desc, '\\('))

basicDescProducts <- products$desc %>%
  str_split(' \\(') %>%
  sapply(function(desc) desc[1]) %>%
  unlist()

productsWithBasic <- products %>%
  filter(str_detect(desc, '\\(')) %>%
  mutate(basicDesc = basicDescProducts)

possibleCandOrders <- orderItems %>%
  inner_join(productsWithBasic, by = 'sku') %>%
  filter(basicDesc %in% orderItemsBH$basicDesc) %>%
  inner_join(orders, by = 'orderid') %>%
  select(orderid, sku, desc, basicDesc, customerid, ordered) %>%
  mutate(date = date(ordered)) %>%
  filter(date %in% orderItemsBH$date) %>%
  filter(customerid != bargainHunter$customerid[1]) %>%
  rename(bf_orderid = orderid, bf_desc = desc, bf_basicDesc = basicDesc, bf_customerid = customerid, bf_ordered = ordered) %>%
  full_join(orderItemsBH, by = 'date') %>%
  filter(bf_basicDesc == basicDesc & bf_desc != desc) %>%
  mutate(diffTime = abs(difftime(bf_ordered, ordered))) %>%
  arrange(diffTime)

#After you get possibleCandOrders, confirm visually that the products purchased close together
#are the same, but in different colors
bf_customerid <- possibleCandOrders$bf_customerid[1]
bf <- customers %>%
  filter(customerid == bf_customerid)
saveRDS(bf$phone[1], 'cutiePhoneDay7.RDS')