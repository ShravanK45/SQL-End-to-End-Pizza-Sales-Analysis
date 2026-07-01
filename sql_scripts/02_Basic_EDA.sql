-- DATA ANALYSIS BASED ON THE QUESTION ASKED
-- 1.Retrieve the total number of orders placed.
SELECT COUNT(order_id)
FROM orders;

-- 2.Calculate the total revenue generated from pizza sales.
SELECT 
    SUM(od.quantity * p.price) AS total_sales
FROM
    pizzas AS p
        INNER JOIN
    order_details AS od ON p.pizza_id = od.pizza_id;
    
-- 3.Identify the highest-priced pizza.
SELECT pt.name,p.price
from pizzas as p
join pizza_types as pt
on p.pizza_type_id=pt.pizza_type_id
order by p.price desc limit 1;

-- 4.Identify the most common pizza size ordered.
SELECT p.size,count(order_details.order_details_id) as most_ordered
from pizzas as p
join order_details 
on p.pizza_id= order_details.pizza_id
group by p.size;

-- 5.List the top 5 most ordered pizza types along with their quantities.
select pt.name,sum(od.quantity) as Ordered_Quantity
from pizza_types as pt
join pizzas as p
on p.pizza_type_id = pt.pizza_type_id
join order_details as od
on od.pizza_id=p.pizza_id
group by pt.name 
order by Ordered_Quantity desc limit 5;

-- 6.Join the necessary tables to find the total quantity of each pizza category ordered.
select pt.category,sum(od.quantity) as ordered_quantity_by_category
from pizza_types as pt
join pizzas as p
on p.pizza_type_id = pt.pizza_type_id
join order_details as od
on od.pizza_id=p.pizza_id
group by pt.category 
order by sum(od.quantity) desc;

-- 7.Determine the distribution of orders by hour of the day.
select substring(o.order_time,1,2) as `Hours`,count(order_id) as `order`
from orders as o
group by `Hours` 
order by `Hours` asc;

-- 8.Join relevant tables to find the category-wise distribution of pizzas
select category,count(name) as total_type
from pizza_types 
group by category ;
