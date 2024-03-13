create extension if not exists "uuid-ossp";

drop table if exists musician, music, music_to_musician cascade;

create table musician(
	id uuid primary key default uuid_generate_v4(),
	first_name text,
	last_name text,
	birth_date date
);

create table music(
	id uuid primary key default uuid_generate_v4(),
	name text,
	genre text,
	time text
);

create table music_to_musician(
	music_id uuid references music,
	musician_id uuid references musician,
	primary key (music_id, musician_id)
);


insert into musician(first_name, last_name, birth_date)
values
	('Егор', 'Добрый', '2000-03-10'),
	('Макс', 'Мирный', '1998-02-12'),
	('Володя', 'Зажигалочка', '1994-12-03');

insert into music(name, genre, time)
values
	('Рокки', 'крутая', '00:05:03'),
	('Быстрый', 'новизна', '00:00:01'),
	('Маленький', 'поп', '00:02:34');


insert into music_to_musician(music_id, musician_id)
values
	((select id from music where music.name = 'Рокки'), (select id from musician where musician.first_name = 'Егор')),
	((select id from music where music.name = 'Быстрый'), (select id from musician where musician.first_name = 'Егор')),
	((select id from music where music.name = 'Рокки'), (select id from musician where musician.first_name = 'Володя'));
	
select
	musician.id,
	musician.first_name,
	musician.last_name,
	musician.birth_date,
	coalesce(json_agg(json_build_object(
		'name', music.name, 'genre', music.genre, 'time', music.time))
		filter (where music.id is not null), '[]') as music
from musician 
left join music_to_musician on musician.id = music_to_musician.musician_id
left join music on music.id = music_to_musician.music_id
group by musician.id;


select
	music.id,
	music.name,
	music.genre,
	music.time,
	coalesce(json_agg(json_build_object(
		'firts_name', musician.first_name, 'last_name', musician.last_name, 'birth_date', musician.birth_date))
		filter (where musician.id is not null), '[]') as musician
from music
left join music_to_musician on music.id = music_to_musician.music_id
left join musician on musician.id = music_to_musician.musician_id
group by music.id;
