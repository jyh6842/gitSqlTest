-- sub4
-- dept 테이블에는 5건의 데이터가 존재
-- emp 테이블에는 14명의 직원이 있고, 직원은 하나의 부서에 속해 있다.(deptno)
-- 부서중 직원이 속해 있지 않은 부서 정보를 조회

-- 서브쿼리에서 데이터의 조건이 맞는지 확인자 역할을 하는 서브쿼리 작성

SELECT *
FROM dept
WHERE deptno NOT IN (10,20,30);

SELECT *
FROM emp;

SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                    FROM emp);
                    
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                    FROM emp
                    GROUP BY deptno);
                    
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT DISTINCT deptno
                    FROM emp);