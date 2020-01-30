-- emp ���̺��� job �÷��� ���� SALESMAN �̸鼭 sal�� 1400���� ũ�� SAL * 1.05 ����
--                              SALESMAN �̸鼭 sal�� 1400���� ������ SAL * 1.1 ����
--                              MANAGER �̸� SAL * 1.1 ����
--                              PRESIDENT �̸� SAL * 1.2 ����
--                              �׹��� ������� SAL�� ����

-- 1. CASE �� �̿��ؼ�
-- 2. DECODE, case�� ȥ���ؼ�

-- 1. 
SELECT ename, job, sal,
    CASE
        WHEN job = 'SALESMAN' AND sal > 1400 THEN sal * 1.05
        WHEN job = 'SALESMAN' AND sal < 1400 THEN sal * 1.1
        WHEN job = 'MANAGER' THEN sal * 1.1
        WHEN job = 'PRESIDENT' THEN sal * 1.2
        ELSE sal
    END bonus_sal
FROM emp;


--2. 
SELECT ename, job, sal,
        CASE
            WHEN  job = 'SALESMAN' AND sal > 1400 THEN sal * 1.05
            WHEN job = 'SALESMAN' AND sal < 1400 THEN sal * 1.1
            ELSE DECODE(job,'MANAGER', sal * 1.1,
                    'PRESIDENT', sal * 1.2, sal) -- else �Ⱦ��� �� �������� �� ���� else ��
        END bonus_sal
FROM emp;

--2. DECODE �� ���� ����ϱ� (DECODE �ȿ� CASE�� DECODE ������ ��ø�� �����ϴ�.)
SELECT ename, job, sal,
        DECODE(job, 'SALESMAN', CASE
                                    WHEN sal > 1400 THEN sal * 1.05
                                    WHEN sal < 1400 THEN sal * 1.1
                                END,
                    'MANAGER', sal * 1.1,
                    'PRESIDENT', sal * 1.2,
                    sal) bonus_sal
FROM emp;

-- 1. SQL Ȱ�� PART1
-- condition �ǽ� cond1
-- DECODE��
SELECT empno, ename, 
        DECODE(deptno, 10, 'ACCOUNTING',
                        20, 'RESEARCH',
                        30, 'SALES',
                        40, 'OPERATIONS',
                        'DDIT') dname
FROM emp;
-- CASE
SELECT empno, ename, 
        CASE
            WHEN deptno=10 THEN 'ACCOUNTIN'
            WHEN deptno=20 THEN 'RESEARCH'
            WHEN deptno=30 THEN 'SALES'
            WHEN deptno=40 THEN 'OPERATIONS'
            ELSE 'DDIT'
        END dname         
FROM emp;

-- condition �ǽ� cond2
-- ���س⵵�� ¦���̸�
--    �Ի�⵵�� ¦���� �� �ǰ����� �����
--    �Ի�⵵�� Ȧ���� �� �ǰ����� ������
-- ���س⵵�� Ȧ���̸�
--   �Ի�⵵�� ¦���� �� �ǰ����� ������
--   �Ի�⵵�� Ȧ���� �� �ǰ����� �����
-- ¦�� -> 2�� �������� �� ������ 0
-- Ȧ�� -> 2�� �������� �� ������ 1

SELECT empno, ename, hiredate, MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')),2) sysdate_mod,
    CASE
        WHEN MOD(TO_CHAR(hiredate, 'YYYY'), 2) = 0 
            AND 
             MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) = 0 THEN '�˰����� �����'
        ELSE '�˰����� ������'
    END AS contact_to_doctor
FROM emp;

SELECT empno, ename, hiredate,
    DECODE( MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')),2), MOD(TO_NUMBER(TO_CHAR(hiredate, 'YYYY')),2), '�����',
            '������')
FROM emp;

-- condition �ǽ� cond3 (����)
SELECT userid, usernm, alias, reg_dt,
    CASE
        WHEN (MOD(TO_NUMBER(TO_CHAR(reg_dt, 'YYYY')),2 )) = 0 AND (MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')),2 ))=0 THEN '�����'
        WHEN (MOD(TO_NUMBER(TO_CHAR(reg_dt, 'YYYY')),2 )) = 1 AND (MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')),2 ))=1 THEN '������'        
    END contacttoddctor
FROM users;

-- pt168
SELECT *
FROM emp;

-- GROUP BY ���� ���� ����
-- �μ���ȣ�� ���� ROW ���� ���� ��� : GROUP BY deptno
-- �������� ���� ROW ���� ���� ��� : GROUP BY job
-- MGR�� ���� �������� ���� ROW ���� ���� ��� : GROUP BY mgr, job

-- �׷��Լ��� ����
-- SUM : �հ�
-- COUNT : ���� - NULL ���� �ƴ� ROW�� ���� NULL�� ���õǾ� �������� ����
-- MAX : �ִ밪
-- MIN : �ּҰ�
-- AVG : ���

-- �׷��Լ��� Ư¡
-- �ش� �÷��� NULL���� ���� ROW �� ������ ��� �ش� ���� �����ϰ� ����Ѵ�. (NULL ������ ����� null)

-- GROUP BY ���� ���� �÷� �̿��� �ٸ� �÷��� SELECT���� ǥ���Ǹ� ���� ** �߿� **

-- �μ��� �޿� �� 
SELECT deptno, ename,
        SUM(sal) sum_sal, MAX(sal) max_sal, MIN(sal) , ROUND(AVG(sal),2) , COUNT(sal) 
FROM emp
GROUP BY deptno, ename;

-- GROUP BY ���� ���� ���¿��� �׷��Լ��� ����� ���
-- --> ��ü���� �ϳ��� ������ ���´�.
SELECT -- ���� �ؾ��� -- deptno, ename,
        SUM(sal) sum_sal, MAX(sal) max_sal, MIN(sal) , ROUND(AVG(sal),2) , 
        COUNT(sal), -- sal �÷��� ���� null�� �ƴ� row�� ����
        COUNT(comm), -- COMM �÷��� ���� null�� �ƴ� row�� ����
        COUNT(*) -- ����� �����Ͱ� �ִ���
FROM emp;

-- GROUP BY�� ������ empno�̸� ������� ���??  -- 14��

SELECT -- ���� �ؾ��� -- deptno, ename,
        SUM(sal) sum_sal, MAX(sal) max_sal, MIN(sal) , ROUND(AVG(sal),2) , 
        COUNT(sal), -- sal �÷��� ���� null�� �ƴ� row�� ����
        COUNT(comm), -- COMM �÷��� ���� null�� �ƴ� row�� ����
        COUNT(*) -- ����� �����Ͱ� �ִ���
FROM emp
GROUP BY empno;


-- GROUP BY�� ������ empno�̸� ������� ���??  -- 14��
-- �׷�ȭ�� ���þ��� ������ ���ڿ�, �Լ�, ���ڵ��� SELECT���� ������ ���� ����
SELECT -- ���� �ؾ��� -- deptno, ename,
        1, SUM(sal) sum_sal, 'ACCOUNTING', MAX(sal) max_sal, MIN(sal) , ROUND(AVG(sal),2) , 
        COUNT(sal), -- sal �÷��� ���� null�� �ƴ� row�� ����
        COUNT(comm), -- COMM �÷��� ���� null�� �ƴ� row�� ����
        COUNT(*) -- ����� �����Ͱ� �ִ���
FROM emp
GROUP BY empno;

-- SINGLE ROW FUNCTION�� ��� WHERE ������ ����ϴ� ���� �����ϳ�
-- MULTI ROW FUNCTION(GROUP FUNCTION)�� ��� WHERE ������ ����ϴ� ���� �Ұ��� �ϰ�
-- HAVING ������ ������ ����ϳ�.

-- �μ��� �޿� �� ��ȸ, �� �޿����� 9000 �̻��� row�� ��ȸ
-- deptno, �޿���
SELECT deptno, SUM(sal) sum_sal
FROM  emp
GROUP BY deptno
HAVING SUM(sal) > 9000;

-- group function �ǽ� grp1
SELECT MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, 
        COUNT(sal) count_sal, -- ���� �� �޿��� �ִ� ������ �� (null ����)
        COUNT(mgr), -- ������ ����ڰ� �մ� ������ ��(null ����)
        COUNT(*) count_all -- ��ü ������ ��
FROM emp;

-- group function �ǽ� grp2
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(avg(sal),2) avg_sal, SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY deptno;

-- group function �ǽ� grp3
SELECT 
        (CASE
            WHEN deptno=10 THEN 'ACCOUNTING'
            WHEN deptno=20 THEN 'RESEARCH'
            WHEN deptno=30 THEN 'SALES'
        END) dname,
        MAX(sal) max_sal, MIN(sal) min_sal, ROUND(avg(sal),2) avg_sal, SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY (CASE
            WHEN deptno=10 THEN 'ACCOUNTING'
            WHEN deptno=20 THEN 'RESEARCH'
            WHEN deptno=30 THEN 'SALES'
        END) 
ORDER BY (CASE
            WHEN deptno=10 THEN 'ACCOUNTING'
            WHEN deptno=20 THEN 'RESEARCH'
            WHEN deptno=30 THEN 'SALES'
        END);
        
SELECT  DECODE(deptno, 10, 'ACCOUNTING',  20, 'RESEARCH', 30, 'SALES'),
        MAX(sal) max_sal, MIN(sal) min_sal, ROUND(avg(sal),2) avg_sal, SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY DECODE(deptno, 10, 'ACCOUNTING',  20, 'RESEARCH', 30, 'SALES')
ORDER BY DECODE(deptno, 10, 'ACCOUNTING',  20, 'RESEARCH', 30, 'SALES');


-- group function �ǽ� grp4
-- ORACLE 9i ���������� GROUP BY ���� ����� �÷����� ������ ����
-- ORACLE 10G ���� ���ʹ� GROUP BY ���� ����� �÷����� ������ ���� ���� �ʴ´�. (GROUP BY ������ �ӵ� up)
SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm, COUNT(hiredate) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM');

-- group function �ǽ� grp5
SELECT TO_CHAR(hiredate, 'YYYY'), COUNT(hiredate)
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY');

-- group function �ǽ� grp6

SELECT COUNT(deptno) cnt
FROM dept;


-- group function �ǽ� grp7
-- �μ��� ���� �ִ��� �ϴ� Ȯ��
select * from emp;

SELECT COUNT(*) cnt
FROM
    (SELECT deptno
    FROM emp
    GROUP BY deptno)
;

