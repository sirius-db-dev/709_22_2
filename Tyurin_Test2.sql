create extension if not exists "uuid-ossp";

/* ======== 1 ======== */

drop table if exists tasks, pupils, pupil_to_task;

create table tasks
(
	id uuid primary key default uuid_generate_v4(),
	name text,
	description text,
	difficult text
);

create table pupils
(
	id uuid primary key default uuid_generate_v4(),
	nickname text,
	registration_date date,
	rating int
);

create table pupil_to_task
(
	pupil_id uuid references pupils not null,
	task_id uuid references tasks not null,
	primary key (pupil_id, task_id)
);

insert into tasks (name, description, difficult) values
(
	'task1',
	'description1',
	'easy'
),
(
	'task2',
	'description2',
	'normal'
),
(
	'task3',
	'description3',
	'hard'
);

insert into pupils (nickname, registration_date, rating) values
(
	'pupil1',
	'2024.01.05',
	99
),
(
	'pupil2',
	'2023.12.27',
	87
),
(
	'pupil3',
	'2024.02.19',
	43
);


insert into pupil_to_task (pupil_id, task_id) values
(
	(select id from pupils where nickname='pupil1'),
	(select id from tasks where name='task1')
),
(
	(select id from pupils where nickname='pupil1'),
	(select id from tasks where name='task2')
),
(
	(select id from pupils where nickname='pupil2'),
	(select id from tasks where name='task2')
);

select
	p.id,
	p.nickname,
	p.registration_date,
	p.rating,
	coalesce(json_agg(json_build_object(
	    'id', t.id, 'name', t.name, 
	    'description', t.description, 'difficult', t.difficult))
	    filter (where t.id is not null), '[]') as tasks
	from pupils p
	left join pupil_to_task pt on p.id = pt.pupil_id
	left join tasks t on t.id = pt.task_id
	group by p.id;

select
	t.id,
	t.name,
	t.description,
	t.difficult,
	coalesce(json_agg(json_build_object(
	    'id', p.id, 'nickname', p.nickname, 
	    'registration_date', p.registration_date, 'rating', p.rating))
	    filter (where p.id is not null), '[]') as pupils
	from tasks t
	left join pupil_to_task pt on t.id = pt.task_id
	left join pupils p on p.id = pt.pupil_id
	group by t.id;

/* ======== 2 ======== */

drop table if exists recepies, ingredients, recepy_to_ingredient;

create table recepies
(
	id uuid primary key default uuid_generate_v4(),
	name text,
	description text,
	category text
);

create table ingredients
(
	id uuid primary key default uuid_generate_v4(),
	name text,
	category text,
	price int
);

create table recepy_to_ingredient
(
	recepy_id uuid references recepies not null,
	ingredient_id uuid references ingredients not null,
	primary key (recepy_id, ingredient_id)
);

insert into recepies (name, description, category) values
(
	'recep1',
	'description1',
	'category1'
),
(
	'recep2',
	'description2',
	'category2'
),
(
	'recep3',
	'description3',
	'category3'
);

insert into ingredients (name, category, price) values
(
	'ingredient1',
	'category1',
	99
),
(
	'ingredient2',
	'category2',
	87
),
(
	'ingredient3',
	'category3',
	43
);


insert into recepy_to_ingredient (recepy_id, ingredient_id) values
(
	(select id from recepies where name='recep1'),
	(select id from ingredients where name='ingredient1')
),
(
	(select id from recepies where name='recep1'),
	(select id from ingredients where name='ingredient2')
),
(
	(select id from recepies where name='recep2'),
	(select id from ingredients where name='ingredient2')
);

select
	r.id,
	r.name,
	r.description,
	r.category,
	coalesce(json_agg(json_build_object(
	    'id', i.id, 'name', i.name, 
	    'category', i.category, 'price', i.price))
	    filter (where i.id is not null), '[]') as ingredients
	from recepies r
	left join recepy_to_ingredient ri on r.id = ri.recepy_id
	left join ingredients i on i.id = ri.ingredient_id
	group by r.id;

select
	i.id,
	i.name,
	i.category,
	i.price,
	coalesce(json_agg(json_build_object(
	    'id', r.id, 'name', r.name, 
	    'description', r.description, 'category', r.category))
	    filter (where r.id is not null), '[]') as recepies
	from ingredients i
	left join recepy_to_ingredient ri on i.id = ri.ingredient_id
	left join recepies r on r.id = ri.recepy_id
	group by i.id;

/* ======== 3 ======== */

drop table if exists users, videos, user_to_video;

create table users
(
	id uuid primary key default uuid_generate_v4(),
	nickname text,
	registration_date date
);

create table videos
(
	id uuid primary key default uuid_generate_v4(),
	name text,
	publication_date date,
	duration int
);

create table user_to_video
(
	user_id uuid references users not null,
	video_id uuid references videos not null,
	primary key (user_id, video_id)
);

insert into users (nickname, registration_date) values
(
	'user1',
	'2024.01.05'
),
(
	'user2',
	'2023.12.29'
),
(
	'user3',
	'2024.02.19'
);

insert into videos (name, publication_date, duration) values
(
	'video1',
	'2022.08.27',
	99
),
(
	'video2',
	'2006.03.05',
	87
),
(
	'video3',
	'2024.02.28',
	43
);


insert into user_to_video (user_id, video_id) values
(
	(select id from users where nickname='user1'),
	(select id from videos where name='video1')
),
(
	(select id from users where nickname='user1'),
	(select id from videos where name='video2')
),
(
	(select id from users where nickname='user2'),
	(select id from videos where name='video2')
);

select
	u.id,
	u.nickname,
	u.registration_date,
	coalesce(json_agg(json_build_object(
	    'id', v.id, 'name', v.name, 
	    'publication_date', v.publication_date, 'duration', v.duration))
	    filter (where v.id is not null), '[]') as videos
	from users u
	left join user_to_video uv on u.id = uv.user_id
	left join videos v on v.id = uv.video_id
	group by u.id;

select
	v.id,
	v.name,
	v.publication_date,
	v.duration,
	coalesce(json_agg(json_build_object(
	    'id', u.id, 'nickname', u.nickname, 
	    'registration_date', u.registration_date))
	    filter (where u.id is not null), '[]') as users
	from videos v
	left join user_to_video uv on v.id = uv.video_id
	left join users u on u.id = uv.user_id
	group by v.id;
