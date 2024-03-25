create extension if not exists "uuid-ossp";

drop table if exists teachers, education, teachers_to_education cascade;

create table teachers (
id uuid primary key default uuid_generate_v4(),
first_name text,
last_name text, 
birth_date date, 
academic_degree text, 
experience text);

create table education (
id uuid primary key default uuid_generate_v4(),
title text,
adress text);

create table teachers_to_education (
teacher_id uuid references teachers,
education_id uuid references education,
primary key (teacher_id, education_id));


insert into teachers (first_name, last_name, birth_date, academic_degree, experience) 
values  ('Петр', 'Загородский', '1977.12.01', 'Профессор', '5 лет'),
		('Александра', 'Морозова', '1995.06.06', 'Преподавватель', '1 год'),
		('Михаил', 'Петров', '1954.03.05', 'Доктор наук', '15 лет');
		
insert into education (title, adress) 
values  ('Моссковский Государственный Университет им. Ломоносова', 'Москва, ул.Кременчугская, д. 11'),
		('Моссковский Архитектурный Институт', 'Москва, ул. Рождественка, 11, стр. 2'),
		('Моссковский Педагогический Государственный Университет', 'Москва, Малая Пироговская ул., 1');
		
 insert into teachers_to_education(teacher_id, education_id) values 
 ((select id from teachers where last_name = 'Загородский'), 
 (select id from education where title = 'Моссковский Государственный Университет им. Ломоносова')),
 ((select id from teachers where last_name = 'Морозова'), 
 (select id from education where title = 'Моссковский Государственный Университет им. Ломоносова')),
 ((select id from teachers where last_name = 'Загородский'),
 (select id from education where title = 'Моссковский Архитектурный Институт')),
 ((select id from teachers where last_name = 'Морозова'), 
(select id from education where title = 'Моссковский Архитектурный Институт'));

    select *
from teachers t
         left join teachers_to_education te on t.id = te.teacher_id
         left join education e on te.education_id = t.id;
        
        
select 
t.id,
t.first_name,
t.last_name, 
t.birth_date, 
t.academic_degree, 
t.experience, 
coalesce(jsonb_agg(jsonb_build_object('id', e.id, 'title', e.title, 'adress', e.adress))
filter(where e.id is not null), '[]') as education
from teachers t
left join teachers_to_education et on et.teacher_id = t.id
left join education  e on et.education_id = e.id
group by t.id

select 
e.id,
e.title,
e.adress,
coalesce(jsonb_agg(jsonb_build_object('id', t.id, 'first name', t.first_name, 'last name', t.last_name, 'birth_date', t.birth_date, 'academic degree', t.academic_degree, 'experience', t.experience))
filter(where t.id is not null), '[]') as teachers
from education e
left join teachers_to_education  et on et.education_id = e.id
left join teachers t on et.teacher_id = t.id
group by e.id






























create extension if not exists "uuid-ossp";

drop table if exists projects, teams,  projects_to_teams cascade;

create table projects (
id uuid primary key default uuid_generate_v4(),
title text, 
date date,  
status text);

create table teams (
id uuid primary key default uuid_generate_v4(),
title text,
date date);

create table projects_to_teams (
project_id uuid references projects,
team_id uuid references teams,
primary key (project_id, team_id));


insert into projects (title, date, status) 
values  ('Проект1', '2021.12.12', 'Проет согласован'),
		('Проект2', '2022.05.05', 'Защищен'),
		('Проект3', '2023.10.10', 'Разработка');
		
insert into teams (title, date) 
values  ('Цветочки', '2020.09.01'),
		('Акулы', '2020.05.07'),
		('Программисты', '2020.01.10');
		
 insert into projects_to_teams(project_id, team_id) values 
 ((select id from projects where title = 'Проект1'), 
 (select id from teams where title = 'Цветочки')),
 ((select id from projects where title = 'Проект1'), 
 (select id from teams where title =  'Акулы')),
 ((select id from projects where title = 'Проект2'),
 (select id from teams where title = 'Цветочки')),
 ((select id from projects where title = 'Проект2'), 
(select id from teams where title = 'Акулы'));

    select *
from projects p
         left join projects_to_teams pt  on p.id = pt.project_id
         left join teams t on pt.team_id = p.id;
        
        
select 
p.id,
p.title,
p.date, 
p.status, 
coalesce(jsonb_agg(jsonb_build_object('id', t.id, 'title', t.title, 'date', t.date))
filter(where t.id is not null), '[]') as teams
from projects p
left join projects_to_teams tp on tp.project_id = p.id
left join teams t on tp.team_id = t.id
group by p.id

select 
t.id,
t.title,
t.date,
coalesce(jsonb_agg(jsonb_build_object('id', p.id, 'title', p.title, 'date', p.date, 'status', p.status))
filter(where p.id is not null), '[]') as projects
from teams t
left join projects_to_teams  tp on tp.team_id = t.id
left join projects p on tp.project_id = p.id
group by t.id






















create extension if not exists "uuid-ossp";

drop table if exists suppliers, shops, suppliers_to_shops cascade;

create table suppliers (
id uuid primary key default uuid_generate_v4(),
title text, 
phone text);

create table shops (
id uuid primary key default uuid_generate_v4(),
title text,
adress text);

create table suppliers_to_shops (
supplier_id uuid references projects,
shop_id uuid references teams,
primary key (supplier_id, shop_id));


insert into suppliers (title, phone) 
values  ('Поставщик1', '89108983425'),
		('Поставщик2', '89159312507'),
		('Поставщик3', '88003553535');
		
insert into shops (title, adress) 
values  ('Цветочки', 'Адрес1'),
		('Акулы', 'Адрес2'),
		('Программисты', 'Адрес3');
		
 insert into suppliers_to_shops(supplier_id, shop_id) values 
 ((select id from suppliers where title = 'Поставщик1'), 
 (select id from shops where title = 'Цветочки')),
 ((select id from suppliers where title = 'Поставщик1'), 
 (select id from shops where title =  'Акулы')),
 ((select id from suppliers where title = 'Поставщик2'),
 (select id from shops where title = 'Цветочки')),
 ((select id from suppliers where title = 'Поставщик2'), 
(select id from shops where title = 'Акулы'));

    select *
from suppliers sup
         left join suppliers_to_shops sups  on sup.id = sups.supplier_id
         left join shops sh  on sups.shop_id = sh.id;
        
        
select 
sup.id,
sup.title,
sup.phone, 
coalesce(jsonb_agg(jsonb_build_object('id', sh.id, 'title', sh.title, 'adress', sh.adress))
filter(where sh.id is not null), '[]') as shops
from  suppliers sup
left join suppliers_to_shops shsup on shsup.supplier_id = sup.id
left join shops sh  shsup.shop_id = sh.id
group by sup.id

select 
sh.id,
sh.title,
sh.adress,
coalesce(jsonb_agg(jsonb_build_object('id', sup.id, 'title', sup.title, 'phone', sup.phone))
filter(where sup.id is not null), '[]') as suppliers
from shops sh
left join suppliers_to_shops shsup on shsup.shop_id = sh.id
left join shops sh  shsup.supplier_id = sup.id
group by sh.id


