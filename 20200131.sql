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

-- JOIN WITH USING을 ORACLE로 표현하면?;
SELECT emp.ename, dept.dname, emp.deptno -- 오라클 조인
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- ANSI : JOIN WITH ON
-- 조인 하려고하는 테이블의 컬럼 이름이 서로 다를때;
SELECT emp.ename, dept.dname, emp.deptno -- 내추럴 조인인데 한정자를 써줌 emp.deptno
FROM emp JOIN dept ON ( emp.deptno = dept.deptno);

--JOIN WITH ON -> ORACLE;
SELECT emp.ename, dept.dname, emp.deptno -- 내추럴 조인인데 한정자를 써줌 emp.deptno
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- SELF JOIN : 같은 테이블간의 조인;
왜? 할까? 테이블의 계층 구조?;
예 : emp 테이블에서 관리되는 사원의 관리자 사번을 이용하여 관리자 이름을 조회할때;
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno); -- 사장님은 mgr이 없어서 나오지 않음

오라클 문법으로 작성;
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

equal 조인 : =
non-equal 조인 !=, >, <, BETWEEN AND ;

사원의 급여 정보와 급여 등급 테이블을 이용하여
해당사원의 급여 등급을 구해보자;
SELECT ename, sal
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal
                AND salgrade.hisal;
                
ANSI : 문법을 이요하여 위의 조인문을 작성 ;
SELECT e.ename, e.sal, s.grade
FROM emp e JOIN salgrade s ON (e.sal BETWEEN s.losal AND s.hisal);

SELECT * 
FROM salgrade;

-- 실습 join0
select * from emp;
select * from dept;

SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- 실습 join0_1
SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.deptno != 20; 

SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e JOIN dept d ON (e.deptno = d.deptno) AND e.deptno IN(10,30);

-- 실습 join0_2
SELECT e.empno, e.ename, e.sal, e.deptno, d.dname 
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.sal>2500;

SELECT e.empno, e.ename, e.sal, e.deptno, d.dname 
FROM emp e JOIN dept d ON (e.deptno = d.deptno) AND e.sal>2500;

-- 실습 join0_3
SELECT e.empno, e.ename, e.sal, e.deptno, d.dname 
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.sal>2500 AND e.empno>7600;

SELECT e.empno, e.ename, e.sal, e.deptno, d.dname 
FROM emp e JOIN dept d ON (e.deptno = d.deptno) AND e.sal>2500 AND e.empno>7600;

-- 실습 join0_4
SELECT e.empno, e.ename, e.sal, e.deptno, d.dname 
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.sal>2500 AND e.empno>7600 AND d.dname ='RESEARCH';

SELECT e.empno, e.ename, e.sal, e.deptno, d.dname 
FROM emp e JOIN dept d ON (e.deptno = d.deptno) AND e.sal>2500 AND e.empno>7600 AND d.dname ='RESEARCH';


-- 실습 join1
PROD : PROD_LGU
LPROD : LPROD_GU;

-- LPROD 품목, PROD는 세부 품목
SELECT *
FROM prod;

SELECT *
FROM lprod;

SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM  lprod, prod 
WHERE lprod_gu = prod_lgu;

SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM lprod lp JOIN prod ON lprod_gu = prod_lgu;

-- 실습 join2
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM prod, buyer
WHERE prod_lgu = buyer_lgu;

SELECT buyer_id, buyer_name, prod_id, prod_name
FROM prod JOIN buyer ON prod_lgu = buyer_lgu;

-- 실습 join3
--oracel 문법
SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member, cart, prod
WHERE member.mem_id = cart.cart_member
AND cart.cart_prod = prod.prod_id;

-- ANSI 문법
SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member JOIN cart ON (member.mem_id = cart.cart_member)
            JOIN prod ON (cart.cart_prod = prod.prod_id);
