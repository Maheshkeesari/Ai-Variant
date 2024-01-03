use excelr_zomato;
select * from zomato_fin1;

alter table zomato_fin1 modify column Datekey_Opening date;


#2.
select year(Datekey_Opening) years,
month(Datekey_Opening)  months,
day(datekey_opening) day ,
monthname(Datekey_Opening) monthname,Quarter(Datekey_Opening)as quarter,
concat(year(Datekey_Opening),'-',monthname(Datekey_Opening)) yearmonth, 
weekday(Datekey_Opening) weekday,
dayname(datekey_opening)dayname, 

case when monthname(datekey_opening) in ('January' ,'February' ,'March' )then 'Q1'
when monthname(datekey_opening) in ('April' ,'May' ,'June' )then 'Q2'
when monthname(datekey_opening) in ('July' ,'August' ,'September' )then 'Q3'
else  'Q4' end as quarters,

case when monthname(datekey_opening)='January' then 'FM10' 
when monthname(datekey_opening)='January' then 'FM11'
when monthname(datekey_opening)='February' then 'FM12'
when monthname(datekey_opening)='March' then 'FM1'
when monthname(datekey_opening)='April'then'FM2'
when monthname(datekey_opening)='May' then 'FM3'
when monthname(datekey_opening)='June' then 'FM4'
when monthname(datekey_opening)='July' then 'FM5'
when monthname(datekey_opening)='August' then 'FM6'
when monthname(datekey_opening)='September' then 'FM7'
when monthname(datekey_opening)='October' then 'FM8'
when monthname(datekey_opening)='November' then 'FM9'
when monthname(datekey_opening)='December'then 'FM10'
end Financial_months,
case when monthname(datekey_opening) in ('January' ,'February' ,'March' )then 'Q4'
when monthname(datekey_opening) in ('April' ,'May' ,'June' )then 'Q1'
when monthname(datekey_opening) in ('July' ,'August' ,'September' )then 'Q2'
else  'Q3' end as financial_quarters

from zomato_fin1;

#3.Find the Numbers of Resturants based on City and Country.
select sheet2.countryname,zomato_fin1.city,count(restaurantid)no_of_restaurants
from zomato_fin1 inner join sheet2 
on zomato_fin1.CountryCode=sheet2.countryid 
group by sheet2.countryname,zomato_fin1.city;

#4.Numbers of Resturants opening based on Year , Quarter , Month.
select year(datekey_opening)year,quarter(datekey_opening)quarter,monthname(datekey_opening)monthname,count(restaurantid)as no_of_restaurants 
from zomato_fin1 group by year(datekey_opening),quarter(datekey_opening),monthname(datekey_opening) 
order by year(datekey_opening),quarter(datekey_opening),monthname(datekey_opening) ;

#5. Count of Resturants based on Average Ratings.
select case when rating <=2 then "0-2" when rating <=3 then "2-3" when rating <=4 then "3-4" when Rating<=5 then "4-5" end rating_range,count(restaurantid) 
from zomato_fin1 
group by rating_range 
order by rating_range;


#6. Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets
select case when price_range=1 then "0-500" when price_range=2 then "500-3000" when Price_range=3 then "3000-10000" when Price_range=4 then ">10000" end price_range,count(restaurantid)
from zomato_fin1 
group by price_range
order by Price_range;

#7.Percentage of Resturants based on "Has_Online_delivery"
select has_online_delivery,concat(round(count(Has_Online_delivery)/100,1),"%") percentage 
from zomato_fin1 
group by has_online_delivery;

#8.Percentage of Resturants based on  "Has_Table_booking"
select has_table_booking,concat(round(count(has_table_booking)/100,1),"%") percentage from zomato_fin1 group by has_table_booking;

# highest rating restaurants in each country 
select  countryname,restaurantname,max(rating)highest_rating from zomato_fin1 inner join sheet2 
on zomato_fin1.countrycode=sheet2.countryid
group by countryname,restaurantname;

# top 5 restaurants who has more number of votes
select  countryname,restaurantname,votes,Average_Cost_for_two from zomato_fin1 inner join sheet2 on zomato_fin1.countrycode=sheet2.countryid
group by sheet2.countryname,restaurantname,votes,Average_Cost_for_two
order by votes desc limit 5;

# top restaurant with highest rating and votes from each country
select  countryname,restaurantname,max(rating)highest_rating,max(votes) from 
zomato_fin1 inner join sheet2 on zomato_fin1.countrycode=sheet2.countryid
group by countryname,restaurantname order by max(votes) desc limit 5;

SELECT 
  SUBSTRING_INDEX(cuisines, ',',1) AS split
FROM zomato_fin1;

SELECT restaurantname,
  cuisines,SUBSTRING_INDEX(cuisines, ',',1) AS split,SUBSTRING_INDEX(cuisines, ',',2) AS split,
  SUBSTRING_INDEX(cuisines, ',',1) 
FROM zomato_fin1;


SELECT 
  restaurantname, cuisines,
  SUBSTRING_INDEX(cuisines, ',', 1) AS cuisine1,
  SUBSTRING_INDEX(SUBSTRING_INDEX(cuisines, ',', 2), ',', -1) AS cuisine2,
SUBSTRING_INDEX(SUBSTRING_INDEX(cuisines, ',', 3), ',', -1) AS cuisine3
FROM zomato_fin1;

