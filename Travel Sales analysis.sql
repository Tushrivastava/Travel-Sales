
Create database Travel;
Use Travel;

CREATE TABLE booking_table(
  Booking_id  VARCHAR(3) NOT NULL,
  Booking_date date NOT NULL,
 User_id     VARCHAR(2) NOT NULL,
 Line_of_business VARCHAR(6) NOT NULL);


INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES
('b1','2022-03-23','u1','Flight'),
('b2','2022-03-27','u2','Flight'),
('b3','2022-03-28','u1','Hotel'),
('b4','2022-03-31','u4','Flight'),
('b5','2022-04-02','u1','Hotel'),
('b6','2022-04-02','u2','Flight'),
('b7','2022-04-06','u5','Flight'),
('b8','2022-04-06','u6','Hotel'),
('b9','2022-04-06','u2','Flight'),
('b10','2022-04-10','u1','Flight'),
('b11','2022-04-12','u4','Flight'),
('b12','2022-04-16','u1','Flight'),
('b13','2022-04-19','u2','Flight'),
('b14','2022-04-20','u5','Hotel'),
('b15','2022-04-22','u6','Flight'),
('b16','2022-04-26','u4','Hotel'),
('b17','2022-04-28','u2','Hotel'),
('b18','2022-04-30','u1','Hotel'),
('b19','2022-05-04','u4','Hotel'),
('b20','2022-05-06','u1','Flight');

CREATE TABLE user_table(
  User_id VARCHAR(3) NOT NULL
 ,Segment VARCHAR(2) NOT NULL);
INSERT INTO user_table(User_id,Segment) VALUES 
 ('u1','s1'),
 ('u2','s1'),
 ('u3','s1'),
 ('u4','s2'),
 ('u5','s2'),
 ('u6','s3'),
 ('u7','s3'),
 ('u8','s3'),
 ('u9','s3'),
 ('u10','s3');
 
Select * FROM booking_table;
SELECT * FROM user_table;

--1.Write a query to find the total number of users for each segment and total number of users who booked flight in April 2022.

Select segment, count(*) from user_table
GROUP BY segment;

Select u.segment,
	COUNT(Distinct u.user_id) total_users,
    COUNT(Distinct 
		CASE WHEN 
				Line_of_Business= 'Flight'
                AND
                Booking_date BETWEEN '2022-04-01' AND '2022-04-30'
                THEN u.user_id
                END) total_flight_booked
	FROM user_table as u
    LEFT JOIN booking_table b
    ON b.user_id = u.user_id
    GROUP BY u.segment;


--2.Write a query to identify users whose first booking was a hotel booking.

Select * FROM
	( Select *, 
		Rank() Over(Partition By user_id Order By booking_date ASC) As rn
	From booking_table) a
	Where rn=1 and line_of_business = 'Hotel';
    
--2nd Method

Select Distinct user_id
FROM 
	( Select *, 
		First_value(line_of_business) Over(Partition By user_id Order By booking_date ASC) As first_booking
	From booking_table) a
	Where first_booking = 'Hotel';



-- 3.Write a query to calculate the days between first and last booking of each user.

Select user_id,
Datediff(day,Max(Booking_date),
Min(Booking_date)) As Days_diff
FROM booking_table
Group By user_id;

--Method 2

Select u.user_id,
MIN(b.Booking_date) as FirstBookingDate,
MAX (b.Booking_date) as LastBookingDate,
DATEDIFF(day,MIN(b.Booking_date),
MAX(b.Booking_date))as DayesBetweenFirstAndLastBooking
From 
user_table u
join
booking_table b
on 
u.User_id=b.User_id
Group by u.User_id
    


-- 4.Write a query to count the number of flight and hotel bookings in each user segments for the year 2022.



Select segment, 
	SUM( CASE WHEN line_of_business = 'flight' THEN 1 Else 0 END) As No_of_flight,
    SUM( CASE WHEN line_of_business ='Hotel' THEN 1 ELse 0 END ) As No_of_hotel
From  booking_table b
INNER JOIN user_table u
ON b.user_id=u.user_id
Group By segment;
        