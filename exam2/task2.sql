create extension if not exists "uuid-ossp";


drop table if exists events, participants, participants_to_events cascade;

create table events(
	id uuid primary key default uuid_generate_v4(),
	name text,
	date date,
	place text
);

create table participants(
	id uuid primary key default uuid_generate_v4(),
	first_name text,
	last_name text,
	birth_date date
);

create table participants_to_events(
	participants_id uuid references participants,
	events_id uuid references events,
	primary key (participants_id, events_id)
);

insert into events(name, date, place)
values
	('Дада', '1998-02-12', 'Сириус'),
	('Гучи', '2000-12-13', 'Мальдивы'),
	('Прайм', '2020-10-09', 'АлфаБанк');

insert into participants(first_name, last_name, birth_date)
values
	('Егор', 'Крид', '2006-01-23'),
	('Альберт', 'Быстрый', '2000-12-20'),
	('Иван', 'Крутой', '1999-12-12');

insert into participants_to_events(participants_id, events_id)
values
	((select id from participants where participants.first_name = 'Егор'), (select id from events where events.name = 'Гучи')),
	((select id from participants where participants.first_name = 'Альберт'), (select id from events where events.name = 'Прайм')),
	((select id from participants where participants.first_name = 'Иван'), (select id from events where events.name = 'Гучи'));


select
	participants.id,
	participants.first_name,
	participants.last_name,
	participants.birth_date,
	coalesce(json_agg(json_build_object(
		'name', events.name, 'date', events.date, 'place', events.place))
		filter (where events.id is not null), '[]') as events
from participants 
left join participants_to_events on participants.id = participants_to_events.participants_id
left join events on events.id = participants_to_events.events_id
group by participants.id;


select
	events.id,
	events.name,
	events.date,
	events.place,
	coalesce(json_agg(json_build_object(
		'first_name', participants.first_name, 'last_name', participants.last_name, 'birth_date', participants.birth_date))
		filter (where participants.id is not null), '[]') as participants
from events 
left join participants_to_events on events.id = participants_to_events.events_id
left join participants on participants.id = participants_to_events.participants_id
group by events.id;
