-- 1. SQL
-- JOIN

-- JOIN�� ���̺��� �����ϴ� �۾�
-- JOIN ����
-- 1. ANSI ����
-- 2. ORACLE ����

-- Natual Join
-- �� ���̺� �÷����� ���� �� �ش� �÷����� ����(����)
-- emp, dept ���̺��� deptno ��� �÷��� ����
SELECT *
FROM emp NATURAL JOIN dept;

-- Natural join�� ���� ���� �÷�(deptno)�� ������ (ex : ���̺��, ���̺� ��Ī)dmf tkdydgkwl dksgrh
-- �÷��� ����Ѵ� (dept,deptno --> deptno)
SELECT emp.empno, emp.ename, dept.dname, deptno -- deptno�� �����ڸ� ������ ����. �ֳ��ϸ� deptno�� NATURAL JOIN�� ����߱� �����̴�.
FROM emp NATURAL JOIN dept;

-- ���̺� ���� ��Ī�� ��밡��
SELECT e.empno, e.ename, d.dname, deptno 
FROM emp e NATURAL JOIN dept d;

-- ORACLE JOIN
-- FROM ���� ������ ���̺� ����� ,�� �����Ͽ� �����Ѵ�.
-- ������ ���̺��� ���� ������ WHERE���� ����Ѵ�.
-- ���� ���̺� emp, dept ���̺� �����ϴ� deptno �÷��� [���� ��] ����
SELECT emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

EXPLAIN PLAN FOR
SELECT emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno != dept.deptno;

SELECT * 
FROM TABLE(dbms_xplan.display);

SELECT e.empno, e.ename, d.dname, d.deptno -- ����Ŭ ���ο����� �����ڸ� ����� �Ѵ�.
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- ANSI : join with USING
-- ���� �Ϸ��� �ΰ��� ���̺� �̸��� ���� �÷��� �ΰ�������
-- �ϳ��� �÷����θ� ������ �ϰ��� �Ҷ�
-- �����Ϸ��� ���� �÷��� ���
-- emp, dept ���̺��� ���� �÷� : deptno

SELECT emp.ename, dept.dname, deptno -- ���߷� ����
FROM emp JOIN dept USING(deptno);

-- JOIN WITH USING�� ORACLE�� ǥ���ϸ�?;
SELECT emp.ename, dept.dname, emp.deptno -- ����Ŭ ����
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- ANSI : JOIN WITH ON
-- ���� �Ϸ����ϴ� ���̺��� �÷� �̸��� ���� �ٸ���;
SELECT emp.ename, dept.dname, emp.deptno -- ���߷� �����ε� �����ڸ� ���� emp.deptno
FROM emp JOIN dept ON ( emp.deptno = dept.deptno);

--JOIN WITH ON -> ORACLE;
SELECT emp.ename, dept.dname, emp.deptno -- ���߷� �����ε� �����ڸ� ���� emp.deptno
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- SELF JOIN : ���� ���̺��� ����;
��? �ұ�? ���̺��� ���� ����?;
�� : emp ���̺��� �����Ǵ� ����� ������ ����� �̿��Ͽ� ������ �̸��� ��ȸ�Ҷ�;
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno); -- ������� mgr�� ��� ������ ����

����Ŭ �������� �ۼ�;
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

equal ���� : =
non-equal ���� !=, >, <, BETWEEN AND ;

����� �޿� ������ �޿� ��� ���̺��� �̿��Ͽ�
�ش����� �޿� ����� ���غ���;
SELECT ename, sal
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal
                AND salgrade.hisal;
                
ANSI : ������ �̿��Ͽ� ���� ���ι��� �ۼ� ;
SELECT e.ename, e.sal, s.grade
FROM emp e JOIN salgrade s ON (e.sal BETWEEN s.losal AND s.hisal);

SELECT * 
FROM salgrade;

-- �ǽ� join0
select * from emp;
select * from dept;

SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- �ǽ� join0_1
SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.deptno != 20; 

SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e JOIN dept d ON (e.deptno = d.deptno) AND e.deptno IN(10,30);

-- �ǽ� join0_2
SELECT e.empno, e.ename, e.sal, e.deptno, d.dname 
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.sal>2500;

SELECT e.empno, e.ename, e.sal, e.deptno, d.dname 
FROM emp e JOIN dept d ON (e.deptno = d.deptno) AND e.sal>2500;

-- �ǽ� join0_3
SELECT e.empno, e.ename, e.sal, e.deptno, d.dname 
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.sal>2500 AND e.empno>7600;

SELECT e.empno, e.ename, e.sal, e.deptno, d.dname 
FROM emp e JOIN dept d ON (e.deptno = d.deptno) AND e.sal>2500 AND e.empno>7600;

-- �ǽ� join0_4
SELECT e.empno, e.ename, e.sal, e.deptno, d.dname 
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.sal>2500 AND e.empno>7600 AND d.dname ='RESEARCH';

SELECT e.empno, e.ename, e.sal, e.deptno, d.dname 
FROM emp e JOIN dept d ON (e.deptno = d.deptno) AND e.sal>2500 AND e.empno>7600 AND d.dname ='RESEARCH';


-- �ǽ� join1
PROD : PROD_LGU
LPROD : LPROD_GU;

-- LPROD ǰ��, PROD�� ���� ǰ��
SELECT *
FROM prod;

SELECT *
FROM lprod;

SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM  lprod, prod 
WHERE lprod_gu = prod_lgu;

SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM lprod lp JOIN prod ON lprod_gu = prod_lgu;

-- �ǽ� join2
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM prod, buyer
WHERE prod_lgu = buyer_lgu;

SELECT buyer_id, buyer_name, prod_id, prod_name
FROM prod JOIN buyer ON prod_lgu = buyer_lgu;

-- �ǽ� join3
--oracel ����
SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member, cart, prod
WHERE member.mem_id = cart.cart_member
AND cart.cart_prod = prod.prod_id;

-- ANSI ����
SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member JOIN cart ON (member.mem_id = cart.cart_member)
            JOIN prod ON (cart.cart_prod = prod.prod_id);
