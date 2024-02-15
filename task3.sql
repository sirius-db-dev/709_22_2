drop table if exists repository, ticket;


create table repository(
	id int primary key generated always as identity,
	name text,
	description text,
	num_stars int check (num_stars <= 5 and num_stars >= 0)
);

create table ticket(
	id int primary key generated always as identity,
	name text,
	description text,
	status text,
	repository_id int references repository not null
);


insert into repository(name, description, num_stars)
values
	('Штуки для космоса', 'разработка ПО для космических кораблей', 3),
	('Прикольные программы', 'сделать программы для помощи в разных профессиях', 2),
	('Распознавание заболевания легких', 'написать ИИ для распознавания заболеваемости легких', 5);


insert into ticket(name, description, status, repository_id)
values
	('Сделать базовую концепцию ракеты',
	'Придумать корпус, двигатель и прочие полезные штуки для ракеты', 'В процессе', 1),
	('Спонсорство', 'продвинуть идею распознавания легких с помощью ИИ для получения денег', 'Готово', 3),
	('Обучить модель', 'Обучить модель на датасете с использованием разных параметров', 'В процессе', 3),
	('Сделать датасет', 'Найти большое кол-во данных с больными легкими', 'Готово', 3);


select 
	repository.id,
	repository.name,
	repository.description,
	repository.num_stars,
	coalesce(json_agg(json_build_object(
		'id', ticket.id, 'name', ticket.name, 'description', ticket.description, 'status',
		ticket.status, 'repository_id', ticket.repository_id))
		filter (where ticket.id is not null), '[]')
		as ticket
from repository 
left join ticket on repository.id = ticket.repository_id
group by repository.id;
