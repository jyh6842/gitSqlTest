-- 1. SQL
-- JOIN

-- JOIN두 테이블을 연결하는 작업
-- JOIN 문법
-- 1. ANSI 문법
-- 2. ORACLE 문법

-- Natual Join
-- 두 테이블간 컬럼명이 같을 때 해당 컬럼으로 연결(조인)
-- emp, dept 테이블에는 deptno 라는 컬럼이 존재
SELECT *
FROM emp NATURAL JOIN dept;

-- Natural join에 사용된 조인 컬럼(deptno)는 한정자 (ex : 테이블명, 테이블 별칭)dmf tkdydgkwl dksgrh
-- 컬럼명만 기술한다 (dept,deptno --> deptno)
SELECT emp.empno, emp.ename, dept.dname, deptno -- deptno는 한정자를 가질수 없다. 왜냐하면 deptno를 NATURAL JOIN에 사용했기 때문이다.
FROM emp NATURAL JOIN dept;

-- 테이블에 대한 별칭도 사용가능
SELECT e.empno, e.ename, d.dname, deptno 
FROM emp e NATURAL JOIN dept d;

-- ORACLE JOIN
-- FROM 절에 조인할 테이블 목록을 ,로 구분하여 나열한다.
-- 조인할 테이블의 연결 조건을 WHERE절에 기술한다.
-- 양쪽 테이블 emp, dept 테이블에 존재하는 deptno 컬럼이 [같을 때] 조인
SELECT emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

EXPLAIN PLAN FOR
SELECT emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno != dept.deptno;

SELECT * 
FROM TABLE(dbms_xplan.display);

SELECT e.empno, e.ename, d.dname, d.deptno -- 오라클 조인에서는 한정자를 써줘야 한다.
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- ANSI : join with USING
-- 조인 하려는 두개의 테이블에 이름이 같은 컬럼이 두개이지만
-- 하나의 컬럼으로만 조인을 하고자 할때
-- 조인하려는 기준 컬럼을 기술
-- emp, dept 테이블의 공통 컬럼 : deptno

SELECT emp.ename, dept.dname, deptno -- 내추럴 조인
FROM emp JOIN dept USING(deptno);

--JOIN WITH USING을 ORACLE로 표현하면?;
SELECT emp.ename, dept.dname, emp.deptno -- 오라클 조인
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--ANSI : JOIN WITH ON
--조인 하려고하는 테이블의 컬럼 이름이 서로 다를때;
SELECT emp.ename, dept.dname, deptno
FROM emp JOIN dept ON ( emp.deptno = dept.deptno);