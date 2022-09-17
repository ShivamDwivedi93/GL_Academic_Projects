-- Query 1

-- Write a query to Display the product details (product_class_code, product_id, product_desc, product_price,) as per the following criteria and sort them in descending order of category: 
-- a. If the category is 2050, increase the price by 2000 
-- b. If the category is 2051, increase the price by 500 
-- c. If the category is 2052, increase the price by 600. 
-- Hint: Use case statement. no permanent change in table required. (60 ROWS) [NOTE: PRODUCT TABLE]

SELECT PRODUCT_CLASS_CODE,
PRODUCT_DESC,
PRODUCT_PRICE,
PRODUCT_ID,
CASE PRODUCT_CLASS_CODE
WHEN 2050 THEN PRODUCT_PRICE+2000  
WHEN 2051 THEN PRODUCT_PRICE+500 
WHEN 2052 THEN PRODUCT_PRICE+600 
ELSE PRODUCT_PRICE
END AS 'Updated_Rates'FROM PRODUCT
ORDER BY PRODUCT_CLASS_CODE DESC;

-- Query 2

-- Write a query to display (product_class_desc, product_id, product_desc, product_quantity_avail ) and Show inventory status of products as below as per their available quantity: 
-- a. For Electronics and Computer categories, if available quantity is <= 10, show 'Low stock', 11 <= qty <= 30, show 'In stock', >= 31, show 'Enough stock' 
-- b. For Stationery and Clothes categories, if qty <= 20, show 'Low stock', 21 <= qty <= 80, show 'In stock', >= 81, show 'Enough stock' 
-- c. Rest of the categories, if qty <= 15 – 'Low Stock', 16 <= qty <= 50 – 'In Stock', >= 51 – 'Enough stock' For all categories, if available quantity is 0, show 'Out of stock'. 
-- Hint: Use case statement. (60 ROWS) [NOTE: TABLES TO BE USED – product, product_class]

SELECT PC.PRODUCT_CLASS_DESC,
P.PRODUCT_DESC,
P.PRODUCT_QUANTITY_AVAIL,
P.PRODUCT_ID,
CASE
WHEN PC.PRODUCT_CLASS_CODE IN (2050,2053) THEN 
CASE
WHEN P.PRODUCT_QUANTITY_AVAIL =0 THEN 'Out of stock'
WHEN P.PRODUCT_QUANTITY_AVAIL <=10 THEN 'Low stock'
WHEN (P.PRODUCT_QUANTITY_AVAIL >=11 AND P.PRODUCT_QUANTITY_AVAIL <=30) THEN 'In stock'
WHEN (PRODUCT_QUANTITY_AVAIL >=31) THEN 'Enough stock'
END
WHEN PC.PRODUCT_CLASS_CODE IN (2052,2056) THEN 
CASE
WHEN P.PRODUCT_QUANTITY_AVAIL =0 THEN 'Out of stock'
WHEN P.PRODUCT_QUANTITY_AVAIL <=20 THEN 'Low stock'
WHEN (P.PRODUCT_QUANTITY_AVAIL >=21 AND P.PRODUCT_QUANTITY_AVAIL <=80) THEN 'In stock'
WHEN (PRODUCT_QUANTITY_AVAIL >=81) THEN 'Enough stock'
END
WHEN PC.PRODUCT_CLASS_CODE IN (3001,3002,2051,2054,2055,2057,2058,2059,2060, 3000) THEN 
CASE
WHEN P.PRODUCT_QUANTITY_AVAIL =0 THEN 'Out of stock'
WHEN P.PRODUCT_QUANTITY_AVAIL <=15 THEN 'Low stock'
WHEN (P.PRODUCT_QUANTITY_AVAIL >=16 AND P.PRODUCT_QUANTITY_AVAIL <=50) THEN 'In stock'
WHEN (PRODUCT_QUANTITY_AVAIL >=51) THEN 'Enough stock'
END
END AS 'Product_Status'
FROM PRODUCT P 
INNER JOIN PRODUCT_CLASS PC ON P.PRODUCT_CLASS_CODE = PC.PRODUCT_CLASS_CODE
ORDER BY P.PRODUCT_CLASS_CODE, P.PRODUCT_QUANTITY_AVAIL DESC; 

-- Query 3

-- Write a query to show the number of cities in all countries other than USA & MALAYSIA,
-- with more than 1 city, 
-- in the descending order of CITIES. (2 rows) [NOTE: ADDRESS TABLE]

SELECT Country, COUNT(CITY) City__Count FROM ADDRESS
WHERE COUNTRY NOT IN ('USA', 'MALAYSIA')  GROUP BY COUNTRY
HAVING COUNT(CITY)>1 ORDER BY 'DESC';

-- Query 4

-- Write a query to display the customer_id,customer full name ,city,pincode,and order details (order id, product class desc, product desc, subtotal(product_quantity * product_price)) 
-- for orders shipped to cities whose pin codes do not have any 0s in them. 
-- Sort the output on customer name and subtotal. (52 ROWS) 
-- [NOTE: TABLE TO BE USED - online_customer, address, order_header, order_items, product, product_class]

SELECT OC.CUSTOMER_ID,
CONCAT(CUSTOMER_FNAME,' ',CUSTOMER_LNAME),
A.CITY AS 'City', A.PINCODE,
PC.PRODUCT_CLASS_DESC,
OH.ORDER_ID,
OI.PRODUCT_QUANTITY,
P.PRODUCT_DESC, 
P.PRODUCT_PRICE,
(P.PRODUCT_PRICE * OI.PRODUCT_QUANTITY) as total__price
FROM
ONLINE_CUSTOMER OC
INNER JOIN ADDRESS A ON OC.ADDRESS_ID = A.ADDRESS_ID
INNER JOIN ORDER_HEADER OH ON OH.CUSTOMER_ID = OC.CUSTOMER_ID
INNER JOIN ORDER_ITEMS OI ON OI.ORDER_ID = OH.ORDER_ID
INNER JOIN PRODUCT P ON P.PRODUCT_ID = OI.PRODUCT_ID
INNER JOIN PRODUCT_CLASS PC ON PC.PRODUCT_CLASS_CODE = P.PRODUCT_CLASS_CODE
WHERE OH.ORDER_STATUS = 'Shipped' AND A.PINCODE NOT LIKE '%0%'
ORDER BY OC.CUSTOMER_FNAME, total__price;


-- Query 5

-- Write a Query to display product id,product description,totalquantity(sum(product quantity) 
-- for a given item whose product id is 201 and which item has been bought along with it maximum no. of times. 
-- Display only one record which has the maximum value for total quantity in this scenario. 
-- (USE SUB-QUERY)(1 ROW)[NOTE : ORDER_ITEMS TABLE,PRODUCT TABLE]

SELECT OI.PRODUCT_ID as product__id,
P.PRODUCT_DESC as product__description,
SUM(OI.PRODUCT_QUANTITY) as order__quantity
FROM ORDER_ITEMS OI
INNER JOIN PRODUCT P on P.PRODUCT_ID = OI.PRODUCT_ID
WHERE OI.ORDER_ID IN (SELECT DISTINCT ORDER_ID FROM ORDER_ITEMS A WHERE PRODUCT_ID = 201)
AND OI.PRODUCT_ID <> 201
GROUP BY OI.PRODUCT_ID
ORDER BY order__quantity DESC
LIMIT 1;


-- Query 6

-- Write a query to display the customer_id,customer name, email and order details (order id, product desc,product qty, subtotal(product_quantity * product_price)) 
-- for all customers even if they have not ordered any item.(225 ROWS) 
-- [NOTE: TABLE TO BE USED - online_customer, order_header, order_items, product]

SELECT
OC.CUSTOMER_ID as customer__id,
CONCAT(CUSTOMER_FNAME,' ',CUSTOMER_LNAME) as customer_full_name, 
OC.CUSTOMER_EMAIL as customer_email_id,
O.ORDER_ID as order__id,
P.PRODUCT_DESC as product__description,
OI.PRODUCT_QUANTITY as order__quantity,
P.PRODUCT_PRICE as rate__per__product,
(P.PRODUCT_PRICE * OI.PRODUCT_QUANTITY) as total__price
FROM 
ONLINE_CUSTOMER OC
LEFT JOIN ORDER_HEADER O ON OC.CUSTOMER_ID = O.CUSTOMER_ID
LEFT JOIN ORDER_ITEMS OI ON O.ORDER_ID = OI.ORDER_ID
LEFT JOIN PRODUCT P ON OI.PRODUCT_ID = P.PRODUCT_ID
ORDER BY Customer__ID, order__quantity DESC;

-- Query 7

-- Write a query to display carton id, (len*width*height) as carton_vol and
-- identify the optimum carton (carton with the least volume whose volume is greater than the total volume of all items (len * width * height * product_quantity)) 
-- for a given order whose order id is 10006, 
-- Assume all items of an order are packed into one single carton (box). 
-- (1 ROW) [NOTE: CARTON TABLE]

SELECT C.CARTON_ID as carton__id,
(C.LEN*C.WIDTH*C.HEIGHT) as carton__volume
FROM ORDERS.CARTON C
WHERE (C.LEN*C.WIDTH*C.HEIGHT) >= (SELECT SUM(P.LEN*P.WIDTH*P.HEIGHT*OI.PRODUCT_QUANTITY) as vol
FROM
ORDERS.ORDER_ITEMS OI
INNER JOIN ORDERS.PRODUCT P ON OI.PRODUCT_ID = P.PRODUCT_ID
WHERE OI.ORDER_ID = 10006 )
ORDER BY (C.LEN*C.WIDTH*C.HEIGHT) asc
LIMIT 1;

-- Query 8

-- Write a query to display details (customer id,customer fullname,order id,product quantity) 
-- of customers who bought more than ten (i.e. total order qty) products with credit card or 
-- Net banking as the mode of payment per shipped order. (6 ROWS)
-- [NOTE: TABLES TO BE USED - online_customer, order_header, order_items,]

SELECT OC.CUSTOMER_ID as customer__id,
CONCAT(CUSTOMER_FNAME,' ',CUSTOMER_LNAME) as customer__full_name,
OH.ORDER_ID as order__id,
OH.PAYMENT_MODE as payment__mode,
SUM(OI.PRODUCT_QUANTITY) as total__order__quantity
FROM ONLINE_CUSTOMER OC
INNER JOIN ORDER_HEADER OH ON OH.CUSTOMER_ID = OC.CUSTOMER_ID 
INNER JOIN ORDER_ITEMS OI ON OI.ORDER_ID = OH.ORDER_ID 
WHERE OH.ORDER_STATUS = 'Shipped' AND OH.PAYMENT_MODE IN('Net Banking','Credit Card') 
GROUP BY OH.ORDER_ID
HAVING Total__Order__Quantity > 10 
ORDER BY customer__id;

-- Query 9

-- Write a query to display the order_id, customer id and cutomer full name of customers starting with the alphabet "A"
-- along with (product_quantity) as total quantity of products shipped for order ids > 10030. (5 ROWS) 
-- [NOTE: TABLES TO BE USED - online_customer, order_header, order_items]

SELECT OH.ORDER_ID as order__id,
OC.CUSTOMER_ID AS customer__id,
CONCAT(CUSTOMER_FNAME,' ',CUSTOMER_LNAME) as customer__full__name,
SUM(OI.PRODUCT_QUANTITY) as order__quantity
FROM ONLINE_CUSTOMER OC
INNER JOIN ORDER_HEADER OH ON OH.CUSTOMER_ID = OC.CUSTOMER_ID
INNER JOIN ORDER_ITEMS OI ON OI.ORDER_ID = OH.ORDER_ID
WHERE OH.ORDER_STATUS = 'Shipped' AND OH.ORDER_ID > 10030 AND CUSTOMER_FNAME Like 'A%'
GROUP BY OH.ORDER_ID
ORDER BY Customer__Full__Name;




-- Query 10

-- Write a query to display product class description ,total quantity (sum(product_quantity),Total value (product_quantity * product price) 
-- and show which class of products have been shipped highest(Quantity) to countries outside India other than USA?
-- Also show the total value of those items. (1 ROWS)
-- [NOTE:PRODUCT TABLE,ADDRESS TABLE,ONLINE_CUSTOMER TABLE,ORDER_HEADER TABLE,ORDER_ITEMS TABLE,PRODUCT_CLASS TABLE]

SELECT PC.PRODUCT_CLASS_CODE as product__class__code,
PC.PRODUCT_CLASS_DESC as product__class__description,
SUM(OI.PRODUCT_QUANTITY) as total__quantity,
SUM(OI.PRODUCT_QUANTITY*P.PRODUCT_PRICE) as total__price
FROM ORDER_ITEMS OI
INNER JOIN ORDER_HEADER OH ON OH.ORDER_ID = OI.ORDER_ID
INNER JOIN ONLINE_CUSTOMER OC ON OC.CUSTOMER_ID = OH.CUSTOMER_ID
INNER JOIN PRODUCT P ON P.PRODUCT_ID = OI.PRODUCT_ID
INNER JOIN PRODUCT_CLASS PC ON PC.PRODUCT_CLASS_CODE = P.PRODUCT_CLASS_CODE
INNER JOIN ADDRESS A ON A.ADDRESS_ID = OC.ADDRESS_ID 
WHERE OH.ORDER_STATUS ='Shipped' AND A.COUNTRY NOT IN('India','USA')
GROUP BY PC.PRODUCT_CLASS_CODE,PC.PRODUCT_CLASS_DESC
ORDER BY Total__Quantity desc
LIMIT 1;
