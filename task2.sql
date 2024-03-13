create extension if not exists "uuid-ossp";



drop table if exists recipes, ingredients, rec_to_ing cascade;

create table recipes
( 
	id uuid primary key default uuid_generate_v4(),
	title text,
	category text,
	price int
);

create table ingridients
(
	id uuid primary key default uuid_generate_v4(),
	ing_name text,
	description text,
	category text
);

create table rec_to_ing
(
	recipe_id uuid references recipes,
	ingrid_id uuid references ingridients,
	primary key (recipe_id, ingrid_id)
);



insert into recipes (title, category, price)
values ('борщ', 'первое', 70),
		('плов', 'второе', 120),
		('цезарь', 'салат', 50),
		('пюре', 'гарнир', 40);
	
insert into ingridients (ing_name, description, category)
values ('картофель', 'свежий', 'овощи'),
		('рис', 'белый', 'крупы'),
		('индейка', 'филе', 'мясо'),
		('капуста', 'пекинская', 'овощи');

insert into rec_to_ing (recipe_id, ingrid_id)
values ((select id from recipes where title = 'борщ'), (select id from ingridients where ing_name = 'картофель')),
		((select id from recipes where title = 'борщ'), (select id from ingridients where ing_name = 'индейка')),
		((select id from recipes where title = 'борщ'), (select id from ingridients where ing_name = 'капуста')),
		((select id from recipes where title = 'пюре'), (select id from ingridients where ing_name = 'картофель')),
		((select id from recipes where title = 'цезарь'), (select id from ingridients where ing_name = 'индейка')),
		((select id from recipes where title = 'цезарь'), (select id from ingridients where ing_name = 'капуста')),
		((select id from recipes where title = 'плов'), (select id from ingridients where ing_name = 'рис'));

select
	r.id,
	r.title,
	r.category,
	r.price,
	coalesce(jsonb_agg(jsonb_build_object(
	'id', i.id, 'ing_name', i.ing_name, 'decription', i.description, 'category', i.category))
	filter (where i.id is not null), '[]') as ingidients
from recipes r
left join rec_to_ing ri on r.id = ri.recipe_id
left join ingridients i on ri.ingrid_id = i.id
group by r.id;


select
	i.id,
	i.ing_name,
	i.description,
	i.category,
	coalesce(jsonb_agg(jsonb_build_object(
	'id', r.id, 'title', r.title, 'category', r.category, 'price', r.price))
	filter (where r.id is not null), '[]') as recipes
from ingridients i
left join rec_to_ing ri on i.id = ri.ingrid_id
left join recipes r on ri.recipe_id = r.id
group by i.id;







drop table if exists videos, users, video_to_user cascade;

create table videos
( 
	id uuid primary key default uuid_generate_v4(),
	title text,
	publication_date date,
	duration int
);

create table users
(
	id uuid primary key default uuid_generate_v4(),
	nickname text,
	registration_date date
);

create table video_to_user
(
	video_id uuid references videos,
	user_id uuid references users,
	primary key (video_id, user_id)
);


insert into videos (title, publication_date, duration)
values ('лекция 12', '2017-11-29', 120),
		('ММО 20 серия', '2014-10-09', 24),
		('Гарри Поттер 2', '2010-01-15', 150),
		('музыкальный микс', '2020-07-12', 70);

insert into users (nickname, registration_date)
values ('A4', '2009-12-08'),
		('DDD', '2016-05-24'),
		('Vika2838', '2011-03-05'),
		('DJIC666', '2014-07-11');
	
insert into video_to_user(video_id, user_id)
values ((select id from videos where duration = 120), (select id from users where nickname = 'A4')),
		((select id from videos where duration = 120), (select id from users where nickname = 'DDD')),
		((select id from videos where duration = 120), (select id from users where nickname = 'Vika2838')),
		((select id from videos where duration = 150), (select id from users where nickname = 'A4')),
		((select id from videos where duration = 150), (select id from users where nickname = 'DJIC666')),
		((select id from videos where duration = 70), (select id from users where nickname = 'Vika2838')),
		((select id from videos where duration = 24), (select id from users where nickname = 'DJIC666'));


select
	v.id,
	v.title,
	v.publication_date,
	v.duration,
	coalesce(jsonb_agg(jsonb_build_object(
	'id', u.id, 'nickname', u.nickname, 'registration_date', u.registration_date))
	filter (where u.id is not null), '[]') as users
from videos v
left join video_to_user vu on v.id = vu.video_id
left join users u on vu.user_id = u.id
group by v.id;

select
	u.id,
	u.nickname,
	u.registration_date,
	coalesce(jsonb_agg(jsonb_build_object(
	'id', v.id, 'title', v.title, 'publication_date', v.publication_date))
	filter (where v.id is not null), '[]') as videos
from users u
left join video_to_user vu on u.id = vu.user_id
left join videos v on vu.video_id = v.id
group by u.id;









drop table if exists teachers, schools, teacher_to_school cascade;

create table teachers
( 
	id uuid primary key default uuid_generate_v4(),
	first_name text,
	last_name text,
	birth_date date,
	t_degree int,
	experience int
);

create table schools
(
	id uuid primary key default uuid_generate_v4(),
	title text,
	address text
);

create table teacher_to_school
(
	teacher_id uuid references teachers,
	school_id uuid references schools,
	primary key (teacher_id, school_id)
);

insert into teachers(first_name, last_name, birth_date, t_degree, experience)
values ('Нина', 'Романова', '1989-03-09', 2, 6),
		('Дмитрий', 'Иванов', '1973-11-27', 3, 10),
		('Александра', 'Шамакова', '1977-06-15', 5, 7),
		('Андрей', 'Канаров', '1968-05-03', 4, 12);

insert into schools(title, address)
values ('МБОУ СОШ 3', 'Армейская 45'),
		('Гимназия 16', 'Пушкина 3'),
		('МБОУ СОШ 4', 'Ломоносова 28');

insert into teacher_to_school (teacher_id, school_id)
values ((select id from teachers where first_name = 'Нина'), (select id from schools where title = 'Гимназия 16')),
		((select id from teachers where first_name = 'Дмитрий'), (select id from schools where title = 'МБОУ СОШ 4')),
		((select id from teachers where first_name = 'Андрей'), (select id from schools where title = 'МБОУ СОШ 4')),
		((select id from teachers where first_name = 'Александра'), (select id from schools where title = 'МБОУ СОШ 3'));


 select
	t.id,
	t.first_name,
	t.last_name,
	t.birth_date,
	t.t_degree,
	t.experience,
	coalesce(jsonb_agg(jsonb_build_object(
	'id', s.id, 'title', s.title, 'address', s.address))
	filter (where s.id is not null), '[]') as schools
from teachers t
left join teacher_to_school ts on t.id = ts.teacher_id
left join schools s on ts.school_id = s.id
group by t.id;
 

 select
	s.id,
	s.title,
	s.address,
	coalesce(jsonb_agg(jsonb_build_object(
	'id', t.id, 'first_name', t.first_name, 'last_name', t.last_name,
	'birth_date', t.birth_date, 't_degree', t.t_degree, 'experience', t.experience))
	filter (where t.id is not null), '[]') as teachers
from schools s
left join teacher_to_school ts on s.id = ts.school_id
left join teachers t on ts.teacher_id = t.id
group by s.id;
	
