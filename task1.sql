drop table if exists game, comments;


create table games(
	id int primary key generated always as identity,
	name text,
	genre text,
	price int
);

create table comments(
	id int primary key generated always as identity,
	text text,
	rating decimal,
	game_id int references games not null
);


insert into games (name, genre, price)
values
	('Mafia ||', 'шутер', 300),
	('Алибоба', 'приключение', 5000),
	('Python', 'увлекательная', 250);

insert into comments (text, rating, game_id)
values
	('Крутая игра, всем рекомендую', 5.3, 1),
	('Прикольно, но долго играть', 8.2, 1),
	('Скучно', 3.2, 3);


select 
	games.id,
	games.name,
	games.genre,
	games.price,
	coalesce(json_agg(json_build_object(
		'id', comments.id, 'text', comments.text, 'rating', comments.rating, 'game_id', comments.game_id))
		filter (where comments.id is not null), '[]')
		as comments
from games
left join comments on games.id = comments.game_id
group by games.id;
