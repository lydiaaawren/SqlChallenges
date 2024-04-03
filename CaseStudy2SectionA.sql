-- A. Pizza Metrics


-- How many pizzas were ordered? 14

select count( pizza_id ) OrderedPizzas from customer_orders;



-- How many unique customer orders were made? 10

select count ( distinct order_id) OrderCount from customer_orders;



-- How many successful orders were delivered by each runner?

select runner_id, count(*) CancelledOrders from runner_orders
where duration = 'null'
group by runner_id;



-- How many of each type of pizza was delivered?

select pizza_id, count(*) PizzaCount from customer_orders
where order_id not in (
    select order_id from runner_orders
    where duration='null'
)
group by pizza_id;



-- How many Vegetarian and Meatlovers were ordered by each customer?

with orders as (
select co.customer_id, pn.pizza_name, count(*) PizzaCount from customer_orders co
join pizza_names pn on co.pizza_id=pn.pizza_id

group by co.customer_id, pn.pizza_name)

select * from orders
pivot ( sum(PizzaCount) for pizza_name in ('Meatlovers', 'Vegetarian'));




-- What was the maximum number of pizzas delivered in a single order? 3

with orders as (

    select order_id, count(*) as PizzaCount
    from customer_orders
    where order_id not in (
        select order_id from runner_orders
        where duration='null'
        )
    group by order_id
)

select max(PizzaCount) from orders;



-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes? 6

with DeliveredOrders as (

    select *
    from customer_orders
    where order_id not in (
        select order_id from runner_orders
        where duration='null'
        )
),

changes as (

        select 
            order_id
            ,pizza_id
            ,case
                    when exclusions='' then 0
                    when exclusions='null' then 0
                    else 1
            end as ExclusionInd
            ,case
                    when extras='' then 0
                    when extras is null then 0
                    when extras='null' then 0
                    else 1
            end as ExtrasInd
        from DeliveredOrders
)

select count(*) from changes 
where ExclusionInd > 0
or ExtrasInd > 0;


-- How many pizzas were delivered that had both exclusions and extras? 1

with DeliveredOrders as (

    select *
    from customer_orders
    where order_id not in (
        select order_id from runner_orders
        where duration='null'
        )
),

changes as (

        select 
            order_id
            ,pizza_id
            ,case
                    when exclusions='' then 0
                    when exclusions='null' then 0
                    else 1
            end as ExclusionInd
            ,case
                    when extras='' then 0
                    when extras is null then 0
                    when extras='null' then 0
                    else 1
            end as ExtrasInd
        from DeliveredOrders
)

select count(*) from changes 
where ExclusionInd > 0
and ExtrasInd > 0;



-- What was the total volume of pizzas ordered for each hour of the day?

select hour(order_time) OrderHour, count(*) OrderCount from customer_orders
group by OrderHour
order by OrderHour;



-- What was the volume of orders for each day of the week?

select dayname(order_time) OrderDay, count(*) OrderCount from customer_orders
group by OrderDay;


