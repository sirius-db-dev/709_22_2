drop table if exists patient, visit cascade;

create table patient
(
	id int primary key generated always as identity,
	first_name text,
	last_name text,
	birth_date date,
	gender text
);

create table visit
(
	id int primary key generated always as identity,
	patient_id int references patient(id),
	visit_date date,
	diagnosis text
);


insert into patient(first_name, last_name, birth_date, gender) values
	('Крдян','Арег','2006.06.29', 'M'),
	('Егор','Роганов','2006.07.20', 'M');

insert into visit(patient_id, visit_date, diagnosis) values
	(1,'2024.02.5', 'здоров'),
	(2,'2024.02.5', 'здоров');

select p.id, p.first_name, p.last_name, p.birth_date, p.gender,
	coalesce(jsonb_agg(json_build_object('id', v.id, 'visist_date', v.visit_date, 'diagnosis',v.diagnosis))
	filter(where v.patient_id is not null), '[]')
	from patient p
	left join visit v on p.id = v.patient_id
	group by p.id;
	