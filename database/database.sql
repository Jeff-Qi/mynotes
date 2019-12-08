CREATE DATABASE db_design;
1. 建表：
CREATE TABLE `j` (
  `JNO` varchar(10) NOT NULL,
  `JNAME` varchar(20) DEFAULT NULL,
  `CITY` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`JNO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `p` (
  `PNO` varchar(10) NOT NULL,
  `PNAME` varchar(20) DEFAULT NULL,
  `COLOR` varchar(10) DEFAULT NULL,
  `WEIGHT` tinyint(2) DEFAULT NULL,
  PRIMARY KEY (`PNO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `s` (
  `SNO` varchar(10) NOT NULL,
  `SNAME` varchar(20) DEFAULT NULL,
  `STATUS` tinyint(3) DEFAULT NULL,
  `CITY` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`SNO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `spj` (
  `SNO` varchar(10) NOT NULL,
  `PNO` varchar(10) NOT NULL,
  `JNO` varchar(10) NOT NULL,
  `QTY` smallint(4) DEFAULT NULL,
  KEY `SNO` (`SNO`),
  KEY `PNO` (`PNO`),
  KEY `JNO` (`JNO`),
  CONSTRAINT `spj_ibfk_1` FOREIGN KEY (`SNO`) REFERENCES `s` (`sno`),
  CONSTRAINT `spj_ibfk_2` FOREIGN KEY (`PNO`) REFERENCES `p` (`pno`),
  CONSTRAINT `spj_ibfk_3` FOREIGN KEY (`JNO`) REFERENCES `j` (`jno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


################################################################################


1. 检索上海产的零件的工程名称；
SELECT DISTINCT j.JNAME
FROM `j` JOIN (SELECT spj.SNO SNO,spj.JNO JNO
FROM spj
WHERE SNO=(SELECT s.SNO FROM `s` WHERE CITY='上海')) as a
ON j.JNO=a.JNO;

2. 检索供应工程J1零件P1的供应商号SNO；
SELECT spj.SNO
FROM `spj`
WHERE JNO='J1' AND PNO='P1';

3. 检索供应工程J1零件为红色的供应商号SNO；
SELECT spj.SNO
FROM `spj`
WHERE JNO='J1' AND PNO IN (SELECT p.PNO
FROM `p`
WHERE COLOR='红');

4. 检索没有使用天津生产的红色零件的工程号JNO；
SELECT DISTINCT spj.JNO
FROM `spj`
WHERE SNO NOT IN (SELECT s.SNO
FROM `s`
WHERE CITY='天津') AND PNO NOT IN (SELECT p.PNO
FROM `p`
WHERE COLOR='红');

5. 检索至少用了供应商S1所供应的全部零件的工程号JNO；
SELECT a.JNO
FROM `spj` a
WHERE a.SNO='S1'
GROUP BY a.JNO
HAVING COUNT(*)=(SELECT COUNT(*)
FROM (SELECT DISTINCT b.PNO PNO
FROM `spj` b
WHERE b.SNO='S1') as d);

6. 检索购买了零件P1的工程项目号JNO及数量QTY，并要求对查询的结果按
数量QTY降序排列。
SELECT a.JNO,a.QTY
FROM spj as a
WHERE a.PNO='P1'
ORDER BY a.QTY DESC;

################################################################################


1．	把全部红色零件颜色改为粉红色；
UPDATE p
SET COLOR='粉'
WHERE COLOR='红';

2．	由S1供给J1的零件P1今改为由S2供应，作必要修改；
UPDATE `spj`
SET SNO='S2'
WHERE JNO='J1' AND SNO='S1' AND PNO='P1';

3．	删去全部蓝色零件及相应的SPJ记录；


4．	把全部螺母的重量置为0；
UPDATE `p`
SET WEIGHT=0
WHERE PNAME='螺母';

5．	为SPJ表的QTY字段设计CHECK约束：0〈 QTY〈1000；
ALTER TBALE `spj`
ADD CHECK (QTY BETWEEN 0 AND 1000);

6．	实现对SPJ表的操作权限管理的使用。
GRANT ALL PRIVILEGES ON db_design.*
TO 'jeff'@'%'
WITH



################################################################################


1.	找出向北京供应商购买重量大于30的零件的工程号；
SELECT spj.JNO
FROM spj JOIN s
ON spj.SNO=s.SNO
WHERE s.CITY='北京' AND spj.PNO IN (SELECT PNO FROM p WHERE WEIGHT>30);

2.	找出工程项目J2使用的各种零件的名称及其数量；
SELECT p.PNAME,COUNT(*)
FROM spj JOIN p
ON spj.PNO=p.PNO
WHERE spj.JNO='J2'
GROUP BY p.PNAME,p.PNO;

3.	按工程号递增的顺序列出每个工程购买的零件总数；
SELECT count(*) number
FROM spj
GROUP BY spj.JNO
ORDER BY spj.JNO;

4.	编程输出如下报表:供应商	零件	工程项目	数量
SELECT s.SNAME as '供应商',p.PNAME as '零件',j.JNAME as '工程项目',QTY as '数量'
FROM spj JOIN p
ON spj.PNO=p.PNO
JOIN s
ON spj.SNO=s.SNO
JOIN j
ON spj.JNO=j.JNO;

################################################################################

INSERT INTO spj
VALUES
('S1','P1','J1',200);

INSERT INTO spj
SELECT * FROM spj_copy1;

UPDATE spj
SET QTY=100
WHERE SNO='S1';

DELETE FROM spj
WHEN SNO="S1";

CREATE VIEW second_view
AS SELECT SNO,QTY
FROM spj;

CREATE VIEW second_view
AS SELECT SNO,QTY
FROM spj
WHERE QTY > 150
WITH CHECK OPTION;

CREATE VIEW SS
AS SELECT * FROM s
WHERE CITY='上海';

CREATE VIEW JPNum
AS SELECT JNO,SUM(QTY)
FROM spj
GROUP BY JNO;

UPDATE SS
SET SNAME="为国";

CREATE index  xixi on spj QTY;

ALTER TABLE spj DROP index  xixi;

ALTER TABLE s
ADD UNIQUE haha SNAME;

ALTER TABLE s
ADD index xixi (SNO,JNO,QTY);

alter table table_name
ADD index xixi ((LOWER(SNO)));

################################################################################

#存储过程
CREATE PROCEDURE proc_1()
BEGIN
SELECT * FROM s;
END;//

delimiter //
CREATE PROCEDURE proc_3()
BEGIN
DECLARE a int DEFAULT 1;
SET a=111;
IF a>0 THEN
SELECT @a;
SELECT a;
ELSE
SELECT 1;
END IF;
end;//
delimiter ;

delimiter //
CREATE PROCEDURE proc_4()
BEGIN
DECLARE a INT DEFAULT 0;
DECLARE b int DEFAULT 0;
SET a = (select 1 FROM spj WHERE SNO='S2' AND PNO='P1' AND JNO='J1' LIMIT 1);
IF a=1 THEN
  SET b = (SELECT  QTY FROM spj WHERE SNO='S1' AND PNO='P1' AND JNO='J1');
  DELETE FROM spj WHERE SNO='S1' AND PNO='P1' AND JNO='J1';
  UPDATE spj SET QTY = QTY + b WHERE SNO='S2' AND PNO='P1' AND JNO='J1';
ELSE
  UPDATE spj SET SNO='S2' WHERE SNO='S1' AND PNO='P1' AND JNO='J1';
END IF;
end;//
delimiter ;

################################################################################

CREATE ROLE manager_development;
GRANT SELECT ON db_design.p TO manager_development;
CREATE USER jeff IDENTIFIED BY '123456';
GRANT manager_development TO jeff;

ALTER TABLE spj ADD CONSTRAINT xixi PRIMARY;

ALTER TABLE spj ADD PRIMARY KEY (SNO,QTY);
ALTER TBALE spj DROP PRIMARY KEY;

ALTER TABLE spj ADD CONSTRAINT sspj_sno FOREIGN KEY spj(SNO) REFERENCES s(SNO);
