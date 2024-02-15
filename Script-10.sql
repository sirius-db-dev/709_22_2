create extension if not exists "uuid-ossp";

drop table if exists chats, messages;

create table chats 
(
	id				uuid primary key default uuid_generate_v4(),
	name			text,
	creation_date	date
);

create table messages
(
	id				uuid primary key default uuid_generate_v4(),
	chat_id			uuid references chats(id),
	msg_text		text,
	sending_date	date
);

insert into chats (name, creation_date)
values
	('K0709-22-2', '2022.09.01'),
	('Nishepops', '2022.08.28'),
	('lololoshka_chat', '2014.01.11');
	
insert into messages (chat_id, msg_text, sending_date)
values
	((select id from chats where name='K0709-22-2'), 'privet', '2022.09.01'),
	((select id from chats where name='K0709-22-2'), 'skinte otveti', '2024.02.15'),
	((select id from chats where name='Nishepops'), 'i love kaplan', '2022.12.31'),
	((select id from chats where name='Nishepops'), 'i still love kaplan', '2024.02.15'),
	((select id from chats where name='lololoshka_chat'), 'lololoshka krutoi', '2020.01.01'),
	((select id from chats where name='lololoshka_chat'), 'frost lox', '2017.02.14');

select 
	c.id,
	name,
	creation_date,
	coalesce(json_agg(jsonb_build_object(
		'id', m.id, 'chat_id', m.chat_id, 'msg_text', m.msg_text, 'sending_date', m.sending_date))
		filter (where m.id is not null), '[]') as messages
from chats c
left join messages m on c.id=m.chat_id
group by c.id;


