CREATE extension IF NOT EXISTS 'uuid-ossp';

DROP TABLE IF EXISTS projects, teams, projects_to_teams CASCADE;

CREATE TABLE projects(
	id				uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
	title			text,
	start_date		date,
	status      	text
);

create table teams(
	id				uuid primary key default uuid_generate_v4(),
	title			text,
	start_date		date
);

create table projects_to_teams(
	project_id uuid references projects,
	team_id uuid references teams,
	primary key (project_id, team_id)
);


insert into projects(title, start_date, status)
values ('proj1', '2023-04-03', 'ok'),
       ('proj2', '2023-02-09', 'rest'),
       ('proj3', '2023-08-03', 'ok'),
       ('proj4', '2023-04-01', 'rest');


insert into teams(title, start_date)
values ('team1', '2023-05-03'),
       ('team2', '2023-04-05'),
       ('team3', '2023-03-07'),
       ('team4', '2023-04-08'),
       ('team5', '2023-01-09');

insert into projects_to_teams(project_id, team_id)
values ((select id from projects where title = 'proj1'), (select id from teams where title = 'team1'));

insert into projects_to_teams(project_id, team_id)
values ((select id from projects where title = 'proj1'), (select id from teams where title = 'team2'));

insert into projects_to_teams(project_id, team_id)
values ((select id from projects where title = 'proj4'), (select id from teams where title = 'team2'));

insert into projects_to_teams(project_id, team_id)
values ((select id from projects where title = 'proj3'), (select id from teams where title = 'team5'));

insert into projects_to_teams(project_id, team_id)
values ((select id from projects where title = 'proj1'), (select id from teams where title = 'team4'));



select
  a.id,
  a.title,
  a.start_date,
  a.status,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'title', f.title, 'start_date', f.start_date))
      filter (where f.id is not null), '[]') as projects
from projects a
left join projects_to_teams af on a.id = af.project_id
left join teams f on f.id = af.team_id
group by a.id;

select
  a.id,
  a.title,
  a.start_date,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'title', f.title, 'start_date', f.start_date, 'status', f.status))
      filter (where f.id is not null), '[]') as teams
from projects a
left join projects_to_teams af on a.id = af.team_id
left join projects f on f.id = af.project_id
group by a.id;