create database music_database
use music_database

--creating table
--we create table skeleton here and import the data from excel

--create table emp
DROP TABLE IF EXISTS emp;
CREATE TABLE emp (
    emp_id INT PRIMARY KEY,
    last_name NVARCHAR(100),
    first_name NVARCHAR(100),
    title NVARCHAR(100),
    reports_to INT NULL,
    levels NVARCHAR(10),
    birthdate DATE,
    hire_date DATE,
    address NVARCHAR(255),
    city NVARCHAR(100),
    state NVARCHAR(100),
    country NVARCHAR(100),
    postal_code NVARCHAR(20),
    phone NVARCHAR(50),
    fax NVARCHAR(50),
    email NVARCHAR(255)
);

--create table customer
DROP TABLE IF EXISTS customer;

CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    first_name NVARCHAR(40),
    last_name NVARCHAR(20),
    company NVARCHAR(80),
    address NVARCHAR(70),
    city NVARCHAR(40),
    state NVARCHAR(40),
    country NVARCHAR(40),
    postal_code NVARCHAR(10),
    phone NVARCHAR(24),
    fax NVARCHAR(24),
    email NVARCHAR(60),
    support_rep_id INT
);

--create table invoice
DROP TABLE IF EXISTS invoice;
CREATE TABLE invoice(
    invoice_id int PRIMARY KEY,
    customer_id int,
    invoice_date DATE,
    billing_address NVARCHAR(225),
    billing_city NVARCHAR(50),
    billing_state VARCHAR(50),
    billing_country VARCHAR(30),
    billing_postal_code VARCHAR(30),
    total FLOAT
);

--create table invoice_line
DROP TABLE IF EXISTS invoice_line;
CREATE TABLE invoice_line(
    invoice_line_id INT PRIMARY KEY,
    invoice_id INT,
    track_id INT,
    unit_price FLOAT,
    quantity INT
);

--create table track
DROP TABLE IF EXISTS track;
CREATE TABLE track(
    track_id INT PRIMARY KEY,
    name NVARCHAR(255),
    album_id INT,
    media_type_id INT,
    genre_id INT,
    composer NVARCHAR(255),
    milliseconds FLOAT,
    bytes BIGINT,
    unit_price FLOAT
);

--create table  playlist
DROP TABLE IF EXISTS playlist;
CREATE TABLE playlist(
    playlist_id INT PRIMARY KEY,
    name NVARCHAR(255)
);

--create table  playlist_track
DROP TABLE IF EXISTS playlist_track;
CREATE TABLE playlist_track(
    playlist_id INT,
    track_id INT
);

--create table  artist
DROP TABLE IF EXISTS artist;
CREATE TABLE artist(
    artist_id INT PRIMARY KEY,
    name NVARCHAR(255)
);

--create table  album
DROP TABLE IF EXISTS album;
CREATE TABLE album(
    album_id INT PRIMARY KEY,
    title NVARCHAR(255),
    artist_id INT
);

--create table  media_type
DROP TABLE IF EXISTS media_type;
CREATE TABLE media_type(
    media_type_id INT PRIMARY KEY,
    name NVARCHAR(255)
);

--create table  genre
DROP TABLE IF EXISTS genre;
CREATE TABLE genre(
    genre_id INT PRIMARY KEY,
    name NVARCHAR(255)
);

-- loading data into tables from csv using import export wizard 
select * from emp

select * from customer

select * from invoice

select * from invoice_line

select * from track

select * from playlist

select * from playlist_track

select * from artist

select * from album

select * from media_type

select * from genre

                                          --Question set 1--

--Q1: who is the senior most employee based on job title?

select top 1 * from emp
order by levels desc


--Q2:which country have more invoices

select * from invoice

select count(*) as coun,billing_country
from invoice
group by billing_country
order by coun desc

-- Q3: what are the top 3 values of total invoice

select top 3 * from invoice
order by total desc

/*Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city
we made the most money. Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals*/ 

select sum(total) as invoice_total,billing_city
from invoice
group by billing_city
order by invoice_total desc

/*Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

select top 1
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(i.total) AS total_spent
from
    customer c
join
    invoice i
on
    c.customer_id = i.customer_id
group by
    c.customer_id,
    c.first_name,
    c.last_name
order by
    total_spent DESC;

                                     --Question Set 2--

/*Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners.
Return your list ordered alphabetically by email starting with A */


select distinct email,first_name,last_name
from customer
join invoice on invoice.customer_id=customer.customer_id
join invoice_line on invoice_line.invoice_id=invoice.invoice_id
join track on track.track_id=invoice_line.track_id
join genre on genre.genre_id=track.track_id
where genre.name like 'rock'	
order by email


/*Q2:  Let's invite the artists who have written the most rock music in our dataset. Write a 
query that returns the Artist name and total track count of the top 10 rock bands */


select artist.artist_id,artist.name,count(artist.artist_id) as number_of_songs
from track
join album on album.album_id=track.album_id
join artist on artist.artist_id=album.artist_id
join genre on genre.genre_id=track.genre_id
where genre.name like'rock'
group by artist.artist_id,artist.name
order by number_of_songs desc



/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the 
longest songs listed first*/


select name,milliseconds  
from track
where milliseconds >(select avg(milliseconds) as avg_track_length from track)
order by milliseconds desc

                                   --Question Set 3 --

/*Q1: We want to find out the most popular music Genre for each country. 
We determine the most popular genre as the genre with the highest amount of purchases.
Write a query that returns each country along with the top Genre. 
For countries where the maximum number of purchases is shared return all Genres.
Steps to Solve:  There are two parts in question- first most popular music genre and second need data at country level.*/


   select
        count(invoice_line.quantity) as purchases,
        customer.country,
        genre.name,
        genre.genre_id,
        ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS rowno
    from 
        invoice_line 
    join
        invoice on invoice.invoice_id = invoice_line.invoice_id
    join 
        customer on customer.customer_id = invoice.customer_id
    JOIN 
        track on track.track_id = invoice_line.track_id
    join 
        genre on genre.genre_id = track.genre_id
    group by 
        customer.country, genre.name, genre.genre_id
    order by 
        customer.country asc,purchases desc


/* Q2. Find how much amount spent by each customer on artists? Write a query to return
customer name, artist name and total spent*/

with best_selling_artist as (
select artist.artist_id as artist_id, artist.name as artist_name,
sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
from invoice_line
join track on track.track_id=invoice_line.track_id
join album on album.album_id= track.album_id
join artist on artist.artist_id= album.artist_id
group by artist.artist_id,artist.name
)
select c.customer_id,c.first_name,c.last_name,bsa.artist_name ,
sum(il.unit_price*il.quantity) as amount_spent
from invoice i
join customer c on c.customer_id=i.customer_id
join invoice_line il on il.invoice_id=i.invoice_id
join track t on t.track_id=il.track_id
join album alb on alb.album_id=t.album_id
join best_selling_artist bsa on bsa.artist_id=alb.artist_id
group by c.customer_id,c.first_name,c.last_name,bsa.artist_name
order by amount_spent 




