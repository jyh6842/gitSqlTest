-- date �ǽ� fn1
SELECT TO_DATE('20191231','YYYYMMDD')
FROM dual;

SELECT TO_DATE('20191231','YYYYMMDD') - 5
FROM dual;

SELECT SYSDATE
FROM dual;

SELECT SYSDATE - 3
FROM dual;

SELECT TO_DATE('20191231','YYYY/MM/DD') AS lastday, TO_DATE('20191231','YYYY/MM/DD') - 5 AS lastday_before5, SYSDATE AS now, SYSDATE - 3 AS now_before3
FROM dual;

-- DATE : TO_DATE ���ڿ� -> ��¥(DATE)
--      : TO_CHAR -> ���ڿ�(��¥ ���� ����)
-- JAVA������ ��¥ ������ ��ҹ��ڸ� ������. (MM / mm -> ��/��)
-- �ְ�����( 1~7 ) : �Ͽ��� 1, ������ 2, .... , ����� 7
-- ���� IW : ISO ǥ��  --> �ش����� ������� �������� ������ ����
--          2019/12/31 ȭ���� --> 2020/01/02(�����) --> �׷��� ������ 1������ ����
SELECT TO_CHAR(SYSDATE, 'YYYY-MM/DD HH24:MI:SS'),
        TO_CHAR(SYSDATE, 'D'),       --������ 2020/01/29 (��) --> 4
        TO_CHAR(SYSDATE, 'IW'),
        TO_CHAR(TO_DATE('2019/12/31', 'YYYY/MM/DD'), 'IW') -- 1�� ? �ش� ���� ������� ����
FROM dual;

-- emp ���̺��� hiredate(�Ի�����) Į���� ����� ��:��:��
SELECT ename, hiredate,
        TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS'),
        TO_CHAR(hiredate + 1, 'YYYY-MM-DD HH24:MI:SS'),
        TO_CHAR(hiredate + 1/24, 'YYYY-MM-DD HH24:MI:SS'),
        -- hiredate �� 30���� ���Ͽ� TO_CHAR�� ǥ��
        -- 60�� ���� ������ �ǹ� �ִ� '��'��� ���� �� �� �ִ�.
        TO_CHAR(hiredate + (1/24/60)*30, 'YYYY-MM-DD HH24:MI:SS')        
FROM emp;

-- date �ǽ� fn2
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD') AS DT_DASH,
        TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS') AS DT_DASH_WITH_TIME,
        TO_CHAR(SYSDATE, 'DD/MM/YYYY') AS DT_DD_MM_YYYY
FROM dual;


-- MONTHS_BETWEEN(DATE, DATE)
-- ���ڷ� ���� �� ��¥ ������ �������� ����
SELECT ename, hiredate,
    MONTHS_BETWEEN(sysdate, hiredate),
    MONTHS_BETWEEN(TO_DATE('2020-01-27', 'YYYY-MM-DD'), hiredate), 469/12
FROM emp
WHERE ename = 'SMITH';

-- ADD_MONTHS(DATE, ����-������ ������)
SELECT ADD_MONTHS(SYSDATE,5), -- 2020/01/29 -->2020/06/29
        ADD_MONTHS(SYSDATE,-5) -- 2020/01/29 -->2019/08/29
FROM dual;

-- NEXT_DAY(DATE, �ְ����� ex: NEXT_DAY(SYSDATE, 5) --> ex) SYSDATE ���� ó�� �����ϴ� �ְ����� 5(��)�� �ش��ϴ� ����
                                                        -- SYSDATE 2020/01/29(��) ���� ó�� �����ϴ� 5(��)���� --> 2020/01/30(��)
SELECT NEXT_DAY(SYSDATE, 5)
FROM dual;

--LAST_DAY(DATE) DATE ���� ���� ������ ���ڸ� ����
SELECT LAST_DAY(SYSDATE) -- SYSDATE 2020/01/29 --> 2020/01/31
FROM dual;

-- LAST_DAY�� ���� ���ڷ� ���� date�� ���� ���� ������ ���ڸ� ���Ҽ� �ִµ�
-- date�� ù��° ���ڴ� ��� ���ұ�?
SELECT SYSDATE,
        LAST_DAY(SYSDATE),
        ADD_MONTHS(LAST_DAY(SYSDATE)+1,-1), -- ������ ������ ��¥ �ϳ� ���ϰ� 1�� ����
        TO_DATE('01','DD'), --���� ������ ��¥�� 1�Ϸ� �ʱ�ȭ
        TO_DATE(TO_CHAR(SYSDATE,'YYYY-MM') || '-01', 'YYYY-MM-DD')   
FROM dual;        

-- hiredate ���� �̿��Ͽ� �ش� ���� ù��° ���ڷ� ǥ��
SELECT ename, hiredate,
        ADD_MONTHS(LAST_DAY(hiredate)+1,-1),
        TO_DATE(TO_CHAR(hiredate,'YYYY-MM') || '-01', 'YYYY-MM-DD') -- '-01' �ڿ� ���ڿ� ���̱�
FROM emp;


-- empno �� NUMBER Ÿ��, ���ڴ� ���ڿ�
-- Ÿ���� ���� �ʱ� ������ ������ ����ȯ�� �Ͼ
-- ���̺� Į���� Ÿ�Կ� �°� �ùٸ� ���� ���� �ִ°� �߿�
SELECT *
FROM emp
WHERE empno = '7369';

-- hiredate�� ��� DATE Ÿ��, ���ڴ� ���ڿ��� �־����� ������ ������ ����ȯ�� �߻�
-- ��¥ ���ڿ����� ���� Ÿ�̕��� ��������� ����ϴ� ���� �߿�
SELECT *
FROM emp
WHERE hiredate = '1980/12/17';
--> �̷��� �ٲ�
SELECT *
FROM emp
WHERE hiredate = TO_DATE('1980/12/17', 'YYYY/MM/DD');

-- �����ؼ� �����ϰ� (ȭ�鿡 �Ⱥ���)
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7369';

-- �����ؼ� �����ϰ�
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369'; -- <-- ��������� ���� ��ȯ �غ���

-- ȭ�鿡 ���̰�
SELECT *
FROM TABLE(dbms_xplan.display); --> �鿩 ���Ⱑ �Ǿ� ������ ���� �ִ� �ִ� �θ� �鿩 ���� �Ǿ� �ִ� ���� �ڽ�

-- ���ڸ� ���ڿ��� �����ϴ� ��� : ����
-- õ���� ������
-- 1000�̶�� ���ڸ� 
-- �ѱ� : 1,000.50
-- ���� : 1,000,50

-- emp sal �÷�(NUMBER Ÿ��)�� ������
-- 9 : ����
-- 0 : ���� �ڸ� ����(0 ǥ��)
-- L : ��ȭ ����
SELECT ename, sal, TO_CHAR(sal, '9,999') -- �ڸ��� 
FROM emp;

-- NULL�� ���� ������ ����� �׻� NULL
-- emp ���̺� sal �÷����� null �����Ͱ� �������� ���� (14���� �����Ϳ� ����)
-- emp ���̺� comm �÷����� null �����Ͱ� ���� (14���� �����Ϳ� ����)
-- sal + comm --> comm�� null�� �࿡ ���ؼ��� ��� null�� ���´�.
-- �䱸������ comm�� null�̸� sal �÷��� ���� ��ȸ
-- �䱸������ ���� ��Ű�� ���Ѵ�. -> SW������ (����)

-- NVL(Ÿ��, ��ü��)
-- Ÿ���� ���� NULL�̸� ��ü���� ��ȯ�ϰ�
-- Ÿ���� ���� NULL�� �ƴϸ� Ÿ�� ���� ��ȯ

-- if(Ÿ�� == null )
--      return ��ü��;
-- else
--      return Ÿ��;

SELECT ename, sal, comm ,NVL(comm, 0), 
        sal + comm, -- null �� ������ ���ص� null
        sal + NVL(comm, 0), -- null ���� �ƴϰ� Ÿ�ٰ� ��ȯ
        NVL( sal+ comm, 0) -- ���ʹ� �ٸ�
FROM emp;

-- NVL2(expr1, expr2, expr3)
-- if(expr1 != null)
--      return expr2;
-- else
--      return expr3;
SELECT ename, sal, comm, NVL2(comm, 10000, 0)
FROM emp;

-- NULLIF(expr1, expr2)
-- if(expr1 == expr2)
--      return null;
-- else
--      return expr1;

-- sal 1250�� ����� null�� ���� 1250�� �ƴ� ����� sal�� ����
SELECT ename, sal, comm, NULLIF(sal, 1250)
FROM emp;

-- ��������
-- COALESCE �����߿� ���� ó������ ������ NULL�� �ƴ� ���ڸ� ��ȯ
-- COALESCE(expr1, expr2 .....)
-- if(expr1 != null)
--      return expr1;
-- else
--       return COALESCE(expr1, expr2 .....);

-- COALESCE(comm, sal) : comm�� null�� �ƴϸ� comm
--                      comm�� null �̸� sal(��, sal �÷��� ���� NULL�� �ƴҶ�)

SELECT ename, sal, comm, COALESCE(comm, sal)
FROM emp;

-- null �ǽ� fn4
SELECT empno, ename, mgr, COALESCE(mgr, 9999) mgr_N, COALESCE(mgr, 9999) mgr_N_1, COALESCE(mgr, 9999) mgr_N_2
FROM emp;

-- null �ǽ� fn5
SELECT userid, usernm, reg_dt, COALESCE(reg_dt, SYSDATE) AS n_reg_dt
FROM users
WHERE userid != 'brown';

-- CONDITION : ������
-- CASE : JAVA�� if - else if - else
-- CASE
--      WHEN ����1 THEN ���ϰ�1
--      WHEN ����2 THEN ���ϰ�2
--      ELSE �⺻��
-- END
-- emp ���̺��� job �÷��� ���� SALESMAN �̸� SAL * 1.05 ����
--                              MANAGER �̸� SAL * 1.1 ����
--                              PRESIDENT �̸� SAL * 1.2 ����
--                              �׹��� ������� SAL�� ����

SELECT ename, job, sal,
        CASE
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN sal * 1.1
            WHEN job = 'PRESIDENT' THEN sal * 1.2
            ELSE sal
        END AS bonus_sal
FROM emp;

-- DECODE �Լ� : CASE���� ����
-- (�ٸ��� CASE �� : WHEN ���� ���� �񱳰� �����Ӵ�
--      DECODE �Լ� : �ϳ��� ���� ���ؼ� = �񱳸� ���
-- DECODE �Լ� : ��������(������ ������ ��Ȳ�� ���� �þ ���� ����)
-- DECODE(collexpr, ù��° ���ڿ� ���� ��1, ù��° ���ڿ� �ι�° ���ڰ� ���� ��� ��ȯ ��,
--                  ù��° ���ڿ� ���� ��2, ù��° ���ڿ� �׹�° ���ڰ� ���� ��� ��ȯ �� ...
--                  option - else ���������� ��ȯ�� �⺻��)   -- else �Ⱦ��� �� �������� �� ���� else ��

-- emp ���̺��� job �÷��� ���� SALESMAN �̸� SAL * 1.05 ����
--                              MANAGER �̸� SAL * 1.1 ����
--                              PRESIDENT �̸� SAL * 1.2 ����
--                              �׹��� ������� SAL�� ����
SELECT ename, job, sal,
        DECODE(job, 'SALESMAN',sal * 1.05,
                    'MANAGER', sal * 1.1,
                    'PRESIDENT', sal * 1.2, sal) bonus_sal
FROM emp;
            
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

