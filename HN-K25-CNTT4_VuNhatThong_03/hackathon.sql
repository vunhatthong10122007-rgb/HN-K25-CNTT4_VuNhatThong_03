create database AuctionFloor ;
use AuctionFloor;

create table Users (
    user_id varchar(5) primary key,
    full_name varchar(100) not null,
    email varchar(100) not null unique,
    phone varchar(15) not null,
    account_type enum('Standard', 'Premium', 'VIP') not null,
    join_date date not null
);

	CREATE TABLE Auction_Items (
		item_id varchar(5) primary key,
		item_name varchar(100) not null unique,
		category varchar(50) not null,
		start_price decimal(15,2) not null,
		end_time datetime not null,
		status enum('Active', 'Closed', 'Canceled') not null
	);

CREATE TABLE Bids (
    bid_id INT auto_increment primary key,
    item_id varchar(5) not null,
    user_id varchar(5) not null,
    bid_amount decimal(15,2) not null,
    bid_time datetime not null,
    foreign key (item_id) references Auction_Items(item_id),
    foreign key (user_id) references Users(user_id)
);

CREATE TABLE Winners (
    winner_id int auto_increment primary key,
    item_id varchar(5) not null unique,
    user_id varchar(5) not null,
    final_price decimal(15,2) not null,
    win_date date not null,
	foreign key (item_id) references Auction_Items(item_id),
    foreign key (user_id) references Users(user_id)
);

insert into Users (user_id, full_name, email, phone, account_type, join_date)
values
('U01', 'Nguyễn Anh Quân', 'quan.na@gmail.com', '0912345678', 'Premium', '2025-01-10'),
('U02', 'Trần Minh Tú', 'tu.tm@gmail.com', '0987654321', 'Standard', '2025-02-15'),
('U03', 'Lê Thu Thủy', 'thuy.lt@gmail.com', '0978123456', 'Premium', '2025-03-20'),
('U04', 'Phạm Gia Bảo', 'bao.pg@gmail.com', '0909876543', 'Standard', '2025-04-12');

insert into Auction_Items(item_id, item_name, category, start_price, end_time, status)
values
('I01', 'Rolex Datejust 1970', 'Jewelry', 50000000, '2025-11-20 20:00:00', 'Active'),
('I02', 'Tranh sơn dầu Phố Cổ', 'Art', 15000000, '2025-11-21 18:00:00', 'Active'),
('I03', 'Macbook Pro M3 Max', 'Tech', 35000000, '2025-11-15 10:00:00', 'Closed'),
('I04', 'Rượu vang đỏ 1990', 'Collectible', 10000000, '2025-12-05 21:00:00', 'Active');

insert into Bids(bid_id, item_id, user_id, bid_amount, bid_time)
values
('1', 'I01', 'U01', 55000000, '2025-11-10 09:00:00'),
('2', 'I02', 'U02', 16000000, '2025-11-10 10:30:00'),
('3', 'I01', 'U03', 60000000, '2025-11-11 14:00:00'),
('4', 'I03', 'U04', 36000000, '2025-11-12 08:00:00'),
('5', 'I02', 'U01', 17500000, '2025-11-12 15:20:00');

-- 4 
update Auction_Items
set start_price = start_price * 1.15
where item_id = 'I01';

-- 5 
update Users
set account_type  = 'VIP'
where user_id = 'U02';

-- 6
delete from Bids
where bid_amount < 15000000;

-- 7 
alter table Bids
add constraint check_bid_amount check (bid_amount>0);

-- 8 
update Auction_Items
set status = 'Active';

-- 9 
alter table Users
add column location varchar(100);

-- 10 
select item_id, item_name, category, start_price, end_time, status
from Auction_Items
where category =  'Tech' or category = 'Jewelry';

-- 11 
select full_name, email
from Users 
where full_name like '%a%';

-- 12 
select  item_id, item_name, end_time
from Auction_Items
order by end_time asc;
	
-- 13
select  item_id, item_name, category, start_price, end_time, status
from Auction_Items
order by start_price desc
limit 3;

-- 14 
select item_name, category
from Auction_Items
limit 2
offset 1;

-- 15 
update Auction_Items
set start_price = start_price * 0.9
where time(end_time) < '12:00:00';

-- 16 
update Users
set full_name = lower(full_name);

-- 18 
select b.bid_id, u.full_name , a.item_name, b.bid_amount 
from Bids b
join Users u 
on b.user_id = u.user_id
join Auction_Items a
on b.item_id = a.item_id
where a.status = 'Active';

-- 19 
select item_name, bid_id, a.item_id, b.user_id, bid_amount, bid_time
from Bids b
right join Auction_Items a
on b.item_id = a.item_id;

-- 20
select a.item_name, sum(b.bid_amount) as total_bid
from  Auction_Items a
join  Bids b
on a.item_id = b.item_id
group by a.item_name, a.item_id;

-- 21
SELECT u.full_name, COUNT(DISTINCT b.item_id) as sp_count
FROM Users u
JOIN Bids b ON u.user_id = b.user_id
GROUP BY u.user_id, u.full_name
HAVING COUNT(DISTINCT b.item_id) >= 2;

-- 22
SELECT * FROM Bids WHERE bid_amount < (SELECT AVG(bid_amount) FROM Bids);

-- 23
SELECT DISTINCT u.full_name, u.account_type
FROM Users u
JOIN Bids b ON u.user_id = b.user_id
JOIN Auction_Items ai ON b.item_id = ai.item_id
WHERE ai.item_name = 'Rolex Datejust 1970';

