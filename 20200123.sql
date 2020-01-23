--p68
--WHERE2
-- WHERE ���� ����ϴ� ���ǿ� ������ ��ȸ ����� ������ ��ġ�� �ʴ´�.
-- SQL�� ������ ������ ���� �ִ�.
-- ���� : Ű�� 185cm �̻��̰� �����԰� 70kg �̻��� ������� ����
--  --> �����԰� 70kg �̻��̰� Ű�� 185cm �̻��� ������� ����
-- ������ Ư¡ : ���տ��� ������ ����.
-- {1, 5 ,10} --> {10, 5, 1} : �� ������ ���� �����ϴ�.
-- ���̺��� ������ ������� ����
-- SELECT ����� ������ �ٸ����� ���� �����ϸ� ����
--> ���ı�� ���� (ORDER BY)
--    �߻��� ����� ���� -> ����x
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('19820101','YYYYMMDD') AND hiredate <= TO_DATE('19830101','YYYYMMDD'); 

-- IN ������
-- Ư�� ���տ� ���ԵǴ��� ���θ� Ȯ��
-- �μ���ȣ�� 10�� Ȥ��(OR) 20���� ���ϴ� ���� ��ȸ

SELECT empno, ename, deptno
FROM emp
WHERE deptno=10 OR deptno=20;

SELECT empno, ename, deptno
FROM emp
WHERE deptno IN(10, 20);

-- emp ���̺��� ����̸� SMITH, JONES �� ������ ��ȸ (empno, ename, deptno)
SELECT empno, ename, deptno
FROM emp
WHERE ename IN('SMITH', 'JONES');

SELECT userid AS ���̵�, usernm AS �̸�, alias AS ����
FROM users
WHERE userid IN('brown', 'cony', 'sally');

-- ���ڿ� ��Ī ������ : LIKE, %, _
-- ������ ������ ������ ���ڿ� ��ġ�� ���ؼ� �ٷ�
-- �̸��� BR�� �����ϴ� ����� ��ȸ
-- �̸��� R ���ڿ��� ���� ����� ��ȸ

--��� �̸��� S�� �����ϴ� ��� ��ȸ
-- SMITH, SMILE, SKC
-- % � ���ڿ�(�ѱ���, ���� �������� �ְ�, ���� ���ڿ��� �ü��� �ִ�.)
SELECT *
FROM emp
WHERE ename LIKE 'S%';

--���ڼ��� ������ ���� ��Ī
-- _ : ��Ȯ�� �ѹ���
-- ���� �̸��� S�� �����ϰ� �̸��� ��ü ���̰� 5���� �� ���� -> _ 4��
-- S____ 
SELECT *
FROM emp
WHERE ename LIKE 'S____';

--��� �̸��� S���ڰ� ���� ��� ��ȸ
-- eanme LIKE '%S%';
SELECT *
FROM emp
WHERE ename LIKE '%S%';

--member ���̺��� ȸ���� ���� [��]���� ����� mem_id, mem_name�� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '��%';

--WHERE5
--member ���̺��� ȸ���� �̸��� ����[��]�� ���� ��� ����� mem_id, mem_name�� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%��%';

--null �� ���� (IS)
-- comm �÷��� ���� null�� �����͸� ��ȸ(WHERE comm = null)
SELECT *
FROM emp
WHERE comm = null;

SELECT *
FROM emp
WHERE comm = '';

SELECT *
FROM emp
WHERE comm is null;
--where6
SELECT *
FROM emp
WHERE comm is not null;

-- ����� �����ڰ� 7698, 7839 �׸��� null�� �ƴ� ������ ��ȸ
-- NOT IN �����ڿ��� NULL ���� ���� ��Ű�� �ȵ�
SELECT *
FROM emp
WHERE mgr NOT IN(7698, 7839) AND mgr is NOT null;

--WHERE7
SELECT *
FROM emp
WHERE job ='SALESMAN' AND hiredate >= TO_DATE('19810601','YYYYMMDD');

--WHERE8
SELECT *
FROM emp
WHERE deptno != 10 AND hiredate >= TO_DATE('19810601','YYYYMMDD');

--WHERE9
SELECT *
FROM emp
WHERE deptno NOT IN(10) AND hiredate >= TO_DATE('19810601','YYYYMMDD');

--WHERE10
SELECT *
FROM emp
WHERE deptno IN(20,30) AND hiredate >= TO_DATE('19810601','YYYYMMDD');

--WHERE11
SELECT *
FROM emp
WHERE job='SALESMAN' OR hiredate >= TO_DATE('19810601','YYYYMMDD');

--WHERE12
SELECT *
FROM emp
WHERE job='SALESMAN' OR empno LIKE '78%';

--WHERE13
SELECT *
FROM emp
WHERE job='SALESMAN' OR (empno >= 7800 AND empno <7900); -- ����¥�� ����
-- ���±��� ���ɷδ� �̰� �ִ��� ��?

--������ �켱����
--*,/ ������ +,- ���� �켱������ ����
-- 1+5+*2 = 11 -> (1+5)*2 �� ������ �ƴϴ�.
--�켱���� ���� () �̰ɷ� ����
-- AND > OR

--emp ���̺��� ��� �̸��� SMITH �̰ų� ��� �̸��� ALLEN �̸鼭 �������� SALESMAN�� ��� ��ȸ
SELECT *
FROM emp
WHERE ename='SMITH' OR (ename='ALLEN' AND job='SALESMAN');

--��� �̸��� SMITH �̰ų� ALLEN �̸鼭 �������� SALESMAN�� ��� ��ȸ
SELECT *
FROM emp
WHERE (ename='SMITH' OR ename='ALLEN') AND job='SALESMAN';

--WHERE14
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%' AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

-- ����
-- SELECT *
-- FROM table
-- [WHERE]
-- ORDER BY (�÷�|��Ī|�÷��ε��� [ASC | DESC], ....)
-- ASC �� �⺻�̾ ���� ����

-- emp ���̺��� ��� ����� ename �÷� ���� �������� �������� ������ ����� ��ȸ �ϼ���.
SELECT *
FROM emp
ORDER BY ename ASC;

--emp ���̺��� ��� ����� ename �÷� ���� �������� �������� ������ ����� ��ȸ �ϼ���.
SELECT *
FROM emp
ORDER BY ename DESC;

--DESC emp; --DESC : DESCRIBE (�����ϴ�)
--ORDER BY ename DESC -- DESC : DESCENDING (����)

-- emp ���̺��� ��� ���� ename �÷����� ���� ����, ename ���� ���� ��� mgr �÷����� �������� �����ϴ� ������ �ۼ��ϼ���.
SELECT *
FROM emp
ORDER BY ename DESC, mgr;

-- ���Ľ� ��Ī ���
SELECT empno, ename nm, sal*12 year_sal
FROM emp
ORDER BY year_sal; -- FROM ���� ���� ���� �� SELECT ����ǰ� ORDER BY ����

--�÷� �ε����� ����
-- java array[0]
-- SQL COLUMN INDEX : 1���� ����
SELECT empno, ename nm, sal*12 year_sal
FROM emp
ORDER BY 3; --sal*12 year_sal 3��° �� Į���� ��ȣ�� �����Ѵ�.

--orderby1

SELECT *
FROM dept
ORDER BY dname;

SELECT *
FROM dept
ORDER BY deptno;

--orderby2
SELECT *
FROM emp
WHERE comm IS NOT null AND comm != 0
ORDER BY comm desc, empno;

SELECT *
FROM emp
WHERE comm IS NOT null AND comm > 0
ORDER BY comm desc, empno;

--orderby3
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno desc;
