-- 9.Group the orders by date and calculate the average number of pizzas ordered per day.
select avg(order_quantity.total_quantity) as avg_order_per_day
from
(select o.order_date,sum(od.quantity) as total_quantity
from orders as o
join order_details as od
on o.order_id= od.order_id
group by o.order_date) as order_quantity;

-- 10.Determine the top 3 most ordered pizza types based on revenue.
select pt.name,sum(p.price*od.quantity) as revenue
from pizzas as p
join order_details as od
on od.pizza_id=p.pizza_id
join pizza_types as pt
on pt.pizza_type_id=p.pizza_type_id
group by pt.name
order by revenue desc limit 3;

-- 11.Calculate the percentage contribution of each pizza type to total revenue.

with total_sales as(
select round(sum(price*quantity),2) as total_revenue
from pizzas as p
join order_details as od
on p.pizza_id=od.pizza_id
)
select p.pizza_type_id,
round((SUM(od.quantity*p.price)/MAX(ts.total_revenue))*100,2) as revenue_percentage
FROM pizzas as p
join order_details as od
on od.pizza_id=p.pizza_id
cross join total_sales ts
group by p.pizza_type_id
order by revenue_percentage desc;

-- 12.Analyze the cumulative revenue generated over time.(Rolling Total);
select order_date,
sum(total_revenue) over (order by order_date) as cumulative_revenue
from(
select o.order_date,sum(p.price*od.quantity) as total_revenue
from order_details as od
join pizzas as p
on p.pizza_id=od.pizza_id
join orders as o
on o.order_id=od.order_id
group by o.order_date) as total_daily_sales;

-- 13.Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select category,name,total_revenue,ranking
from
(select category,name,total_revenue,
DENSE_RANK() OVER(PARTITION BY category order by total_revenue desc) as ranking 
from(
select pt.name,pt.category,sum(p.price*od.quantity) as total_revenue
from pizza_types as pt
join pizzas as p
on p.pizza_type_id=pt.pizza_type_id
join order_details as od
on od.pizza_id=p.pizza_id
group by  pt.name,pt.category) as total_sales) as rankingtable
where ranking<=3
;
