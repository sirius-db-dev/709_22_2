drop table if exists patient, history;


create table patient(
	id int primary key generated always as identity,
	first_name text,
	last_name text,
	birth_date date,
	gender text
);

create table history(
	id int primary key generated always as identity,
	date date,
	diagnosis text,
	patient_id int references patient not null
);


insert into patient(first_name, last_name, birth_date, gender)
values
	('Егор', 'Вавинов', '1973.01.02', 'М'),
	('Ника', 'Папитонова', '1999.03.05', 'Ж'),
	('Никита', 'Пришвинов', '2006.06.23', 'М');


insert into history(date, diagnosis, patient_id)
values
	('2000.03.05', 'ОРВИ', 2),
	('2020.05.20', 'COVID-19', 2),
	('1980.06.13', 'Восполение хитрости', 1);


select 
	patient.id,
	patient.first_name,
	patient.last_name,
	patient.birth_date,
	patient.gender,
	coalesce(json_agg(json_build_object(
		'id', history.id, 'date', history.date,
		'diagnosis', history.diagnosis, 'patient_id', history.patient_id))
		filter (where history.id is not null), '[]')
		as history
from patient 
left join history on patient.id = history.patient_id
group by patient.id;
