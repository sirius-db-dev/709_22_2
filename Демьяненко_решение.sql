drop table if exists items, reviews;

create table items (
id int primary key,
name text,
description text,
price int
);

insert into items (id, name, description, price) values
(1, 'Bread', 'Baguette', 100),
(2, 'Milk', 'Farmers milk', 80),
(3, 'Chips', 'Lays Chips', 999);

select * from items;


create table reviews (
id int,
review text,
mark float,
item_id int references items not null
);

insert into reviews (id, review, mark, item_id) values
(1, 'This bagguete is delicuous!', 5.0, 1),
(2, 'That milk was digusting!', 1.0, 2),
(3, 'Too expensive.', 2.5, 3),
(4, 'Great farmers milk', 4.3, 2);

select *
from items
join reviews on items.id = reviews.item_id;


select
        i.id,
        i.name,
        i.description,
        i.price,
        coalesce (jsonb_agg(jsonb_build_object('id', re.id, 'review', re.review, 'mark', re.mark)) filter(where re.id is not null), '[]') as reviews

from items i
join reviews re on i.id = re.item_id
group by i.id;


###################################
drop table if exists videos, comments

create table videos( 
id int primary key,
name text,
description text,
release_date date
);

insert into videos (id, name, description, release_date) values
(1, 'Day in the zoo', 'First ever video on YouTube', '2001.01.01'),
(2, 'PewDiePie vs TSeries', 'Some random video', '2019.10.15'),
(3, 'Baby Shark', 'Oh no...', '2021.09.15');

create table comments(
id int,
video_id int references videos not null,
comment text,
like_count int
);

insert into comments (id, video_id, comment, like_count) values
(1, 1, 'Legendary piece of internet history!', 999),
(2, 2, 'PewDiePie is boring', 0),
(3, 2, 'Finally worthy oponnent! Our battle will be legendary!', 250),
(4, 3, 'Someone delete this please!', 9999);


select *
from videos
join comments on videos.id = comments.video_id;


select
        v.id,
        v.name,
        v.description,
        v.release_date,
        coalesce (jsonb_agg(jsonb_build_object('id', ce.id, 'comment', ce.comment, 'like_count', ce.like_count)) filter(where ce.id is not null), '[]') as comments

from videos v
join comments ce on v.id = ce.video_id
group by v.id;

#################################################

drop table if exists chats, messages;

create table chats(
id int primary key,
name text,
description text,
created date
);

insert into chats (id, name, description, created) values
(1, 'Chat for students', 'To infinity and beyond!', '2022.09.01'),
(2, 'Chat for teachers', 'A', '2021.08.01');

select * from chats;

create table messages(
id int, 
message text,
sent date,
chatik_id int references chats not null
);


select * from messages;

insert into messages (id, message, sent, chatik_id) values
(1, 'Hello everyone!', '2022.09.01', 1),
(2, 'This is Elon Musk, Teslas co-founder and CEO', '2022.09.01', 1),
(3, 'Who added this guy here?', '2022.09.02', 1),
(4, 'What is databases homework was?', '2024.02.10', 1),
(5, 'Where is the timetable for this week?', '2024.09.01', 1),
(6, 'WHY SO SERIOUS?!?!?!?!', '2023.09.04', 1),
(7, 'Hello everyone!', '2021.09.01', 2),
(8, 'Hello everyone!', '2021.08.01', 2),
(9, 'Someone hacked VK termial, we need to fix it quick...', '2023.11.05', 2);


select *
from chats 
join messages on chats.id = messages.chatik_id;

select
        c.id,
        c.name,
        c.description,
        c.created,
        coalesce (jsonb_agg(jsonb_build_object('id', me.id, 'name', me.message, 'sent', me.sent)) filter(where me.id is not null), '[]') as messages

from chats c
join messages me on c.id = me.chatik_id
group by c.id;

