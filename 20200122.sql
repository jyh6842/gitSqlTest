SELECT *
FROM lprod;

SELECT buyer_id, buyer_name
FROM buyer;

SELECT * 
FROM cart;

SELECT mem_id, mem_pass, mem_name
FROM member;

--user ���̺� ��ȸ
SELECT *
FROM users;

-- ���̺� � �÷��� �մ��� Ȯ���ϴ� ���
-- 1. SELECT * 
-- 2. TOOL�� ��� (�����-TABLE)
-- 3. DESC ���̺�� (DESC-DESCRIBE)
DESC users;

-- users ���̺��� userid, usernm, tog_dt �÷��� ��ȸ�ϴ� sql�� �ۼ��ϼ���
-- ��¥ ���� (reg_dt �÷��� date ������ ���� �� �մ� Ÿ��)
-- SQL ��¥ �÷� + (���ϱ� ����)
-- �������� ��Ģ������ �ƴѰ͵�(5+5)
-- String h = "hello";
-- String w = "world";
-- String hw = h+w; --�ڹٿ����� �� ���ڿ��� �����ض�
-- SQL���� ���ǵ� ��¥ ���� : ��¥ + ������ ���ڷ� ����Ͽ� ���� ��¥�� �ȴ�. ( 2019/01/28 +5 = 2019/02/02)
-- reg_dt : ������� �÷�
-- null : ���� �𸣴� ����
-- null�� ���� ���� ����� �׻� null
-- AS�� ������ ���� �����ϱ� ���� ����ϴ� Ű����� ������� �ʾƵ� �ȴ�.
-- null �� ������ �ٸ���. "", null

SELECT userid u_id, usernm, reg_dt, reg_dt+5 AS reg_dt_after_5day
FROM users;

SELECT prod_id AS id, prod_name AS name
FROM prod;

SELECT lprod_gu AS gu, lprod_nm AS nm
FROM lprod;

SELECT buyer_id AS ���̾���̵�, buyer_name AS �̸�
FROM buyer;

-- ���ڿ� ����
-- �ڹ� ���� ���ڿ� ���� : + ("Hello" + "world")
-- SQL������ : || ('Hello' || 'world')
-- SSQL������ : concat('Hello', 'world')

-- userid, usernm Į���� ����, ��Ī id_name
SELECT *
FROM users;

SELECT userid || usernm AS id_name,
        CONCAT(userid, usernm) AS concat_id_name
FROM users;

-- ����, ���
-- int a = 5; String msg = "Hello, World";
-- ������ �̿��� ���
-- System.out.println(msg) 
--����� �̿��� ���
-- System.out.println("Hello, World"); 

-- SQL������ ������ ����
-- (�÷��� ����� ����, pl/sql ���� ������ ����)
-- SQL���� ���ڿ� ����� �Ǳ� �����̼����� ǥ��
-- "Hello, world" --> 'Hello, World'

-- ���ڿ� ����� �÷����� ����
-- user id : brown
-- user id : cony
SELECT  'user id : ' || userid AS "use rid" --�����̳� �빮�ڸ� ����ϱ� ���ؼ��� "" ���������̼��� ��� �ϸ� �ȴ�.
FROM users;

SELECT 'SELECT * FROM ' || table_name || ';' AS query 
FROM user_tables;

-- ||�� --> CONCAT ���� �غ���
-- CONCAT(agr1, arg2) ���ڰ� �ΰ� �ۿ� ����
SELECT CONCAT(CONCAT('SELECT * FROM', table_name), ';') AS query
FROM user_tables;

-- int a = 5; //�Ҵ�, ���� ������
-- if ( a == 5) (a�� ���� 5���� ��)
-- sql ������ ������ ������ ����. (PL/SQL)
-- sql = --> equal