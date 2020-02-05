-- 1. SQL Ȱ�� PART1 ;

-- CROSS JOIN
-- �����ϴ� �� ���̺��� ���� ������ �����Ǵ� ���
-- ������ ��� ���տ� ���� ����(����)�� �õ�
-- dept(4��), emp(14��)�� CROSS JOIN�� ��� 4*14 = 5��

-- dept ���̺�� emp ���̺��� ������ �ϱ� ���� FROM ���� �ΰ��� ���̺��� ��� WHERE ���� �� ���̺��� ���� ������ ����
-- ������ ��� ������ ����

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
-- SUBQUERY : �����ȿ� �ٸ� ������ �� �ִ� ���
-- SUBQUERY �� ���� ��ġ�� ���� 3������ �з�
    -- SELECT �� : SCALAR SUBQURY : �ϳ��� ��, �ϳ��� �÷��� �����ؾ� ������ �߻����� ����
    -- FROM �� : INLINE - VIEW (���� ����� ��) <-> VIEW
    -- WHERE �� : SUBQUERY QUERY

-- ���ϰ��� �ϴ� ��
SMITH�� ���� �μ��� ���ϴ� �������� ������ ��ȸ
1. SMITH�� ���ϴ� �μ� ��ȣ�� ���Ѵ�.
2. 1������ ���� �μ� ��ȣ�� ���ϴ� ������ ������ ��Ⱥ�Ѵ�.

1.;
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

2.; 1������ ���� �μ���ȣ�� �̿��Ͽ� �ش� �μ��� ���ϴ� ���� ������ ��ȸ;
SELECT *
FROM emp
WHERE deptno = 20;

-- SUBQUERY�� �̿��ϸ� �ΰ��� ������ ���ÿ� �ϳ��� SQL�� ������ ����

SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');
                
-- �ǽ� sub1
-- ��� �޿����� ���� �޿��� �޴� ������ ���� ��ȸ�ϼ���
1. ��� �޿� ���ϱ�
2. ���� ��� �޿����� ���� �޿��� �޴� ���
SELECT *
FROM emp;

SELECT AVG(sal)
FROM emp;

SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT AVG(sal)
            FROM emp);
            
-- �ǽ� sub2
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
            FROM emp);

-- ������ ������
-- IN
-- ANY [Ȱ�뵵�� �ټ� ������] : ���������� �������� �� ���̶� ������ ������ ��
-- ALL [Ȱ�뵵�� �ټ� ������] : ���������� �������� ��� �࿡ ���� ������ ������ ��;

-- �ǽ� sub3
-- SMITH�� ���ϴ� �μ��� ��� ������ ��ȸ
-- SMITH�� WARD ������ ���ϴ� �μ��� ��� ������ ��ȸ

SELECT *
FROM emp;

SELECT deptno
FROM emp
WHERE ename IN ('SMITH', 'WARD');

-- ���������� ����� ���� ���� ���� = �����ڸ� ������� ���Ѵ�.
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'))

-- SMITH, WARD ����� �޿����� �޿��� ���� ������ ��ȸ(SMITH, WARD �� �޿��� �ƹ��ų�)
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


-- SMITH, WARD ����� �޿����� �޿��� ���� ������ ��ȸ(SMITH, WARD �� �޿� 2���� ��ο� ���� ���� ��)
SMITH : 800
WARD : 1250

SELECT *
FROM emp
WHERE sal > ALL (SELECT sal
                 FROM emp
                 WHERE ename IN('SMITH', 'WARD'));
                 
-- IN, NOT IN�� NULL�� ���õ� ���� ����

-- ������ ������ ����� 7902 �̰ų� NULL
-- IN �����ڴ� OR �����ڷ� ġȯ ����
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE mgr IN (7902, null); --> �Ѱ� ���� 2�� ���;���

-- NULL �񱳴� = �����ڰ� �ƴ϶� IS NULL�� �� �ؾ����� IN �����ڴ� = �� ����Ѵ�.
SELECT *
FROM emp
WHERE mgr = 7902 OR mgr = NULL;

-- empno NOT IN(7002, NULL) --> AND
-- ��� ��ȣ�� 7902�� �ƴϸ鼭 (AND) NULL�� �ƴ� ������

SELECT *
FROM emp 
WHERE empno NOT IN (7902, NULL); 

SELECT *
FROM emp 
WHERE empno != 7902 AND empno != NULL; -- AND �׸��� NULL�� ���� ������ �׻� �����̱� ������ ���� ������ ����

-- ���� ���
SELECT *
FROM emp 
WHERE empno != 7902 AND empno IS NOT NULL;

pairwise (������);
-- �������� ����� ���ÿ� ���� ��ų��;
-- (mgr, deptno)
-- (7698, 30)(7839, 10)
SELECT *
FROM emp
WHERE (mgr,deptno) IN  (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN(7499, 7782));
-- non-pairwise �� �������� ���ÿ� ������Ű�� �ʴ� ���·� �ۼ�
-- mgr ���� 7698 �̰ų� 7839�̸鼭
-- deptno�� 10���̰ų� 30���� ����
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

��Į�� �������� : SELECT  ���� ���, 1���� ROW, 1���� COL�� ��ȸ�ϴ� ����
��Į�� ���������� MAIN ������ �÷��� ����ϴ°� �����ϴ�.

SELECT SYSDATE
FROM dual;

SELECT SYSDATE, dept.*
FROM dept;

SELECT (SELECT SYSDATE
        FROM dual), dept.*
FROM dept;

SELECT empno, ename, deptno, (SELECT dname FROM dept WHERE deptno = emp.deptno) dname--(�μ����� �������� ���������� �ۼ��ض�)
FROM emp;

-- INLINE VIEW : FROM ���� ����Ǵ� ��������;

-- MAIN ������ �÷��� SUBQUERY ���� ��� �ϴ��� ������ ���� �з�
-- ��� �� ��� : correlated subquery(��ȣ ���� ����), ���������� �ܵ����� �����ϴ°� �Ұ���, ���������� �÷��� ����ϱ� ����
--                ��������� ������ �ִ� (main == > sub)
-- ������� ���� ��� : non-correlated subquery(���ȣ ���� ��������), ���������� �ܵ����� �����ϴ°� ����
--                    ��������� ������ ���� �ʴ�. (main ==> sub, sub ==> main)
-- ��� ������ �޿� ��պ��� �޿��� ���� ����� ��ȸ
SELECT *
FROM emp 
WHERE sal > (SELECT AVG(sal)
            FROM emp);
-- pt267            
-- ������ ���� �μ��� �޿� ��պ��� �޿��� ���� ����� ��ȸ;


SELECT AVG(sal)
FROM emp
WHERE deptno = 30;
            
SELECT *
FROM emp m
WHERE sal > (SELECT AVG(sal)
            FROM emp s
            WHERE s.deptno = m.deptno);
            
-- ���� ������ ������ �̿��ؼ� Ǯ���
-- 1. ���� ���̺� ����
--  emp, �μ��� �޿� ��� (inline view)

SELECT emp.* -- emp.ename, sal, emp.deptno, dept_sal.* --> emp.*�� ��ü ����
FROM emp, (SELECT deptno, ROUND(AVG(sal)) avg_sal
            FROM emp
            GROUP BY deptno) dept_sal
WHERE emp.deptno = dept_sal.deptno
AND emp.sal > dept_sal.avg_sal;

-- sub4
-- ������ �߰�
 INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
 
 DELETE dept
 WHERE deptno = 99;
 
 ROLLBACK; -- Ʈ����� ���
 COMMIT; -- Ʈ����� Ȯ�� -- Ŀ���ϸ� rollback �ص� ���ư��� ����
 
 select *
 from dept;
 
 
 select *
 from emp;
 
 select *
 from dept
 where deptno not in (SELECT deptno from emp);
 