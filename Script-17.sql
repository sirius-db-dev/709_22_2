create extension if not exists "uuid-ossp";

drop table if exists teachers, schools, teachers_to_schools, cascade;

create table teachers
(
	id uuid primary key default uuid_generate_v4(),
	first_name text,
	last_name text,
	birthdate date,
	science_degree text,
	expereince int
);

create table schools
(
	id uuid primary key default uuid_generate_v4(),
	school_name text,
	address text
);

create table teachers_to_schools
(
	teacher_id uuid references teachers,
	school_id uuid references schools,
	primary key (teacher_id, school_id)
);

insert  into teachers (first_name, last_name, birthdate, science_degree, expereince)
values	('Walter', 'White', '1969.02.02', 'Nobel prize award', 20),
		('Jesse', 'Pinkman', '2007.01.01', 'High school', 2),
		('Albert', 'Tenigin', '1980.01.03', 'University of programming', 15),
		('Ivan', 'Golodnyuk', '1980.03.01', 'University of databases', 15);
	
insert into schools (school_name, address)
values 	('Sirius Lyceum', 'Voskresensaya street, 15'),
		('Sirius College', 'Park of Science and Art'),
		('Sirius University', 'Park of Science and Art');

insert into teachers_to_schools (teacher_id, school_id)
values 	((select id from teachers where last_name = 'Golodnyuk'),
		(select id from schools where school_name = 'Sirius College')),
		((select id from teachers where last_name = 'Tenigin'),
		(select id from schools where school_name = 'Sirius College')),
		((select id from teachers where last_name = 'White'),
		(select id from schools where school_name = 'Sirius College')),
		((select id from teachers where last_name = 'White'),
		(select id from schools where school_name = 'Sirius Lyceum')),
		((select id from teachers where last_name = 'White'),
		(select id from schools where school_name = 'Sirius University')),
		((select id from teachers where last_name = 'Pinkman'),
		(select id from schools where school_name = 'Sirius Lyceum')),
		((select id from teachers where last_name = 'Golodnyuk'),
		(select id from schools where school_name = 'Sirius University')),
		((select id from teachers where last_name = 'Tenigin'),
		(select id from schools where school_name = 'Sirius Lyceum'));

select 
	t.id,
	t.first_name,
	t.last_name,
	t.science_degree,
	t.expereince,
	coalesce(jsonb_agg(jsonb_build_object(
		'id', s.id, 'school_name', s.school_name, 'address', s.address))
		filter (where s.id is not null), '[]') as schools
from teachers t
left join teachers_to_schools ts on t.id = ts.teacher_id
left join schools s on ts.school_id = s.id
group by t.id;

select 
	s.id,
	s.school_name,
	s.address,
	coalesce(jsonb_agg(jsonb_build_object(
		'id', t.id, 'first_name', t.first_name, 'last_name', t.last_name,
		'science_degree', t.science_degree, 'expereince', t.expereince))
		filter (where t.id is not null), '[]') as schools
from schools s
left join teachers_to_schools ts on s.id = ts.school_id
left join teachers t on ts.teacher_id = t.id
group by s.id;




