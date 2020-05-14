CREATE TABLE menu_table(
id INT(10) NOT NULL auto_increment PRIMARY KEY,
name VARCHAR(10) NOT NULL,
price FLOAT(6,2) NOT NULL CHECK (price >= 0),
left_number INT(4) NOT NULL CHECK (left_number >= 0),
message VARCHAR(100));

CREATE TABLE user_table(
id INT NOT NULL auto_increment PRIMARY KEY,
phonenumber BIGINT(11) NOT NULL UNIQUE CHECK (phonenumber > 0),
user_name VARCHAR(10) NOT NULL,
balance DECIMAL(6,2) DEFAULT 0 CHECK (balance >= 0)
);

CREATE TABLE order_table(
id INT NOT NULL auto_increment PRIMARY KEY,
data TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
menu_table_id INT(10) NOT NULL,
amount INT(4) DEFAULT 1 CHECK (amount >= 1),
user_table_id  INT NOT NULL,
type INT(1) NOT NULL CHECK (type >= 1 AND type <= 3),
CONSTRAINT menu_table_order_table FOREIGN KEY (menu_table_id) REFERENCES menu_table(id),
CONSTRAINT user_table_order_table FOREIGN KEY (user_table_id) REFERENCES user_table(id)
);

CREATE TABLE collection_table(
user_table_id INT NOT NULL,
menu_table_id INT(10) NOT NULL,
CONSTRAINT menu_table_colection_table FOREIGN KEY (menu_table_id) REFERENCES menu_table(id),
CONSTRAINT user_table_user_table FOREIGN KEY (user_table_id) REFERENCES user_table(id)
);

CREATE TABLE cart_table(
id INT NOT NULL auto_increment PRIMARY KEY,
user_id INT NOT NULL,
menu_id INT(10) NOT NULL,
amount INT DEFAULT 1 CHECK (amount >= 1),
KEY `user_id_menu_id_cart_id`  (id,user_id,menu_id),
CONSTRAINT FOREIGN KEY (user_id) REFERENCES user_table(id),
CONSTRAINT FOREIGN KEY (menu_id) REFERENCES menu_table(id)
);
