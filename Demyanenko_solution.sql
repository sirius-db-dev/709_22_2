-- games and buyers
create extension if exists "uuid-ossp";
drop table if exists gamers, buyers, games_to_buyers cascade;

create table gamers
(
	id uuid primary key default uuid_generate_v4(),
	title text,
	genre text,
	price int
);

insert into gamers(title, genre, price) values 

	('Minecraft', 'All-in-one', 15),
	('Rayman Origins', 'Platformer', 9),
	('Halo: Reach', 'AAA shooter', 15);

create table buyers
(
	id uuid primary key default uuid_generate_v4(),
	nickname text,
	reg_date date
);



insert into buyers(nickname, reg_date) values
	('PewDiePie', '2008.05.01'),
	('MoDDyChat', '2009.01.03'),
	('mrLololowka', '2010.03.04');



create table games_to_buyers
(
	gamers_id uuid references gamers,
	buyers_id uuid references buyers,
	primary key(gamers_id, buyers_id)
);


insert into games_to_buyers(gamers_id, buyers_id) values
	((select gamers.id from gamers where title='Minecraft'),(select buyers.id from buyers where nickname='PewDiePie')),
	((select gamers.id from gamers where title='Minecraft'),(select buyers.id from buyers where nickname='MoDDyChat')),
	((select gamers.id from gamers where title='Minecraft'),(select buyers.id from buyers where nickname='mrLololowka')),
	((select gamers.id from gamers where title='Halo: Reach'),(select buyers.id from buyers where nickname='PewDiePie')),
	((select gamers.id from gamers where title='Rayman Origins'),(select buyers.id from buyers where nickname='MoDDyChat'));


select *
from gamers g
         left join games_to_buyers gb on g.id = gb.gamers_id
         left join buyers b on gb.buyers_id = b.id;

select
  g.id,
  g.title,
  g.genre,
  g.price,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', b.id, 'nickname', b.nickname, 'reg_date', b.reg_date))
      filter (where b.id is not null), '[]') as buyers
from gamers g
left join games_to_buyers gb on g.id = gb.gamers_id
left join buyers b on b.id = gb.buyers_id
group by g.id;


select
  b.nickname,
  b.reg_date,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', g.id, 'title', g.title, 'genre', g.genre,'price', g.price))
      filter (where g.id is not null), '[]') as gamers
from buyers b
left join games_to_buyers  gb on b.id = gb.buyers_id
left join gamers g on g.id = gb.gamers_id
group by b.id;

-- courses and students

drop table if exists courses, students, course_to_student cascade;


create table courses
(
	id uuid primary key default uuid_generate_v4(),
	title text,
	description text
);


insert into courses(title, description) values
	('Python in an hour', 'You will master python in an hour!(hour a day for three years)'),
	('Complete C++ course', '99999 hours of coding on the most efficient language there is!');

	
create table students
(
	id uuid primary key default uuid_generate_v4(),
	first_name text,
	last_name text,
	start_year int
);

insert into students(first_name, last_name, start_year) values
	('Arthur', 'Pirozhkov', 2000),
	('Mikhail', 'Galustyan', 2000),
	('Peter', 'Glance', 2003);

create table course_to_student
(
	course_id uuid references courses,
	student_id uuid references students,
	primary key(course_id, student_id)
);

insert into course_to_student(course_id, student_id) values
	((select courses.id from courses  where title='Python in an hour'),(select students.id from students where first_name='Arthur')),
	((select courses.id from courses where title='Python in an hour'),(select students.id from students where first_name='Mikhail')),
	((select courses.id from courses where title='Python in an hour'),(select students.id from students where first_name='Peter')),
	((select courses.id from courses where title='Complete C++ course'),(select students.id from students where first_name='Arthur')),
	((select courses.id from courses where title='Complete C++ course'),(select students.id from students where first_name='Peter'));

select *
from courses c
         left join course_to_student cs on c.id = cs.course_id
         left join students s on cs.student_id = s.id;

select
  c.id,
  c.title,
  c.description,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', s.id, 'first_name', s.first_name, 'last_name', s.last_name, 'start_year', s.start_year))
      filter (where s.id is not null), '[]') as students
from courses c
left join course_to_student cs on c.id = cs.course_id
left join students s on s.id = cs.student_id
group by c.id;


select
  s.id,
  s.first_name,
  s.last_name,
  s.start_year,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', c.id, 'title', c.title, 'description', c.description))
      filter (where c.id is not null), '[]') as courses
from students  s
left join course_to_student cs on s.id = cs.student_id
left join courses c on c.id = cs.course_id
group by s.id;

-- festivals and participants

drop table if exists festivals, participants, festival_to_participant cascade;

create table festivals
(
	id uuid primary key default uuid_generate_v4(),
	title text,
	dates date,
	place text
);

insert into festivals(title, dates, place) values
('On duty 4 planet', '2023.04.12', 'Khanty-Mansiysk'),
('WYF', '2024.03.01', 'Sirius'),
('Nauka 0+', '2023.10.07', 'Moscow');

create table participants
(
	id uuid primary key default uuid_generate_v4(),
	first_name text,
	last_name text,
	birth_date date
);

insert into participants(first_name, last_name, birth_date) values
('Anton', 'Rogachev', '1975.03.10'),
('Vladimir', 'Gershenzon', '1961.03.01'),
('Peter', 'Parker', '1995.09.07');

create table festival_to_participant
(
	festival_id uuid references festivals,
	participant_id uuid references participants,
	primary key(festival_id, participant_id)
);

insert into festival_to_participant(festival_id, participant_id) values
	((select festivals.id from festivals  where title='On duty 4 planet'),(select participants.id from participants where first_name='Anton')),
	((select festivals.id from festivals where title='On duty 4 planet'),(select participants.id from participants where first_name='Vladimir')),
	((select festivals.id from festivals where title='On duty 4 planet'),(select participants.id from participants where first_name='Peter')),
	((select festivals.id from festivals where title='Nauka 0+'),(select participants.id from participants where first_name='Anton')),
	((select festivals.id from festivals where title='WYF'),(select participants.id from participants where first_name='Anton'));

-- select * from festival_to_participant;

select *
from festivals f
         left join festival_to_participant fp on f.id = fp.festival_id
         left join participants p on fp.participant_id = p.id;

select
  f.id,
  f.title,
  f.dates,
  f.place,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', p.id, 'first_name', p.first_name, 'last_name', p.last_name, 'birth_date', p.birth_date))
      filter (where p.id is not null), '[]') as participants
from festivals f
left join festival_to_participant fp on f.id = fp.festival_id
left join participants p on p.id = fp.participant_id
group by f.id;


select
  p.id,
  p.first_name,
  p.last_name,
  p.birth_date,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'title', f.title, 'dates', f.dates, 'place', f.place))
      filter (where f.id is not null), '[]') as festivals
from participants p
left join festival_to_participant fp on p.id = fp.participant_id
left join festivals f on f.id = fp.festival_id
group by p.id;

