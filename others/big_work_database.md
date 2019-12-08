CREATE TABLE property_info
(
change_id INT NOT NULL,
change_date TIMESTAMP NOT NULL,
change_type TINYINT(1) NOT NULL,
change_amount DECIMAL(10,2) NOT NULL,
discribe_info TINYTEXT NOT NULL
);

CREATE TABLE payment_type_info
(
type_id int(2) NOT NULL,
type_name VARCHAR(10) NOT NULL
);

CREATE TABLE employee_info
(
employee_id INT NOT NULL,
employee_name VARCHAR(10) NOT NULL,
employee_dept INT NOT NULL
);

CREATE TABLE department_info
(
dept_id INT NOT NULL,
dept_name VARCHAR(10) NOT NULL
);

CREATE TABLE department_bill_info
(
department_bill_id INT NOT NULL,
department_bill_time TIMESTAMP NOT NULL,
department_bill_dept INT NOT NULL,
department_bill_amount DECIMAL(10,2) NOT NULL,
department_bill_discribe TINYTEXT  NOT NULL
);

CREATE TABLE salary_bill_info
(
salary_bill_id INT NOT NULL,
employee_id INT NOT NULL,
salary_bill_date TIMESTAMP NOT NULL,
salary_bill_amount DECIMAL(10,2) NOT NULL
);

CREATE TABLE investment_recode_info
(
investment_id INT NOT NULL,
investment_date TIMESTAMP NOT NULL,
investment_object INT NOT NULL,
investment_functionary_id INT NOT NULL,
investment_amount DECIMAL(10,2) NOT NULL
);

CREATE TABLE reception_info
(
reception_id INT NOT NULL,
reception_date TIMESTAMP NOT NULL,
reception_functionary_id INT NOT NULL,
reception_amount DECIMAL(10,2) NOT NULL
);

CREATE TABLE position_info
(
position_id INT NOT NULL,
positiont_name varchar(10) NOT NULL
);

INSERT INTO position_info
(position_name)
VALUES
('部门经理'),('柜台人员'),('投资人员'),('普通员工');

INSERT INTO employee_info
(employee_name,employee_position_id,employee_dept)
VALUES
('小明',1,1),('小王',1,2),('小赵',1,3),('小钱',1,4),
('小孙',2,1),('小李',2,1),('小周',2,1),('小吴',2,1),
('小郑',3,1),('小冯',3,1),('小陈',3,1),('小卫',3,1),
('小蒋',4,2),('小沈',4,2),('小韩',4,2),('小杨',4,2),
('小朱',4,3),('小秦',4,3),('小尤',4,3),('小许',4,3),
('小何',4,4),('小吕',4,4),('小施',4,4),('小张',4,4);

delimiter //
CREATE TRIGGER from_salary_to_property AFTER INSERT ON salary_bill_info
FOR EACH ROW
BEGIN
INSERT INTO property_info
(change_id,change_type,change_date,change_amount,discribe_info)
VALUES
(NEW.salary_bill_id,2,NEW.salary_bill_date,NEW.salary_bill_amount,'工资支出');
END
//
delimiter ;

INSERT INTO salary_bill_info
(employee_id,salary_bill_date,salary_bill_amount)
VALUES
(1,'2019-11-24 12:12:12',23456.24);

delimiter //
CREATE TRIGGER from_reception_to_property AFTER INSERT ON reception_info
FOR EACH ROW
BEGIN
INSERT INTO property_info
(change_id,change_type,change_date,change_amount,discribe_info)
VALUES
(NEW.reception_id,4,NEW.reception_date,NEW.reception_amount,'柜台收支记录');
END
//
delimiter ;

INSERT INTO reception_info
(reception_date,reception_functionary_id,reception_amount)
VALUES
('2019-11-25 11:11:11',5,1000.12),
('2019-11-25 10:10:10',7,-123.12);

delimiter //
CREATE TRIGGER from_investment_to_property AFTER INSERT ON investment_recode_info
FOR EACH ROW
BEGIN
INSERT INTO property_info
(change_id,change_type,change_date,change_amount,discribe_info)
VALUES
(NEW.investment_id,3,NEW.investment_date,NEW.investment_amount,'投资支出、亏损与收益');
END
//
delimiter ;

INSERT INTO investment_recode_info
(investment_date,investment_functionary_id,investment_amount)
VALUES
('2019-11-26 12:13:14',9,-1234.56),
('2019-11-26 13:14:15',11,2345.67);


delimiter //
CREATE TRIGGER from_department_bill_to_property AFTER INSERT ON department_bill_info
FOR EACH ROW
BEGIN
INSERT INTO property_info
(change_id,change_type,change_date,change_amount,discribe_info)
VALUES
(NEW.department_bill_id,1,NEW.department_bill_time,NEW.department_bill_amount,NEW.department_bill_discribe);
END
//
delimiter ;

INSERT INTO department_bill_info
(department_bill_time,department_bill_dept,department_bill_amount,department_bill_discribe)
VALUES
('2019-11-27 9:10:11',1,-987.65,'购买打印机'),
('2019-11-27 10:11:12',2,-876.54,'购买零食'),
('2019-11-27 11:12:13',3,-765.43,'员工津贴'),
('2019-11-27 12:13:14',4,-654.32,'采购公司耗材');
