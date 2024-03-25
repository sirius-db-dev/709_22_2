drop table if exists books, reviews cascade;

create table books
(
	id int primary key,
	title text,
	genre text,
	publication_year date
);

create table reviews
(
	id int primary key,
	book_id int references books not null,
	review text,
	grade int
);

insert into books (id, title, genre, publication_year)
values (1, 'Гарри Поттер', 'фэнтези', '2001-03-09'),
		(2, 'Горе от ума', 'комедия', '1978-05-20'),
		(3, 'Война и мир', 'повесть', '1934-08-13'),
		(4, 'Колобок', 'сказка', '1950-11-25');

insert into reviews (id, book_id, review, grade)
values (1, 1, 'очень инетресно', 8),
		(2, 1, 'круто', 9),
		(3, 2, 'забавно', 7),
		(4, 2, 'ничего не понял', 6),
		(5, 3, 'слишком много текста', 5),
		(6, 3, 'интересно', 8);

select * from books 
left join reviews on books.id = reviews.book_id;

select
	b.id,
	b.title,
	b.genre,
	b.publication_year,
	coalesce(jsonb_agg(jsonb_build_object(
	'id', r.id, 'book_id', r.book_id, 'review', r.review, 'grade', r.grade))
	filter (where r.id is not null), '[]') as reviews
from books b
left join reviews r on b.id = r.book_id
group by b.id;





drop table if exists products, pr_reviews cascade;

create table products
(
	id int primary key,
	title text,
	description text,
	grade int
);

create table pr_reviews
(
	id int primary key,
	prod_id int references products not null,
	review text,
	grade int
);

insert into products (id, title, description, grade)
values (1, 'Помидор', 'овощ', 5),
		(2, 'Картошка', 'овощ', 6),
		(3, 'Яблоко', 'фрукт', 5),
		(4, 'Виноград', 'фрукт', 10);

insert into pr_reviews (id, prod_id, review, grade)
values (1, 1, 'кисло', 3),
		(2, 1, 'ммм', 9),
		(3, 2, 'долго готовить', 4),
		(4, 2, 'ничего не понял', 3),
		(5, 3, 'очень нравится', 8),
		(6, 3, 'кислое попалось', 4);

select * from products pr
left join pr_reviews r on pr.id = r.prod_id;

select
	pr.id,
	pr.title,
	pr.description,
	pr.grade,
	coalesce(jsonb_agg(jsonb_build_object(
	'id', r.id, 'prod_id', r.prod_id, 'review', r.review, 'grade', r.grade))
	filter (where r.id is not null), '[]') as pr_reviews
from products pr
left join pr_reviews r on pr.id = r.prod_id
group by pr.id;





drop table if exists tasks, t_comments cascade;

create table tasks
(
	id int primary key,
	title text,
	description text,
	level int
);

create table t_comments
(
	id int primary key,
	task_id int references tasks not null,
	review text,
	publication_date date
);

insert into tasks (id, title, description, level)
values (1, 'Интергралы', 'удачи', 10),
		(2, 'Производные', 'сложно', 8),
		(3, 'Логарифмы', 'легко', 5),
		(4, 'Арифметика', 'запомни', 1);

insert into t_comments (id, task_id, review, publication_date)
values (1, 1, 'ничего не понятно', '2020-12-09'),
		(2, 1, 'получилось', '2019-04-03'),
		(3, 2, 'ну в целом', '2021-11-12'),
		(4, 2, 'ничего не понял', '2014-09-25'),
		(5, 3, 'лекго', '2018-10-29'),
		(6, 3, 'вроде понятно', '2010-06-06');

select * from tasks t
left join t_comments c on t.id = c.task_id;

select
	t.id,
	t.title,
	t.description,
	t.level,
	coalesce(jsonb_agg(jsonb_build_object(
	'id', c.id, 'task_id', c.task_id, 'review', c.review, 'publication_date', c.publication_date))
	filter (where c.id is not null), '[]') as t_comments
from tasks t
left join t_comments c on t.id = c.task_id
group by t.id;




	