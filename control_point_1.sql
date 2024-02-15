drop table if exists kurers, orders cascade;

create table  kurers(
id int primary key,
first_name text,
last_name text,
phone_number text);

create table orders(
id int primary key,
kurer_id int references kurers,
adres text,
orders_date date,
status text);

insert  into  kurers(id, first_name, last_name, phone_number) values 
		(1, 'Виктор', 'Петров', '89008004578'),
		(2, 'Виолетта', 'Малинина', '+79627542034'),
		(3, 'Артем', 'Никитин', '+78452562590');
	

insert into orders(id, kurer_id, adres, orders_date, status) values 
		(1, 1, 'ул. Комсомольцев, д. 45', '2023-07-09', 'Доставлен'),
		(2, 3, 'ул. 50 лет ВЛКСМ, д. 26', '2024-02-13', 'Ожидает отправки'),
		(3, 1, 'ул. Ленина, д. 33', '2024-01-10', 'Доставлен'),
		(4, 1, 'ул. Покровская, д. 12', '2023-12-20', 'Утерян'),
		(5, 3, 'проспект Революции, д. 145/1', '2024-02-01', 'Доставлен');
		
	
select
	kurers.id,
	kurers.first_name, 
	kurers.last_name,
	kurers.phone_number,
	coalesce(json_agg(json_build_object(
		'id', orders.id, 'adres', orders.adres, 'orders_date', orders.orders_date, 'status', orders.status))
		filter (where orders.id is not null), '[]')
			as orders

from kurers
left join  orders on kurers.id = orders.kurer_id
group by kurers.id	











drop table if exists feedbacks, games cascade;

create table games(
id int primary key,
title text,
sum int,
genre text);


create table  feedbacks(
id int primary key,
games_id int references games,
text text,
mark int);

insert into games(id, title, sum, genre) values 
		(1, 'Папины дочки', 2300, 'Симулятор'),
		(2, 'Тачки 7', 1234, 'Гонки'),
		(3, 'Моя кофейня', 1999, 'Аркады');
		
insert  into  feedbacks(id, games_id, text, mark) values 
		(1, 2, 'Очень понравилась игра, рекомендую!', 5),
		(2, 3, 'Игра увлекательная, затягивает, ставлю ей класс!', 5),
		(3, 3, 'Игра не понравилась, не поняла ее идею вообще, больше не куплю!', 2);
	


select
	games.id,
	games.title, 
	games.sum,
	games.genre,
	coalesce(json_agg(json_build_object(
		'id', feedbacks.id, 'text', feedbacks.text, 'mark', feedbacks.mark))
		filter (where feedbacks.id is not null), '[]')
			as feedbacks

from games
left join  feedbacks on games.id = feedbacks.games_id
group by games.id	







drop table if exists articles, comments_reaction cascade;

create table articles(
id int primary key,
title text,
text text,
date_publucation date);


create table  comments_reaction(
id int primary key,
articles_id int references articles,
text text,
likes int);

insert into articles(id, title, text, date_publucation) values 
		(1, 'В какую профессию идти, если хочешь в IT?', 'Какой-то очень длинный и интересный текс)', '2023-10-17'),
		(2, 'Готовим дома: топ блюд домохозяек', 'Тоже очень интерсный, менее длинный текс', '2024-01-23'),
		(3, 'Шопен: интересные факты из жизни композитора', 'Также увлекательный текст, писать его долго', '2022-06-22');
		
insert  into  comments_reaction(id, articles_id, text, likes) values 
		(1, 1, 'Зачем туда вообще идти? Кому оно нужно?', 56),
		(2, 1, 'Статья очень понравилась! Осталась в восторге! Вл всем разобралась!', 567),
		(3, 3, 'Какая интересная и необычная статья! Жду новую!', 120);
	


select
	articles.id,
	articles.title, 
	articles.text,
	articles.date_publucation,
	coalesce(json_agg(json_build_object(
		'id', comments_reaction.id, 'text', comments_reaction.text, 'likes', comments_reaction.likes))
		filter (where comments_reaction.id is not null), '[]')
			as comments_reaction

from articles
left join  comments_reaction on articles.id = comments_reaction.articles_id
group  by articles.id	

















	