drop table games, reviews 

create table games
(
	id		int primary key,
	genre	text,
	price	int
);

insert into games (id, genre, price)
	values (1, 'Shooter', 2000),
	       (2, 'RPG', 1000),
	       (3, 'Minecraft', 4000),
	       (4, 'MOBA', 500);

create table reviews
(
	id			int primary key,
	game_id		int references games,
	feedback	text,
	rate		int
);

insert into reviews (id, game_id, feedback, rate)
values 
	(1, 1, 'hahahahha', 1),
	(2, 1, 'omg', 4),
	(3, 1, '1234', 8),
	(4, 1, 'iouoi', 2),
	(5, 1, 'mmmmmm', 9);

select 
	gm.id,
	gm.genre,
	gm.price,
	coalesce(jsonb_agg(jsonb_build_object(
	'id', rv.id, 'game_id', rv.game_id, 'feedback', rv.feedback, 'rate', rv.rate))
	filter(where rv.id is not null), '[]')
	as reviews
from games gm
	left join reviews rv on gm.id = rv.game_id
group by gm.id

