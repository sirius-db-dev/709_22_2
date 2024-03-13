CREATE extension IF NOT EXISTS 'uuid-ossp';

DROP TABLE IF EXISTS doctors, patients, doctors_to_patients CASCADE;

CREATE TABLE doctors(
	id				uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
	first_name		text,
	last_name		text,
	specialization	text
);

create table patients(
	id				uuid primary key default uuid_generate_v4(),
	first_name		text,
	last_name		text,
	birthday		date
);

create table doctors_to_patients(
	doctor_id uuid references doctors,
	patient_id uuid references patients,
	primary key (doctor_id, patient_id)
);


insert into doctors(first_name, last_name, specialization)
values ('Ai', 'Bolit', 'surgeon'),
       ('Egor', 'Litvin', 'trauma'),
       ('Areg', 'Krdyan', 'lor'),
       ('Slava', 'Dymyan', 'terapevt');


insert into patients(first_name, last_name, birthday)
values ('Elona', 'Moskow', '2023-05-03'),
       ('Dominic', 'Toronto', '2023-04-05'),
       ('Maks', 'Moskva', '2023-03-07'),
       ('Slavik', 'Kras', '2023-04-08'),
       ('Jim', 'Carry', '2023-01-09');

insert into doctors_to_patients(doctor_id, patient_id)
values ((select id from doctors where first_name = 'Egor'), (select id from patients where first_name = 'Elona'));

insert into doctors_to_patients(doctor_id, patient_id)
values ((select id from doctors where first_name = 'Slava'), (select id from patients where first_name = 'Dominic'));

insert into doctors_to_patients(doctor_id, patient_id)
values ((select id from doctors where first_name = 'Ai'), (select id from patients where first_name = 'Slavik'));

insert into doctors_to_patients(doctor_id, patient_id)
values ((select id from doctors where first_name = 'Areg'), (select id from patients where first_name = 'Slavik'));

insert into doctors_to_patients(doctor_id, patient_id)
values ((select id from doctors where first_name = 'Slava'), (select id from patients where first_name = 'Maks'));



select
  a.id,
  a.first_name,
  a.last_name,
  a.specialization,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'first_name', f.first_name, 'last_name', f.last_name, 'birthday', f.birthday))
      filter (where f.id is not null), '[]') as patients
from doctors a
left join doctors_to_patients af on a.id = af.doctor_id
left join patients f on f.id = af.patient_id
group by a.id;

select
  a.id,
  a.first_name,
  a.last_name,
  a.birthday,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'first_name', f.first_name, 'last_name', f.last_name, 'specialization', f.specialization))
      filter (where f.id is not null), '[]') as doctors
from patients a
left join doctors_to_patients af on a.id = af.patient_id
left join doctors f on f.id = af.doctor_id
group by a.id;