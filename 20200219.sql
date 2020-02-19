-- ���� ���� ��� 11��
-- ����¡ ó��(�������� 10���� �Խñ�)
-- 1������ : 1 ~ 10
-- 2������ : 11 ~ 20
-- ���ε庯�� :page, :pagesize

SELECT *
FROM 
    (SELECT a.*, ROWNUM rn
     FROM
     (SELECT LPAD(' ', (LEVEL-1)*4) || title title, DECODE(parent_seq, NULL, seq, parent_seq) root,seq, parent_seq
      FROM board_test
      START WITH parent_seq IS NULL
      CONNECT BY PRIOR seq = parent_seq 
      ORDER SIBLINGS BY root DESC, seq ASC) a)
WHERE rn BETWEEN (:page-1)* :pageSize+1 AND :page* :pageSize;


-- �м� �Լ�
-- �ǽ� ana0 (�μ��� �޿���ŷ)
SELECT b.ename, b.sal, a.lv
FROM
(SELECT a.*, rownum rm
FROM
(SELECT *
FROM
(   SELECT LEVEL lv
    FROM dual
    CONNECT BY LEVEL <=14) a,
(   SELECT deptno, COUNT(*) cnt
    FROM emp
    GROUP BY deptno) b
WHERE b.cnt >= a.lv
ORDER BY b.deptno, a.lv) a) a 
JOIN
(SELECT b.*, rownum rm
FROM
(SELECT ename, sal, deptno
FROM emp
ORDER BY deptno, sal desc)b) b ON(a.rm = b.rm);


 ���� ������ �м��Լ��� ����ؼ� ǥ���ϸ�..;
 SELECT ename, sal, deptno, RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) rank
 FROM emp; -- �� ���� ������ ������ �����ϰ� ���� ��ũ�� �� �ο��� ���� ����
 
 SELECT ename, sal, deptno, ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rank
 FROM emp; -- �� ���� ���Ƶ� ���� ã���� ������ ������.
 
-- �м� �Լ� ����
-- �м��Լ���([����]) OVER ([PARTITION BY �÷�] [ORDER BY �÷�] [WINDWING])
-- PARTITION BY �÷� : �ش� �÷��� ���� ROW ���� �ϳ��� �׷����� ���´�.
-- ORDER BY �÷� : PARTITION BY�� ���� ���� �׷� ������ ORDER BY �÷����� ����

-- ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rank;

 ���� ���� �м� �Լ�
 RANK() : ���� ���� ������ �ߺ� ������ ����, �ļ����� �ߺ� ����ŭ ������ ������ ����
          2���� 2���̸� 3���� ���� 4����� �ļ����� �����ȴ�.
 DENSE_RANK() : ���� ���� ������ �ߺ� ������ ����, �ļ����� �ߺ����� �������� ����
                2���� 2���̴��� �ļ����� 3����� ����
 ROW_NUMBER() : ROWNUM�� ����, �ߺ��� ���� ������� ����;
 
 �μ���, �޿� ������ 3���� ��ŷ �����Լ��� ����;
 SELECT empno, ename, sal, deptno,
        RANK() OVER (PARTITION BY deptno ORDER BY sal) sal_rank,
        DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal) sal_dense_rank,
        ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal) sal_row_number
 FROM emp;
 
-- �ǽ� ana1
 SELECT ename, sal, deptno,
        RANK() OVER (ORDER BY sal, empno DESC) sal_rank,
        DENSE_RANK() OVER (ORDER BY sal, empno DESC) sal_dense_rank,
        ROW_NUMBER() OVER (ORDER BY sal, empno DESC) sal_row_number
 FROM emp;
 
 �׷� �Լ� : ��ü ������
 SELECT COUNT(*)
 FROM emp;
 
 no_ana1 : ��� ��ü �޿� ����
 �м��Լ� ���� �׷� : PARTITION BY ==> ������� ������ ��ü���� �������;
 
-- �ǽ� no_ana2
SELECT a.empno, a.ename, a.deptno, b.
FROM
 (SELECT deptno, COUNT(*) cnt
 FROM emp
 GROUP BY deptno) b,-- �̷��� �ؼ� deptno�� �� �μ��� ����� �ִ��� ����
 
 (SELECT empno, ename, deptno
 FROM emp) a
WHERE b.deptno = a.deptno
ORDER BY b.deptno;

SELECT emp.empno, emp.ename, emp.deptno, a.cnt
FROM emp,
 (SELECT deptno, COUNT(*) cnt
 FROM emp
 GROUP BY deptno) a-- �̷��� �ؼ� deptno�� �� �μ��� ����� �ִ��� ����
 
WHERE emp.deptno = a.deptno
ORDER BY a.deptno;

 ������ �м��Լ�(GROUP �Լ����� �����ϴ� �Լ� ������ ����)
 SUM(�÷�)
 COUNT(*), CONT(�÷�)
 MIN(�÷�)
 MAX(�÷�)
 AVG(�÷�)
 
 no_ana2�� �м��Լ��� ����Ͽ� �ۼ�
 �μ��� ���� ��;

 SELECT empno, ename, deptno, COUNT(*) OVER (PARTITION BY deptno) cnt
 FROM emp;
 
-- �ǽ� ana2
SELECT empno, ename, sal, deptno, ROUND (AVG(sal) OVER (PARTITION BY deptno), 2) avg_sal
FROM emp;

-- �ǽ� ana3
SELECT empno, ename, sal, deptno, ROUND (MAX(sal) OVER (PARTITION BY deptno), 2) max_sal
FROM emp;

-- �ǽ� ana4
SELECT empno, ename, sal, deptno, ROUND (MIN(sal) OVER (PARTITION BY deptno), 2) min_sal
FROM emp;

-- �޿��� ������������ �����ϰ�, �޿��� ���� ���� �Ի����ڰ� ���� ����� ���� �켱������ �ǵ��� �����Ͽ�
-- �������� ������(LEAD)�� SAL �÷��� ���ϴ� ���� �ۼ�

SELECT empno, ename, hiredate, sal, LEAD(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal
FROM emp; -- �� �ܰ辿 �ö�

-- �ǽ� ana5(�������� ���� �������� ��)
SELECT empno, ename, hiredate, sal, LAG(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal
FROM emp; -- �� �ܰ辿 ������

-- �ǽ� ana6 
-- ��� ����� ����, �������� �޿� ������ 1�ܰ� ���� ���
-- 
SELECT empno, ename, hiredate, sal, LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) lead_sal
FROM emp; -- �� �ܰ辿 �ö�

select *
from emp;

-- �ǽ� no_ana3 (�м��Լ� ����)
SELECT A.empno, A.ename, A.sal, SUM(b.sal) c_sum -- b�� ������ ����
FROM 
    (SELECT empno, ename, sal, rownum rn
    FROM
        (SELECT empno, ename, sal
        FROM emp
        ORDER BY sal) ) A,
        
    (SELECT empno, ename, sal, rownum rn
    FROM
        (SELECT empno, ename, sal
        FROM emp
        ORDER BY sal) ) B
WHERE A.rn >= B.rn -- �̷��� ������ �׾ select���� B�� �Ա� ������
group by A.empno, A.ename, A.sal
order by c_sum
;
 
-- �ǽ� no_ana3 �м� �Լ��� �̿��Ͽ� SQL �ۼ�
SELECT empno, ename, sal, SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) cumm_sal
FROM emp;

-- �������� �������� ���� ������� ���� ������� �� 3������ sal �հ� ���ϱ�;
SELECT empno, ename, sal, SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) c_sum
FROM emp;

-- �ǽ� ana7
-- �μ����� �޿�, �����ȣ �������� ���� ���� ��, �ڽ��� �޿��� �����ϴ�(����) ������� �޿����� ��ȸ�ϴ� ���� �ۼ�
-- �÷� : empno, ename, deptno, sal, ������
-- ORDER BY  ����� WINDOWING  ���� ������� ���� ��� ���� WINDOWING�� �⺻ ������ ����ȴ�.
-- RANGE UNBOUNDED PRECEDING
-- �̰� ª�� ǥ���ϸ� �ٷ� �� ǥ�� RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW;
SELECT empno, ename, deptno, sal, SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;

-- �̰͵� ��
SELECT empno, ename, deptno, sal, SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno) c_sum
FROM emp;

-- pt128
WINDOWING �� RANGE, ROWS ��
RANGE : ������ ���� ����, ���� ���� ������ �÷����� �ڽ��� ������ ���
ROWS : �������� �� ����
RANGE�� �ߺ��� ���� ����(���� ���� ��찡 ����� ���� ���� ��� ����)
ORDER BY  ��� �� WINDOWING���� ������� ���� ��� ���� WINDOWING�� �⺻ ������ ����ȴ�.;
SELECT empno, ename, deptno, sal, 
        SUM(sal) OVER (PARTITION BY deptno ORDER BY sal ROWS UNBOUNDED PRECEDING) row_,
        SUM(sal) OVER (PARTITION BY deptno ORDER BY sal range UNBOUNDED PRECEDING) range_,
        SUM(sal) OVER (PARTITION BY deptno ORDER BY sal ) default_
FROM emp;

