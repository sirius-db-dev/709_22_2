drop table if exists article, article_comment cascade;

create table article
(
	id int primary key generated always as identity,
	title text,
	article_text text,
	publish_date date
);

create table article_comment
(
	id int primary key generated always as identity,
	article_id int references article(id),
	comment_text text,
	likes int check(likes >= 0)
);

insert into article(title, article_text, publish_date) values
	('git','git - это круто','2020.06.09'),
	('С#','C# - это круто','2023.05.23');

insert into article_comment(article_id, comment_text, likes) values
	(2,'ясно', 50),
	(1,'понял', 100);

select a.title, a.article_text, a.publish_date, 
	coalesce(jsonb_agg(json_build_object('id', c.article_id, 'comment_text', c.comment_text, 'likes', c.likes))
	filter(where c.article_id is not null), '[]')
	from article a
	left join article_comment c on a.id = c.article_id
	group by a.id;