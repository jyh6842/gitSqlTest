1. table full
2. idx1 : empno
3. idx2 : job; <-- �̰ɷ� ������

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
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP         |     1 |    87 |     2   (0)| 00:00:01 | - filter("ENAME" LIKE 'C%') C�� �����ϴ� �� ���� C �ƴѰ� ���� �̰� ����
|*  2 |   INDEX RANGE SCAN          | IDX_N_EMP02 |     1 |       |     1   (0)| 00:00:01 |
-------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%') C�� �����ϴ� �� ���� C �ƴѰ� ����
   2 - access("JOB"='MANAGER') �Ŵ����ΰ� ���� �а�
   ��: ���̺��� 4�� ��������Ʈ���� �а� ���Ϳ��� 3�� �о ���ǿ� �´� 1���� ����ڿ��� ��ȯ
 
Note
-----
   - dynamic sampling used for this statement (level=2);
   
-- pt85
CREATE INDEX idx_n_emp_03 ON emp (job, ename); -- INDEX ����

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
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    87 |     2   (0)| 00:00:01 | -- ������ �޶����� ���⿡�� ���Ͱ� ������ �� 
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

-- �ε��� ���
SELECT ename, job, rowid
FROM emp
ORDER BY ename, job;


3 ��° �ε����� ������
3, 4��° �ε����� �÷� ������ �����ϰ� ������ �ٸ��� ������ 4���� ������ �ֱ� ������ 3���� �����
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
 
   2 - access("ENAME" LIKE 'C%' AND "JOB"='MANAGER') --�̰� ���� ���� 2�� ���� ���� non unique �̱� ������ FORD ���� ���� ����
       filter("JOB"='MANAGER' AND "ENAME" LIKE 'C%') -- ���� �̰� ����
 
Note
-----
   - dynamic sampling used for this statement (level=2);

emp ���̺��� �����غ� - table full, pk_emp
dept - table full, pk_dept(deptno)
�� 4���� ���(������ ������ �������� �ʰ� �ָ� ������ ��)
�������� ���ϱ� �� 8���� ���
(emp - table full, dept - table full)
(dept - table full,emp - table full)

(emp - table full, dept - pk_emp)
(dept - pk_emp,emp - table full)

(emp - pk_emp, dept - table full)
(dept - table full, emp - pk_emp)

(emp - pk_emp, dept - pk_emp)
(dept - pk_emp, emp - pk_emp)

 1. ����

 2 ���� ���̺� ����
 ������ ���̺� �ε��� 5���� �մٸ�
 �� ���̺� ���� ���� : 6
 36 * 2 = 72
 
 ORACLE - �ǽð� ���� : OLTP (ON LINE TRANSACTION PROCESSING) <-- �츮�� �̰� ���
         ��ü ó���ð� : OLAP (ON LINE ANALYSIS PROCESSING) - ������ ������ ���� ��ȹ�� ����µ� (30~1H)�ɸ� ����� ����°� �ƴ϶� �������� ��ȹ�� ����� ������ ��� ����� ���� �����ؼ� ������

 emp ���� ������? dept���� ������?;

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
                    ���� ����  4 - 3 - 5 - 2 - 6  - 1 (�ڽ��� �����ϸ�) 2���� �ڽ��� 3,5���̰� ���� �ִ¾� ���� ����
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("EMP"."EMPNO"=7788)
   5 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")
 
Note
-----
   - dynamic sampling used for this statement (level=2);
   
   
-- �ǽ� idx1
CREATE TABLE dept_test2 AS SELECT * FROM dept WHERE 1 = 1;
SELECT *
FROM dept_test2;

 CATS 
 �������� ���簡 NOT NULL�� �ȴ�.
 ����̳� �׽�Ʈ������;


CREATE UNIQUE INDEX idx_dept_u_test2_01 ON dept_test2 (deptno);
CREATE INDEX idx_dept_test2_02 ON dept_test2(dname);
CREATE INDEX idx_dept_test2_03 ON dept_test2 (deptno, dname);

DROP INDEX idx_dept_u_test2_01;
DROP INDEX idx_dept_test2_02;
DROP INDEX idx_dept_test2_03;

-- �ǽ� idx3
access pattern
--empno(=) ������� ����

ename(=) -- �����

depno(=), empno(LIKE ������ȣ%) --> empno, deptno �����÷��� empno�� ���ζ� ������ ����� �ɰ��̰� ù��° empno(=)�� �ʿ����
deptno(=), sal(BETWEEN)

deptno (=) / mgr �����ϸ� ����,
-- empno(=) -- ���� �����ϱ� ������ �ɰ� ����

deptno, hiredate �� �ε��� �����ϸ� ����

deptno, sal, mgr, hiredate�� ����� Ȯ���� �����ϱ�

CREATE UNIQUE INDEX idx_u_emp_01 ON emp (empno);
CREATE INDEX idx_n_emp_02 ON emp(ename, deptno);
CREATE UNIQUE INDEX idx_u_dept_01 ON dept (deptno, sal, mgr, hiredate);

���� ����� �͵� �����;



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


