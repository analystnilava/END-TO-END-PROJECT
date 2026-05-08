CREATE DATABASE Customer_shopping;

select * from customer_behaviour_analysis;

-- Bisiness : question 
-- 1>which category genrate highst revenue 
select  category ,  
sum(purchase_amount ) as hight_revenue
from customer_behaviour_analysis
group by category order by hight_revenue desc
limit 1;
-- BUSINESS PROBLEM : The company does not know which product category generates the highest revenue.
-- IMAPACT :
--  Increase marketing focus on top-performing products
-- Optimize inventory and stock management
-- Improve sales strategy and customer targeting


-- 2> ARE DISCOUNT ACTULLY INCREASE PURCHASE VALUE 
SELECT  discount_applied ,
round(SUM(purchase_amount), 2),
round(AVG(purchase_amount) )
FROM customer_behaviour_analysis
GROUP BY discount_applied ;
-- Business Problem
-- The company does not know whether giving discounts actually increases customer spending or not.
-- Without this analysis, the company may give unnecessary discounts and lose prof 

-- Business Impact

-- This analysis helps the company:

-- Understand if discounts increase sales
-- Create better discount strategies
-- Avoid unnecessary discounts

-- 3> WHAT IS THE TOTAL REVENUE GENARETE BY MALE AND FEMALE CUSTOMERS 
select 
gender,
round(sum(purchase_amount), 2) as highest_rev
from customer_behaviour_analysis
where gender in ('Male' , 'Female')
group by gender
order by highest_rev desc ;

-- 4>which customer used discount but still spent more than the average purchace amount
select 
customer_id,
discount_applied,
purchase_amount
from  customer_behaviour_analysis
where discount_applied = 'Yes' and purchase_amount > (select avg(purchase_amount) from customer_behaviour_analysis  )
limit 10;

-- 5 which are the top/bottom 5 product with hight average revenue rating
select  item_purchased , 
round(avg(review_rating) ,2)as average_revenue_rating
from customer_behaviour_analysis
group by item_purchased  order by  average_revenue_rating desc
limit 5;
select  item_purchased , 
round(avg(review_rating) ,2)as average_revenue_rating
from customer_behaviour_analysis
group by item_purchased  order by  average_revenue_rating  desc
limit 5;

-- 6> average parchase : standart vs Express shepping 
select 
shipping_type,
count(distinct customer_id) as order_palced,
round(avg(purchase_amount),2) as avg_amount,
round(sum(purchase_amount), 2) as highest_rev
from 
customer_behaviour_analysis
group by shipping_type
having shipping_type in ('Express' , 'Standard')
order by highest_rev desc;

-- 2nd way
select 
shipping_type,
count(distinct customer_id) as order_palced,
round(avg(purchase_amount),2) as avg_amount,
round(sum(purchase_amount), 2) as highest_rev
from 
customer_behaviour_analysis
-- where shipping_type in ('Express' , 'Standard')
group by shipping_type
order by highest_rev desc;

--  7> Do subscribed customers spend more? Compare average spend and total revenue between subscribers and non-subscribers.
select 
subscription_status , 
count(customer_id ) as user,
round(AVG(purchase_amount) , 2)AS average_revenue,
round(sum(purchase_amount), 2 ) as total_revenue
from 
customer_behaviour_analysis
group by subscription_status;

-- 8> Top 5 products with highest discount usage %
select 
item_purchased,
count(item_purchased) as  no_of_time_sold,
count(case when  discount_applied="Yes" then 1 end) as  no_of_time_sold_when_discound_applied,
count(case when discount_applied="Yes" then 1 end) *100.0 / count(*) as no_of_time_sold_when_discound_parcentages
 from 
 customer_behaviour_analysis
 group by item_purchased;
 
-- 9> Segment customers into new, returning, and loyal based on total previous purchases and show count of each segment.
select * from customer_behaviour_analysis;
select 
case 
	when previous_purchases = 0 then "New customer"
    when previous_purchases between 1 and 15 then "returaning customers"
    else "loyal customers"
end as customer_segment,
count(*) as customer_count
 from customer_behaviour_analysis
group by case 
	when previous_purchases = 0 then "New customer"
    when previous_purchases between 1 and 15 then "returaning customers"
    else "loyal customers"
end ;

-- 11> What are the top 3 most purchased products within each category?
with cte as
(
select 
category,
count(item_purchased) as item_purchased,
rank() over(partition by category order by item_purchased)as rnk
from customer_behaviour_analysis
group by category,item_purchased)

select * from cte
where rnk <=3;

-- -- 10> Are repeat buyers (more than 5 previous purchases) also likely to subscribe?

select* from customer_behaviour_analysis;

select 
	case 
		when
		previous_purchases > 5  then "repet buyer"
        else "Normal customer"
        end as customer_type,
       subscription_status,
       count(*) as customer_count,
       count(*) *100.00 / sum(count(*)) over(partition by
																		case 
																			when 
                                                                            previous_purchases > 5  then "repet buyer"
                                                                            else "Normal customer"
                                                                            end 
																) as percents
        from customer_behaviour_analysis
        group by 
        case 
		when
		previous_purchases > 5  then "repet buyer"
        else "Normal customer"
        end ,subscription_status;
 
 -- 12> What is the revenue contribution of each age group?
 select
		case 
			when age between 10 and 25 then "18 -25"
			when age between 26 and 35 then "26 -35"
            when age between 36 and 50 then "36 -50"
            else "51+"
            end as age_group,
            round(sum(purchase_amount  ),2) as total_rev
            from customer_behaviour_analysis
            group by 		case 
			when age between 10 and 25 then "18 -25"
			when age between 26 and 35 then "26 -35"
            when age between 36 and 50 then "36 -50"
            else "51+"
            end order by total_rev desc;
            
            