==================ANALYSIS================

set search_path to tembo_hotel;
---===1. Revenue analysis: Total revenue by month, by room type, by payment method
--a).Total revenue by month
select
date_part('month',check_out_date) as month,
date_part('year',check_out_date)::text as year,
sum(total_amount) as revenueamount_
from cleaned_bookings_final
group by month,year
order by year,month;

---b).Revenue by room type
select
room_type, sum(total_amount) as Revenue_by_room_type
from cleaned_bookings_final
group by room_type;

--c).Revenue by payment type
select payment_method,
sum(total_amount) as Revenue_by_payment_method
from cleaned_bookings_final
group by payment_method;

---2.Occupancy: 
---a).Room_types Booked the most 
select room_type,count(Booking_id) as bookingcount
from cleaned_bookings_final
group by room_type;

---or showing in desc
with Bookings as 
(select room_type,count(Booking_id) as bookingcount
from cleaned_bookings_final
group by room_type)
select room_type,bookingcount from bookings order by bookingcount desc;

--b).Average nights stayed per room type
select room_type,round(AVG(nights_stayed),0) as avg_stayed_per_roomtype
from cleaned_bookings_final
group by room_type;

---3.Guest insights:  
---a)Top 10 cities where guests come from 
select guest_city,count(booking_id) as count_by_city
from cleaned_bookings_final
group by guest_city 
order by count_by_city desc
limit 10;

---b)Average rating per room type
select room_type, round(avg(guest_rating),2) as avg_rating
from cleaned_bookings_final
group by room_type;

select *from cleaned_bookings_final;

---4.Staff performance: 
--a)Which staff handled the most bookings? 
select * from (
select staff_name,count(booking_id), dense_rank() over(order by count(booking_id)desc) 
as bookings_per_staff
from cleaned_bookings_final
group by staff_name)
where bookings_per_staff = 1;

--b)---Which department generates most revenue?
select staff_department, total_rev from (
select staff_department,sum(total_amount) as total_rev,
dense_rank()over(order by sum(total_amount)desc) as revenue_per_department
from cleaned_bookings_final
group by staff_department)
where revenue_per_department= 1;--- Subquery way

--OR the CTE way
with revenueby_staff_department_ as (
select staff_department,sum(total_amount) as deptrevenue_
from cleaned_bookings_final
group by staff_department)
select * from revenueby_staff_department_
where deptrevenue_ = (select max(deptrevenue_) from revenueby_staff_department_);

----5).Trends: 
--a)Revenue growth month over month (window function)
--- With percentage comparison
SELECT 
DATE_TRUNC ('month', check_in_date) AS month,
  SUM(total_amount) AS monthly_revenue,
  LAG(SUM(total_amount)) OVER (
    ORDER BY DATE_TRUNC('month',check_in_date )
  ) AS prev_month_revenue,
ROUND(
    (SUM(total_amount) - LAG(SUM(total_amount)) OVER (
        ORDER BY DATE_TRUNC('month', check_in_date))) 
    / LAG(SUM(total_amount)) OVER (ORDER BY DATE_TRUNC('month', check_in_date)
     ) * 100,2
  ) AS mom_growth_pct
FROM cleaned_bookings_final
GROUP BY DATE_TRUNC('month', check_in_date)
ORDER BY month;

----without the percentage comparison
select date_trunc ('month', check_in_date) as month,sum(total_amount) as monthlyrevenue_,
lag(sum(total_amount)) over (order by date_trunc('month',check_in_date )) 
as prevmonthrevenue__,
(sum(total_amount) - lag(sum(total_amount)) 
over (order by date_trunc('month', check_in_date))) as momgrowth_
from cleaned_bookings_final
group by date_trunc('month', check_in_date)
order by month;

---- USING CTE
with monthlyrevenue_ as(
select
date_part('month', check_in_date) as month,
date_part('year', check_in_date)::text as year,
sum(total_amount) as curentmonth_revenue_
from cleaned_bookings_final
group by 1, 2)
select *, lag(curentmonth_revenue_) over(order by mv.year,mv.month ) as previousmonth_
from monthlyrevenue_ mv;

---b).. Busiest vs quietest months
select * from cleaned_bookings_final;

with sum_bookings as (
select date_trunc('month', check_in_date) as month,
date_trunc('year', check_in_date)::text as year,
sum(total_amount) as bookings_per_month_total from cleaned_bookings_final
group by month, year)
select * from sum_bookings
where bookings_per_month_total = (select MAX(bookings_per_month_total) from sum_bookings)or bookings_per_month_total = (select MIN(bookings_per_month_total) from sum_bookings);

----6). Cancellations:  
 --- a).Cancellation rate per room type.
select booking_status,room_type, count(distinct booking_id)
from cleaned_bookings_final
where booking_status= 'Cancelled'
group by booking_status,room_type;

---Revenue Lost from cancellations and No shows
select booking_status, sum(total_amount) as lost_revenue
from cleaned_bookings_final
where booking_status= 'Cancelled' or booking_status= 'No Show'
group by booking_status;
