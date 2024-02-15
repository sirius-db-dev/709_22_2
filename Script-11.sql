create extension if not exists "uuid-ossp";

drop table if exists repositories, tickets;

create table repositories
(
	id		uuid primary key default uuid_generate_v4(),
	name	text,
	descr	text,
	stars	int
);

create table tickets
(
	id		uuid primary key default uuid_generate_v4(),
	repo_id	uuid references repositories(id),
	ticket_name	text,
	ticket_descr	text,
	status	text
);

insert into repositories (name, descr, stars)
values
	('709-22-2', 'Kontrolnaya rabota #1', 1337),
	('homeworks_23', 'Domashki po OP and OOP', 1001),
	('simple_task', 'job task', 1);
	
insert into tickets (repo_id, ticket_name, ticket_descr, status)
values
	((select id from repositories where name='simple_task'), 'Bug fix', 'Crashes on click', 'In process'),
	((select id from repositories where name='simple_task'), 'Perfomance issue', 'Optimise an algorith', 'Declined'),
	((select id from repositories where name='homeworks_23'), 'Bug fix', 'A lot of error', 'In process'),
	((select id from repositories where name='homeworks_23'), 'Bug fix', 'Wrong algorithm output', 'Assigned'),
	((select id from repositories where name='709-22-2'), 'Create a DB', 'DB that stores info about repos and tickets', 'In process'),
	((select id from repositories where name='709-22-2'), 'Bug fix', 'Does not work:(', 'Assigned');
	
select 
	r.id,
	name,
	descr,
	stars,
	coalesce(json_agg(jsonb_build_object(
		'id', t.id, 'repo_id', t.repo_id, 'ticket_name', t.ticket_name, 'ticket_descr', t.ticket_descr, 'status', t.status))
		filter (where t.id is not null), '[]') as tickets
from repositories r
left join tickets t on r.id=t.repo_id
group by r.id;
	
	