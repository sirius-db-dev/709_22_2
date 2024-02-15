drop table repositories, tickets 
create table repositories
(
	id			int primary key,
	title		text,
	descr		text,
	stars		int
);

insert into repositories(id, title, descr, stars)
	values (1, 'a1', 'trash', 5),
	       (2, 'a2', 'wonderful', 10),
	       (3, 'a3', 'amaziing', 16),
	       (4, 'a4', ':((', 2);

create table tickets
(
	id			int primary key,
	repo_id		int references repositories,
	title		text,
	desctiption	text,
	status		text
);

insert into tickets (id, repo_id, title, desctiption, status)
values 
	(1, 1, 'b1', 'gg', 'im happy'),
	(2, 3, 'b2', 'wp', 'asd'),
	(3, 1, 'b3', 'gl', 'asod'),
	(4, 1, 'b4', 'hf', 'asldj'),
	(5, 1, 'b5', 'bb', '9sad');

select 
	rp.id,
	rp.title,
	rp.descr,
	rp.stars,
	coalesce(jsonb_agg(jsonb_build_object(
	'id', tt.id, 'repo_id', tt.repo_id, 'title', tt.title, 'desctiption', tt.desctiption, 'status', tt.status))
	filter (where tt.id is not null), '[]')
	as tickets
from repositories rp
	left join tickets tt on rp.id = tt.repo_id
group by rp.id;

