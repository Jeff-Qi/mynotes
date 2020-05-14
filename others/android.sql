CREATE TABLE parent
(
id int(11) not null auto_increment primary key,
phonenum varchar(11) not null,
passwd varchar(255) not null,
icon varchar(255) default null,
address varchar(255) default null
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE teacher
(
id int(11) not null auto_increment primary key,
teacher_phonum varchar(255) not null,
teach_sex varchar(255) not null,
teach_name varchar(255) not null,
teach_icon varchar(255) not null,
teach_address varchar(255) not null,
teach_exper varchar(255) default null,
teach_sub varchar(255) not null,
grade varchar(255) not null
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE par_money
(
id int(11) not null auto_increment primary key,
phonenum varchar(11) not null,
par_balance varchar(255) not null,
yue varchar(255) not null,
jifen varchar(255) not null
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE par_order
(
id int(11) not null auto_increment primary key,
par_phone varchar(11) not null,
bookname varchar(255) not null,
count varchar(255) not null,
price varchar(255) not null,
state varchar(255) not null
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE par_reward
(
id int(11) not null auto_increment primary key,
phonenum varchar(11) not null,
account varchar(255) not null,
data date not null
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE plan
(
id int(11) not null auto_increment primary key,
plan_phonenum varchar(11) not null,
plan_con varchar(255) not null,
datetime date not null
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE reserve
(
id int(11) not null auto_increment primary key,
parent_phone varchar(255) not null,
teach_phone varchar(255) not null,
teach_name varchar(255) not null,
subject varchar(255) not null,
date timestamp not null
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE evaluate
(
id int(11) not null auto_increment primary key,
par_phone varchar(11) not null,
tea_phone varchar(11) not null,
content varchar(255) not null,
subject varchar(255) not null,
grade varchar(255) not null,
date date not null
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
