-- 1. SQL 활용 PART1 ;

-- CROSS JOIN
-- 조인하는 두 테이블의 연결 조건을 누락되는 경우
-- 가능한 모든 조합에 대해 연결(조인)이 시도
-- dept(4건), emp(14건)의 CROSS JOIN의 결과 4*14 = 5건

-- dept 테이블과 emp 테이블을 조인을 하기 위해 FROM 절에 두개의 테이블을 기술 WHERE 절에 두 테이블의 연결 조건을 누락
-- 가능한 모든 조합이 나옴

SELECT dept.dname, emp.empno, emp.ename
FROM dept, emp
WHERE dept.deptno = 10;

SELECT dept.dname, emp.empno, emp.ename
FROM dept, emp
WHERE dept.deptno = 10
AND  dept.deptno = emp.deptno;

-- crossjoin1
SELECT *
FROM customer c, product p;

-- SUBQUERY
-- SUBQUERY : 쿼리안에 다른 쿼리가 들어가 있는 경우
-- SUBQUERY 가 사용된 위치에 따라 3가지로 분류
    -- SELECT 절 : SCALAR SUBQURY : 하나의 행, 하나의 컬럼만 리턴해야 에러가 발생하지 않음
    -- FROM 절 : INLINE - VIEW (직접 기술한 뷰) <-> VIEW
    -- WHERE 절 : SUBQUERY QUERY

-- 구하고자 하는 것
SMITH가 속한 부서에 속하는 직원들의 정보를 조회
1. SMITH가 속하는 부서 번호를 구한다.
2. 1번에서 구한 부서 번호에 속하는 직원들 정보를 조횐한다.

1.;
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

2.; 1번에서 구한 부서번호를 이용하여 해당 부서에 속하는 직원 정보를 조회;
SELECT *
FROM emp
WHERE deptno = 20;

-- SUBQUERY를 이용하면 두개의 쿼리를 동시에 하나의 SQL로 실행이 가능

SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');
                
-- 실습 sub1
-- 평균 급여보다 높은 급여를 받는 직원의 수를 조회하세요
1. 평균 급여 구하기
2. 구한 평균 급여보다 높은 급여를 받는 사람
SELECT *
FROM emp;

SELECT AVG(sal)
FROM emp;

SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT AVG(sal)
            FROM emp);
            
-- 실습 sub2
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
            FROM emp);

-- 다중행 연산자
-- IN
-- ANY [활용도는 다소 떨어짐] : 서브쿼리의 여러행중 한 행이라도 조건을 만족할 때
-- ALL [활용도는 다소 떨어짐] : 서브쿼리의 여러행중 모든 행에 대해 조건을 만족할 때;

-- 실습 sub3
-- SMITH가 속하는 부서의 모든 직원을 조회
-- SMITH와 WARD 직원이 속하는 부서의 모든 직원을 조회

SELECT *
FROM emp;

SELECT deptno
FROM emp
WHERE ename IN ('SMITH', 'WARD');

-- 서브쿼리의 결과가 여러 행일 때는 = 연산자를 사용하지 못한다.
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'))

-- SMITH, WARD 사원의 급여보다 급여가 작은 직원을 조회(SMITH, WARD 의 급여중 아무거나)
SMITH : 800
WARD : 1250
SELECT *
FROM emp;

SELECT deptno
FROM emp
WHERE ename IN ('SMITH', 'WARD');

SELECT deptno
FROM emp
WHERE sal < ANY (800, 1250);

SELECT *
FROM emp
WHERE sal < ANY (SELECT sal
                 FROM emp
                 WHERE ename IN('SMITH', 'WARD'));


-- SMITH, WARD 사원의 급여보다 급여가 작은 직원을 조회(SMITH, WARD 의 급여 2가지 모두에 대해 잘을 때)
SMITH : 800
WARD : 1250

SELECT *
FROM emp
WHERE sal > ALL (SELECT sal
                 FROM emp
                 WHERE ename IN('SMITH', 'WARD'));
                 
-- IN, NOT IN의 NULL과 관련된 유의 사항

-- 직원의 관리자 사번이 7902 이거나 NULL
-- IN 연산자는 OR 연산자로 치환 가능
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE mgr IN (7902, null); --> 한개 나옴 2개 나와야함

-- NULL 비교는 = 연산자가 아니라 IS NULL로 비교 해야지만 IN 연산자는 = 로 계산한다.
SELECT *
FROM emp
WHERE mgr = 7902 OR mgr = NULL;

-- empno NOT IN(7002, NULL) --> AND
-- 사원 번호가 7902가 아니면서 (AND) NULL이 아닌 데이터

SELECT *
FROM emp 
WHERE empno NOT IN (7902, NULL); 

SELECT *
FROM emp 
WHERE empno != 7902 AND empno != NULL; -- AND 그리고 NULL에 대한 연산은 항상 부정이기 때문에 값이 나오지 않음

-- 옳은 방법
SELECT *
FROM emp 
WHERE empno != 7902 AND empno IS NOT NULL;

pairwise (순서쌍);
-- 순서쌍의 결과를 동시에 만족 시킬때;
-- (mgr, deptno)
-- (7698, 30)(7839, 10)
SELECT *
FROM emp
WHERE (mgr,deptno) IN  (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN(7499, 7782));
-- non-pairwise 는 순서쌍을 도시에 만족시키지 않는 형태로 작성
-- mgr 값이 7698 이거나 7839이면서
-- deptno가 10번이거나 30번인 직원
-- MGR, DEPTNO
-- (7698,10),(7698,30)
-- (7839,10),(7839,30)
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
              FROM emp
              WHERE empno IN(7499, 7782))
AND deptno IN  (SELECT deptno
                FROM emp
                WHERE empno IN(7499, 7782));

스칼라 서브쿼리 : SELECT  절에 기술, 1개의 ROW, 1개의 COL을 조회하는 쿼리
스칼라 서브쿼리는 MAIN 쿼리의 컬럼을 사용하는게 가능하다.

SELECT SYSDATE
FROM dual;

SELECT SYSDATE, dept.*
FROM dept;

SELECT (SELECT SYSDATE
        FROM dual), dept.*
FROM dept;

SELECT empno, ename, deptno, (SELECT dname FROM dept WHERE deptno = emp.deptno) dname--(부서명을 가져오는 서브쿼리를 작성해라)
FROM emp;

-- INLINE VIEW : FROM 절에 기술되는 서브쿼리;

-- MAIN 쿼리의 컬럼을 SUBQUERY 에서 사용 하는지 유무에 따른 분류
-- 사용 할 경우 : correlated subquery(상호 연관 쿼리), 서브쿼리만 단독으로 실행하는게 불가능, 메인쿼리의 컬럼을 사용하기 때문
--                실행순서가 정해져 있다 (main == > sub)
-- 사용하지 않을 경우 : non-correlated subquery(비상호 연관 서브쿼리), 서브쿼리만 단독으로 실행하는게 가능
--                    실행순서가 정해져 있지 않다. (main ==> sub, sub ==> main)
-- 모든 직원의 급여 평균보다 급여가 높은 사람을 조회
SELECT *
FROM emp 
WHERE sal > (SELECT AVG(sal)
            FROM emp);
-- pt267            
-- 직원이 속한 부서의 급여 평균보다 급여가 높은 사람을 조회;


SELECT AVG(sal)
FROM emp
WHERE deptno = 30;
            
SELECT *
FROM emp m
WHERE sal > (SELECT AVG(sal)
            FROM emp s
            WHERE s.deptno = m.deptno);
            
-- 위의 문제를 조인을 이용해서 풀어보자
-- 1. 조인 테이블 선정
--  emp, 부서별 급여 평균 (inline view)

SELECT emp.* -- emp.ename, sal, emp.deptno, dept_sal.* --> emp.*로 대체 가능
FROM emp, (SELECT deptno, ROUND(AVG(sal)) avg_sal
            FROM emp
            GROUP BY deptno) dept_sal
WHERE emp.deptno = dept_sal.deptno
AND emp.sal > dept_sal.avg_sal;

-- sub4
-- 데이터 추가
 INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
 
 DELETE dept
 WHERE deptno = 99;
 
 ROLLBACK; -- 트랙잭션 취소
 COMMIT; -- 트랙잭션 확정 -- 커밋하면 rollback 해도 돌아가지 않음
 
 select *
 from dept;
 
 
 select *
 from emp;
 
 select *
 from dept
 where deptno not in (SELECT deptno from emp);
 