--1  Who is the senior most employee based on job title?
select * from employee
order by levels desc
limit 1


---2 /* Q2: Which countries have the most Invoices?
select  count(*)  as total, billing_country 
from invoice
group by  billing_country
order by total desc


---What are top 3 values of total invoice? 

select total from invoice
order by total desc
limit 3


--- Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
--Write a query that returns one city that has the highest sum of invoice totals. 
--Return both the city name & sum of all invoice totals */

select sum(total) as tatall,billing_city
from invoice
group by billing_city
order by tatall desc


---select * from invoi Who is the best customer? The customer who has spent the most money will be declared the best customer. ce

---Write a query that returns the person who has spent the most money.*/
select customer.customer_id,customer.first_name ,sum(invoice.total) as totalll
from customer
join invoice on customer.customer_id=invoice.customer_id
group by customer.customer_id
order by totalll desc
limit 1

select * from customer

/* Question Set 2 - Moderate */

/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */
select distinct email,first_name,last_name
from customer
join invoice on customer.customer_id = invoice.customer_id 
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in(
    select track_id from track 
    join genre on track.genre_id = genre.genre_id
    where genre.name like 'Rock'
)
order by  email ;

select * from genre


--- Let's invite the artists who have written the most rock music in our dataset. 
---Write a query that returns the Artist name and total track count of the top 10 rock bands. */

SELECT artist.artist_id, artist.name,COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;






---Return all the track names that have a song length longer than the average song length. 
---Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.

select name,milliseconds
from track
where milliseconds >
(
select avg(milliseconds ) as avg_milli
from track
) 
order by milliseconds desc



---Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

with bestsell  as (
select artist.artist_id as artistid, artist.name as name,
sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
from invoice_line
join track on track.track_id = invoice_line.track_id
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
group by 1
order by  3 desc
limit 1
)
select  customer.customer_id, customer.first_name, customer.last_name ,bestsell.name,
sum(invoice_line.unit_price*invoice_line.quantity) as spent
from invoice
join customer  on  customer.customer_id =invoice.customer_id
join invoice_line on invoice_line.invoice_id = invoice.invoice_id
join track on track.track_id = invoice_line.track_id 
join album on album.album_id = track.album_id
join bestsell on bestsell.artistid = album.artist_id
group by 1,2,3,4
order by 5 desc ; 


--- We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
--with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
--the maximum number of purchases is shared return all Genres. */

with popular as(
select count (invoice_line.quantity) as purchases,customer.country,genre.name,genre.genre_id,
row_number()over (partition by customer.country order by count (invoice_line.quantity)desc )as rowno
from invoice_line 
join invoice on invoice.invoice_id = invoice_line.invoice_id
join customer on customer.customer_id = invoice.customer_id
join track on track.track_id = invoice_line.track_id
join genre on genre.genre_id = track.genre_id 
group by 2,3,4
order by 2 asc,1 desc

)
select * from popular where rowno <=1



 ---Q3: Write a query that determines the customer that has spent the most on music for each country. 
---Write a query that returns the country along with the top customer and how much they spent. 
---For countries where the top amount spent is shared, provide all customers who spent this amount. */


	with customer_country as (
select customer.customer_id,first_name,last_name,billing_country,sum(total) as total_spending,
row_number () over (partition by billing_country order by sum(total)desc) as rowno  
from invoice 
join customer on customer.customer_id = invoice.customer_id
group by 1,2,3,4
order by 4 asc ,5 desc )
select*from customer_country where rowno <=1
	
	