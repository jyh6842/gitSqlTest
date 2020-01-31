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

--JOIN WITH USING�� ORACLE�� ǥ���ϸ�?;
SELECT emp.ename, dept.dname, emp.deptno -- ����Ŭ ����
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--ANSI : JOIN WITH ON
--���� �Ϸ����ϴ� ���̺��� �÷� �̸��� ���� �ٸ���;
SELECT emp.ename, dept.dname, deptno
FROM emp JOIN dept ON ( emp.deptno = dept.deptno);