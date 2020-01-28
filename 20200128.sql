-- 1. SQL Ȱ�� PART1

-- ������ ���� (ORDER BY �ǽ� orderby4)

SELECT *
FROM emp
WHERE deptno IN(10,30) AND sal > 1500
ORDER BY ename DESC;

-- ������ ����
-- tool ���� �������ִ� ���� ��ȣ�� �÷����� ���� �� ������?

-- ROWNUM : ���ȣ�� ��Ÿ���� Į��
SELECT ROWNUM, empno, ename
FROM emp
WHERE deptno IN(10,30)
AND sal > 1500;

-- ROWNUM�� WHERE�������� ��� ����
-- ���� �ϴ� �� : ROWNUM = 1, ROWNUM <= 2   ---> ROWNUM=1, ROWNUM <= N
-- �������� �ʴ� �� : ROWNUM = 2, ROWNUM >= 2   ---> ROWNUM = N(N�� 1�� �ƴ� ����), ROWNUM >= N (N�� 1�� �ƴ� ����)
-- ROWNUM �̹� ���� �����Ϳ��ٰ� ������ �ο� 
-- ** ������1 : ���� ���� ������ ����( ROWNUM�� �ο����� ���� ��)�� ��ȸ�� ���� ����. (�̹� ���� �� �ֵ��� ����)
-- ** ������2 : ORDER BY ���� SELECT �� ���Ŀ� ����
-- ���̺� �ִ� ��� ���� ��ȭ�ϴ� ���� �ƴ϶� �츮�� ���ϴ� �������� �ش��ϴ� �� �����͸� ��ȸ�� �Ѵ�.( ex - �Խ��� )
-- ����¡ ó���� ������� : 1�������� �Ǽ�, ���� ����(�ֽż�, ������ ��, ....)
-- emp ���̺� �� row �Ǽ� : 14
-- ����¡�� 5���� ������ ��ȸ
-- *paeg size : 5, ���ı����� ename
-- 1 page : rn 1~5
-- 2 page : rn 6 ~ 10
-- 3 page : rn 11 ~ 15
-- n page : rn (n-1)*pageSize + 1 ~ n * pageSize

SELECT ROWNUM rn, empno, ename
FROM emp
ORDER BY ename;

-- ���ĵ� ����� ROWNUM�� �ο� �ϱ� ���ؼ��� IN LINE VIEW�� ����Ѵ�.
-- �������� : 1. ����, 2. ROWNU �ο�

-- SELECT *(�ƽ��׸���ũ)�� ����� ��� �ٸ� EXPRESSION�� ǥ�� �ϱ����ؼ��� 
-- ���̺��.* ���̺��Ī.*�� ǥ���ؾ��Ѵ�.
SELECT ROWNUM, emp.*
FROM emp;

SELECT ROWNUM, e.*
FROM emp e;


SELECT ROWNUM, a.*
FROM
    (SELECT empno, ename
    FROM emp -- �ϳ��� ���̺�
    ORDER BY ename) a; -- () �ϳ��� ���̺�� ����, ��ȸ��
    
 SELECT *
 FROM
    (SELECT ROWNUM rn, a.*
     FROM
        (SELECT empno, ename
        FROM emp -- �ϳ��� ���̺�
        ORDER BY ename) a)
WHERE rn BETWEEN (1-1)*5+1 AND 1*5;


SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM = 1;

SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM <= 2;

SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM = 2; -- �ȵ�

SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM >= 2; -- �ȵ�


-- �����÷� ROWNUM �ǽ� row_1
SELECT *
FROM 
    (SELECT ROWNUM rn , e.*
     FROM 
        (SELECT empno, ename
         FROM emp ) e)
WHERE rn BETWEEN 1 AND 10;

-- �����÷� ROWNUM �ǽ� row_2
SELECT *
FROM
    (SELECT ROWNUM rn, e.*    
    FROM
        (SELECT empno, ename
        FROM emp) e)
WHERE rn > 10;

-- �����÷� ROWNUM �ǽ� row_3
SELECT *
FROM
    (SELECT ROWNUM rn, e.*  
    FROM
        (SELECT empno, ename
        FROM emp
        ORDER BY ename) e)
WHERE rn BETWEEN (1-1)*10-1 AND 1*10;

SELECT *
FROM
    (SELECT ROWNUM rn, e.*  
    FROM
        (SELECT empno, ename
        FROM emp
        ORDER BY ename) e)
WHERE rn BETWEEN (:page-1)* :pageSize-1 AND 1* :pageSize; -- :������ (�ݷ�)(������)



-- DUAL ���̺� : �����Ϳ� ���� ����, �Լ��� �׽�Ʈ �غ� ��������
SELECT *
FROM dual;

SELECT LENGTH('TEST')
FROM dual;

-- ���ڿ� ��ҹ��� : LOWR, UPPER, INITCAP
SELECT LOWER('Hello, world!'), UPPER('Hello, world!'), INITCAP('Hello, world!')
FROM dual;

SELECT LOWER(ename), UPPER('Hello, world!'), INITCAP('Hello, world!')
FROM emp;

-- �Լ��� WHERE �������� ��� ����
-- ��� �̸��� SMITH�� ����� ��ȸ
SELECT *
FROM emp
WHERE ename = UPPER(:ename);

-- SQL �ۼ��� �Ʒ� ���´� ���� �ؾ��Ѵ�. 
-- ���̺��� Į���� �������� �ʴ� ���·� SQL�� �ۼ��Ѵ�.
-- SQL ĥ������ �˻� ��
SELECT *
FROM emp
WHERE LOWER(ename) = :ename;

SELECT CONCAT('Hello', ' World') CONCAT,
    SUBSTR('Hello, World', 1, 5) sub, -- 1~5
    LENGTH('Hello, World') len,
    INSTR('Hello, World', 'o') ins,
    INSTR('Hello, World', 'o', 6) ins2, -- 6��° ���Ŀ� ������ o �� ���° ����?
    LPAD('Hello, World', 15, '*') LP, -- ����� �����Ͽ� ä�� ũ��, ���� ��
    RPAD('Hello, World', 15, '*') RP,
    REPLACE('Hello, World', 'H', 'T') REP, -- �� ���ڸ� �����ڷ� �ٲٱ�
    TRIM('          Hello, World              ') TR,-- �յ� ���� ����
    TRIM('d' FROM '          Hello, World') TR -- ������ �ƴ� �ҹ��� d ����
FROM dual;

-- ���� �Լ�
-- ROUND : �ݿø� ( 10.6�� �Ҽ��� ù��°�ڸ����� �ݿø� -> 11)
-- TRUNC : ����(����) (10.6�� �Ҽ��� ù��° �ڸ����� ���� --> 10)
-- ROUND, TRUNC : ���° �ڸ����� �ݿø�/ ����
-- MOD : ������ ( ���� �ƴ϶� ������ ������ �� ������ ��) (13/5 -> ��:2, ������: 3) --> Ȱ���ؼ� ���� ���� �Լ���

-- ROUND(��� ����, ���� ��� �ڸ�) 
SELECT ROUND(105.54, 1), -- �ݿø� ����� �Ҽ��� ù��° �ڸ� ���� �������� --> �ι�° �ڸ����� �ݿø�
       ROUND(105.55, 1), -- �ݿø� ����� �Ҽ��� ù��° �ڸ� ���� �������� --> �ι�° �ڸ����� �ݿø�
       ROUND(105.55, 0), -- �ݿø� ����� �����θ� �������� --> �Ҽ��� ù��° �ڸ����� �ݿø�
       ROUND(105.55, -1), -- �ݿø� ����� 10���ڸ����� �������� --> ���� �ڸ����� �ݿø��ϸ鼭 �����ڸ��� 0���� ��ȯ
       ROUND(105.54) -- �ι�° ������ �⺻���� 0
FROM dual;

SELECT TRUNC(105.54, 1), -- ������ ����� �Ҽ��� ù��° �ڸ����� �������� -> �ι�° �ڸ����� ����
       TRUNC(105.55, 1), -- ������ ����� �Ҽ��� ù��° �ڸ����� �������� -> �ι�° �ڸ����� ����
       TRUNC(105.55, 0), -- ������ ����� ������(���� �ڸ�)���� �������� -> �Ҽ��� ù��° �ڸ����� ����
       TRUNC(105.55, -1), -- ������ ����� ������(���� �ڸ�)���� �������� -> ������ ���� �ڸ����� ����
       TRUNC(105.55) -- ������ ����� ������(���� �ڸ�)���� �������� -> �Ҽ��� ù��° �ڸ����� ���� -- TRUNC(105.55, 0) ����
FROM dual;

-- EMP ���̺��� ����� �޿�(sal)�� 1000���� �������� ��
SELECT ename, sal, sal/1000,
        TRUNC(sal/1000, 0), -- ��
        -- mod�� ����� divisior���� �׻� �۴�.
        MOD(sal, 1000) -- 0~999
FROM emp;

--�⵵ 2�ڸ�/��2 �ڸ�/�� 2�ڸ�
SELECT ename, hiredate
FROM emp;

-- SYSDATE : ���� ����Ŭ ������ �ú��ʰ� ���Ե� ��¥ ������ �������ִ� Ư�� �Լ�
-- �Լ���(����1, ����2)
-- date + ���� = ���� ����
-- ���� 1 - �Ϸ�
-- 1�ð� = 1/24
-- 2020/01/28 + 5

-- ���� ǥ�� : ���� --> 100
-- ���� ǥ�� : �̱� �����̼� + ���ڿ� + ��Ŭ �����̼� -- > '���ڿ�'
-- ��¥ ǥ�� : TO_DATE('���ڿ� ��¥ ��', '���ڿ� ��¥ ���� ǥ�� ��Ģ') 
            --> TO_DATE('2020-01-28', 'YYYY-MM-DD')

SELECT SYSDATE + 5, SYSDATE + 1/24
FROM dual;




