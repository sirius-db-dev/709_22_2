/*
 * 1
 */

drop table if exists videos, comments;

create table videos
(
	id int primary key generated always as identity,
	name text,
	description text,
	publication_date date
);

create table comments
(
	id int primary key generated always as identity,
	video_id int references videos,
	text text,
	likes int
);

insert into videos (name, description, publication_date) values
(
	'Watch it!',
	'Wonderful!',
	'1874.02.17'
),
(
	'Beatiful kitty',
	'He is so cute',
	'2023.08.26'
),
(
	'ahahaha',
	'...',
	'2024.01.19'
);

insert into comments (video_id, text, likes) values
(
	2,
	'What is it?',
	19
),
(
	3,
	'ahahahahahaha',
	0
),
(
	3,
	'ahfhfhhhahahahahaha',
	5
);

select
	v.id,
	v."name",
	v.description,
	v.publication_date,
	coalesce(
		json_agg(
			json_build_object('id', c.id, 'text', c."text", 'likes', c.likes))
		filter(where c.id is not null), '[]'
	) as comments
from videos v
left join comments c on v.id = c.video_id
group by v.id;


/*
 * 2
 */

drop table if exists companies, cars;

create table companies
(
	id int primary key generated always as identity,
	name text,
	phone_number text
);

create table cars
(
	id int primary key generated always as identity,
	company_id int references companies,
	mark text,
	model text,
	max_weight int
);

insert into companies (name, phone_number) values
(
	'Metall',
	'+70000000000'
),
(
	'Plastic',
	'+71111111111'
),
(
	'Snow',
	'+70909090909'
);

insert into cars (company_id, mark, model, max_weight) values
(
	1,
	'Metal track',
	'G6',
	1500
),
(
	3,
	'Horse',
	'Brown',
	50
),
(
	3,
	'Owl',
	'White',
	1
);

select
	co.id,
	co.name,
	co.phone_number,
	coalesce(
		json_agg(
			json_build_object('id', c.id, 'mark', c.mark, 'model', c.model, 'max_weight', c.max_weight))
		filter(where c.id is not null), '[]'
	) as cars
from companies co
left join cars c on co.id = c.company_id
group by co.id;

/*
 * 3
 */

drop table if exists games, comments;

create table games
(
	id int primary key generated always as identity,
	name text,
	genre text,
	price int
);

create table comments
(
	id int primary key generated always as identity,
	game_id int references games,
	text text,
	mark int
);

insert into games (name, genre, price) values
(
	'Counter-Strike',
	'Shooter',
	1100
),
(
	'Minecraft',
	'Sand',
	1900
),
(
	'Outlast',
	'Horror',
	500
);

insert into comments (game_id, text, mark) values
(
	1,
	'Nice pau pau!',
	5
),
(
	3,
	'Bad graphics!',
	3
),
(
	3,
	'AAAAuuuu!',
	5
);

select
	g.id,
	g.name,
	g.genre,
	g.price,
	coalesce(
		json_agg(
			json_build_object('id', c.id, 'text', c.text, 'mark', c.mark))
		filter(where c.id is not null), '[]'
	) as comments
from games g
left join comments c on g.id = c.game_id
group by g.id;
