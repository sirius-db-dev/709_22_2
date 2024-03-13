CREATE extension IF NOT EXISTS 'uuid-ossp';

DROP TABLE IF EXISTS agregators, taxs, agregators_to_taxs CASCADE;

CREATE TABLE agregators(
	id			uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
	title		text,
	phone		text
);

create table taxs(
	id			uuid primary key default uuid_generate_v4(),
	first_name	text,
	last_name	text,
	phone		text,
	car			text
)

create table agregators_to_taxs(
	agregator_id uuid references agregators,
	tax_id uuid references taxs,
	primary key (agregator_id, tax_id)
)


insert into agregators(title, phone)
values ('Yandex', '12312312'),
       ('Uber', '3453455'),
       ('Vezet', '54335434'),
       ('Sitimobil', '12365445');

insert into taxs(first_name, last_name, phone, car)
values ('Elona', 'Moskow', '123123123', 'Tesla'),
       ('Dominic', 'Torreto', '34534534', 'Dodge'),
       ('Egor', 'Litvinov', '1231345347', 'Lamba'),
       ('Slavik', 'Demyanenko', '99999999', 'Kvadrokopter'),
       ('Ul', 'Roganov', '234234325', 'Tank');

insert into agregators_to_taxs(agregator_id, tax_id)
values ((select id from agregators where title = 'Yandex'), (select id from taxs where first_name = 'Elona'));

insert into agregators_to_taxs(agregator_id, tax_id)
values ((select id from agregators where title = 'Uber'), (select id from taxs where first_name = 'Dominic'));

insert into agregators_to_taxs(agregator_id, tax_id)
values ((select id from agregators where title = 'Uber'), (select id from taxs where first_name = 'Elona'));

insert into agregators_to_taxs(agregator_id, tax_id)
values ((select id from agregators where title = 'Yandex'), (select id from taxs where first_name = 'Dominic'));

insert into agregators_to_taxs(agregator_id, tax_id)
values ((select id from agregators where title = 'Vezet'), (select id from taxs where first_name = 'Ul'));

insert into agregators_to_taxs(agregator_id, tax_id)
values ((select id from agregators where title = 'Uber'), (select id from taxs where first_name = 'Egor'));


select
  a.id,
  a.title,
  a.phone,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'first_name', f.first_name, 'last_name', f.last_name, 'phone', f.phone, 'car', f.car))
      filter (where f.id is not null), '[]') as taxs
from agregators a
left join agregators_to_taxs af on a.id = af.agregator_id
left join taxs f on f.id = af.tax_id
group by a.id;

select
  a.id,
  a.first_name,
  a.last_name,
  a.phone,
  a.car,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'title', f.title, 'phone', f.phone))
      filter (where f.id is not null), '[]') as agregators
from taxs a
left join agregators_to_taxs af on a.id = af.tax_id
left join agregators f on f.id = af.agregator_id
group by a.id;
