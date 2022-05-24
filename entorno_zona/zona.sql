create table if not exists zona (
	id int(4) auto_increment,
	username varchar(255) not null,
	distance int(3) not null default 20,
	type tinyint(1) not null default 0,
	x decimal(7, 3) not null,
	y decimal(7, 3) not null,
	z decimal(7, 3) not null,
	msg text null,
	constraint zona_pk
		primary key (id)
);
