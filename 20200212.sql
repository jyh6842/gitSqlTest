1. table full
2. idx1 : empno
3. idx2 : job; <-- 이걸로 접근함

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 2645879471
 
-------------------------------------------------------------------------------------------
| Id  | Operation                   | Name        | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |             |     1 |    87 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP         |     1 |    87 |     2   (0)| 00:00:01 | - filter("ENAME" LIKE 'C%') C로 시작하는 거 읽음 C 아닌거 버림 이거 읽음
|*  2 |   INDEX RANGE SCAN          | IDX_N_EMP02 |     1 |       |     1   (0)| 00:00:01 |
-------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%') C로 시작하는 거 읽음 C 아닌거 버림
   2 - access("JOB"='MANAGER') 매니저인거 먼저 읽고
   총: 테이블에서 4건 프래지던트까지 읽고 필터에서 3건 읽어서 조건에 맞는 1개를 사용자에게 반환
 
Note
-----
   - dynamic sampling used for this statement (level=2);
   
-- pt85
CREATE INDEX idx_n_emp_03 ON emp (job, ename); -- INDEX 만듬

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 4225125015
 
--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    87 |     2   (0)| 00:00:01 | -- 전에서 달라진거 여기에서 필터가 없어진 것 
|*  2 |   INDEX RANGE SCAN          | IDX_N_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')

Note
-----
   - dynamic sampling used for this statement (level=2);
   
SELECT job, ename, rowid
FROM emp
ORDER BY job, ename;

ANALYST	FORD	AAAE5dAAFAAAACLAAM
ANALYST	SCOTT	AAAE5dAAFAAAACLAAH
CLERK	ADAMS	AAAE5dAAFAAAACLAAK
CLERK	JAMES	AAAE5dAAFAAAACLAAL
CLERK	MILLER	AAAE5dAAFAAAACLAAN
CLERK	SMITH	AAAE5dAAFAAAACNAAA
MANAGER	BLAKE	AAAE5dAAFAAAACLAAF
MANAGER	CLARK	AAAE5dAAFAAAACLAAG
MANAGER	JONES	AAAE5dAAFAAAACLAAD
PRESIDENT	KING	AAAE5dAAFAAAACLAAI
SALESMAN	ALLEN	AAAE5dAAFAAAACLAAB
SALESMAN	MARTIN	AAAE5dAAFAAAACLAAE
SALESMAN	TURNER	AAAE5dAAFAAAACLAAJ
SALESMAN	WARD	AAAE5dAAFAAAACLAAC;

SELECT *
FROM emp 
WHERE job = 'MANAGER' AND ename LIKE 'C%';

1. table full
2. idx1 : empno
3. idx2 : job
4. idx3 : job + ename
5. idx4 : ename + job;

CREATE INDEX idx_n_emp_04 ON emp(ename, job);

-- 인덱스 모양
SELECT ename, job, rowid
FROM emp
ORDER BY ename, job;


3 번째 인덱스를 지우자
3, 4번째 인덱스가 컬럼 구성이 동일하고 순서만 다르기 때문에 4번을 못볼수 있기 때문에 3번을 지운다
DROP INDEX idx_n_emp_03;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE (dbms_xplan.display);

Plan hash value: 1173072073
 
--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_N_EMP_04 |     1 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("ENAME" LIKE 'C%' AND "JOB"='MANAGER') --이거 먼저 실행 2건 읽을 거임 non unique 이기 때문에 FORD 까지 읽을 거임
       filter("JOB"='MANAGER' AND "ENAME" LIKE 'C%') -- 다음 이거 실행
 
Note
-----
   - dynamic sampling used for this statement (level=2);

emp 테이블을 생각해봄 - table full, pk_emp
dept - table full, pk_dept(deptno)
총 4가지 방법(가능한 순서는 생각하지 않고 쌍만 생각한 것)
순서까지 들어가니까 총 8가지 방법
(emp - table full, dept - table full)
(dept - table full,emp - table full)

(emp - table full, dept - pk_emp)
(dept - pk_emp,emp - table full)

(emp - pk_emp, dept - table full)
(dept - table full, emp - pk_emp)

(emp - pk_emp, dept - pk_emp)
(dept - pk_emp, emp - pk_emp)

 1. 순서

 2 개의 테이블 조인
 각각의 테이블에 인덱스 5개씩 잇다면
 한 테이블에 접근 전략 : 6
 36 * 2 = 72
 
 ORACLE - 실시간 응답 : OLTP (ON LINE TRANSACTION PROCESSING) <-- 우리는 이거 배움
         전체 처리시간 : OLAP (ON LINE ANALYSIS PROCESSING) - 복합한 쿼리의 실행 계획을 세우는데 (30~1H)걸림 사람이 세우는게 아니라 최적으로 계획을 세우기 때문에 모든 경우의 수를 생각해서 실행함

 emp 부터 읽을까? dept부터 읽을까?;

EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.empno = 7788;

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 3070176698
 
----------------------------------------------------------------------------------------------
| Id  | Operation                     | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |              |     1 |    63 |     3   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                 |              |       |       |            |          |
|   2 |   NESTED LOOPS                |              |     1 |    63 |     3   (0)| 00:00:01 |
|   3 |    TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    33 |     2   (0)| 00:00:01 |
|*  4 |     INDEX RANGE SCAN          | IDX_N_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
|*  5 |    INDEX UNIQUE SCAN          | PK_DEPT      |     1 |       |     0   (0)| 00:00:01 |
|   6 |   TABLE ACCESS BY INDEX ROWID | DEPT         |     1 |    30 |     1   (0)| 00:00:01 |
----------------------------------------------------------------------------------------------
                    실행 순서  4 - 3 - 5 - 2 - 6  - 1 (자식을 생각하면) 2번의 자식이 3,5번이고 위에 있는애 부터 읽음
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("EMP"."EMPNO"=7788)
   5 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")
 
Note
-----
   - dynamic sampling used for this statement (level=2);
   
   
-- 실습 idx1
CREATE TABLE dept_test2 AS SELECT * FROM dept WHERE 1 = 1;
SELECT *
FROM dept_test2;

 CATS 
 제약조건 복사가 NOT NULL만 된다.
 백업이나 테스트용으로;


CREATE UNIQUE INDEX idx_dept_u_test2_01 ON dept_test2 (deptno);
CREATE INDEX idx_dept_test2_02 ON dept_test2(dname);
CREATE INDEX idx_dept_test2_03 ON dept_test2 (deptno, dname);

DROP INDEX idx_dept_u_test2_01;
DROP INDEX idx_dept_test2_02;
DROP INDEX idx_dept_test2_03;

-- 실습 idx3
access pattern
--empno(=) 지울수도 있음

ename(=) -- 만들고

depno(=), empno(LIKE 직원번호%) --> empno, deptno 선두컬럼이 empno가 선두라서 없으면 지우게 될것이고 첫번째 empno(=)가 필요없음
deptno(=), sal(BETWEEN)

deptno (=) / mgr 동반하면 유리,
-- empno(=) -- 위에 있으니까 지워도 될거 같음

deptno, hiredate 가 인덱스 존재하면 유리

deptno, sal, mgr, hiredate로 만들듯 확신이 없으니까

CREATE UNIQUE INDEX idx_u_emp_01 ON emp (empno);
CREATE INDEX idx_n_emp_02 ON emp(ename, deptno);
CREATE UNIQUE INDEX idx_u_dept_01 ON dept (deptno, sal, mgr, hiredate);

각각 만드는 것도 방법임;



--EXPLAIN PLAN for
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno = :deptno
AND emp.empno LIKE :empno || '%';

SELECT B.*
FROM EMP A, EMP B
WHERE A.mgr = B.empno
AND A.deptno = deptno;

SELECT *
FROM table(dbms_xplan.display);


select *
from dept;
select *
from emp;


