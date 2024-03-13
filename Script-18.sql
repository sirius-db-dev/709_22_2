create extension if not exists "uuid-ossp";

drop table if exists teams, projects, teams_to_projects, cascade;

create table teams
(
	id uuid primary key default uuid_generate_v4(),
	team_name text,
	created date
);

create table projects
(
	id uuid primary key default uuid_generate_v4(),
	project_name text,
	project_start date,
	project_status text
);

create table teams_to_projects
(
	team_id uuid references teams,
	project_id uuid references projects,
	primary key (team_id, project_id)
);

insert into teams (team_name, created)
values	('K0709-22-2', '2022.09.01'),
		('Natus Vincere', '2008.01.01'),
		('Vadim Nikiforovs team', '2006.05.04'),
		('Areg Krdyans team', '2006.06.29');
	
insert into projects (project_name, project_start, project_status)
values	('RPM django project', '2024.03.01', 'About to start'),
		('OCRV', '2022.01.01', 'Ongoing'),
		('Hakaton', '2023.05.05', 'Ended');
	
insert into teams_to_projects (team_id, project_id)
values 	((select id from teams where team_name = 'Vadim Nikiforovs team'),
		(select id from projects where project_name = 'OCRV')),
		((select id from teams where team_name = 'Areg Krdyans team'),
		(select id from projects where project_name = 'OCRV')),
		((select id from teams where team_name = 'K0709-22-2'),
		(select id from projects where project_name = 'RPM django project')),
		((select id from teams where team_name = 'Vadim Nikiforovs team'),
		(select id from projects where project_name = 'RPM django project')),
		((select id from teams where team_name = 'Areg Krdyans team'),
		(select id from projects where project_name = 'RPM django project')),
		((select id from teams where team_name = 'Natus Vincere'),
		(select id from projects where project_name = 'Hakaton')),
		((select id from teams where team_name = 'K0709-22-2'),
		(select id from projects where project_name = 'Hakaton'));
		
select 
	t.id,
	t.team_name,
	t.created,
	coalesce(jsonb_agg(jsonb_build_object(
		'project_name', p.project_name, 'project_start', p.project_start, 'project_status', p.project_status))
		filter (where p.id is not null), '[]') as projects
from teams t
left join teams_to_projects tp on t.id = tp.team_id
left join projects p on tp.project_id = p.id
group by t.id;

select 
	p.id,
	p.project_name,
	p.project_start,
	p.project_status,
	coalesce(jsonb_agg(jsonb_build_object(
		'team_name', t.team_name, 'created', t.created))
		filter (where t.id is not null), '[]') as teams
from projects p
left join teams_to_projects tp on p.id = tp.project_id
left join teams t on tp.team_id = t.id
group by p.id;
		
