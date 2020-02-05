-- sub4
-- dept ���̺��� 5���� �����Ͱ� ����
-- emp ���̺��� 14���� ������ �ְ�, ������ �ϳ��� �μ��� ���� �ִ�.(deptno)
-- �μ��� ������ ���� ���� ���� �μ� ������ ��ȸ

-- ������������ �������� ������ �´��� Ȯ���� ������ �ϴ� �������� �ۼ�

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
                    
-- �ǽ� sub5
SELECT * 
FROM cycle;

SELECT * 
FROM product;

-- cid=1 �� ���� �����ϴ� ��ǰ
SELECT pid
FROM cycle
WHERE cid=1;

SELECT *
FROM product
WHERE pid NOT IN (100, 400);

SELECT *
FROM product
WHERE pid NOT IN (SELECT pid
                FROM cycle
                WHERE cid=1);
    
-- sub6
SELECT pid
FROM cycle
WHERE cid=1;

SELECT pid
FROM cycle
WHERE cid=2;

SELECT pid
FROM cycle
WHERE cid=1 AND pid IN (100);

SELECT *
FROM cycle
WHERE cid=1 
AND pid IN (SELECT pid
            FROM cycle
            WHERE cid = 2);
                        
-- sub7
SELECT *
FROM customer;

SELECT *
FROM cycle;

SELECT *
FROM product;

--1��° ���
SELECT cy.cid, c.cnm, cy.pid, p.pnm, cy.day, cy.cnt
FROM
    (SELECT *
    FROM cycle
    WHERE cid=1 
    AND pid IN (SELECT pid
                FROM cycle
                WHERE cid = 2)) cy, customer c, product p
WHERE cy.cid = c.cid
AND cy.pid = p.pid;

--2��° ���
SELECT cy.cid, c.cnm, cy.pid, p.pnm, cy.day, cy.cnt
FROM cycle cy, customer c, product p
WHERE cy.cid = 1
AND cy.pid IN (SELECT pid
            FROM cycle
            WHERE cid = 2)
AND cy.cid = c.cid
AND cy.pid = p.pid;

--3��° ��� (���� ���ƾ��� ����)
SELECT cy.cid, (SELECT cnm FROM CUSTOMER WHERE CID = CY.CID) CNM,
        cy.PID, (SELECT PNM FROM PRODUCT WHERE PID = CY.PID) PNM,
        cy.day, cy.CNT
FROM cycle cy
WHERE cid=1 
AND pid IN (SELECT pid
            FROM cycle
            WHERE cid = 2);
            
-- �Ŵ����� �����ϴ� ������ ��ȸ(KING�� ������ 13���� �����Ͱ� ��ȸ)            
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- EXISTS ������
-- EXISTS ���ǿ� �����ϴ� ���� ���� �ϴ��� Ȯ���ϴ� ������
-- �ٸ� �����ڿ� �ٸ��� WHERE ���� �÷��� ������� �ʴ´�.
    . WHERE empno = 7369
    . WHERE EXISTS (SELECT 'X'
                    FROM .....);

�Ŵ����� �����ϴ� ������ EXISTS �����ڸ� ���� ��ȸ
�Ŵ����� ����
SELECT empno, ename, mgr
FROM emp e
WHERE EXISTS (SELECT 'X'
              FROM emp m
              WHERE e.mgr = m.empno);

-- sub9
-- 1 �� ���� �����ϴ� ��ǰ --> 100, 400;
SELECT *
FROM product p
WHERE EXISTS (SELECT 'X'
              FROM cycle c
              WHERE p.pid = c.pid AND cid =1);
              
-- sub10

SELECT *
FROM product p
WHERE NOT EXISTS (SELECT 'X'
                  FROM cycle c
                  WHERE p.pid = c.pid AND cid =1);
SELECT *
FROM product p
WHERE EXISTS (SELECT 'X'
              FROM cycle c
              WHERE p.pid NOT IN (SELECT pid
                                 FROM cycle
                                 where cid = 1));
                                 
-- ���տ���
-- ������ : UNION - �ߺ�����(���հ���) / UNION ALL - �ߺ��� �������� ����(�ӵ� ���)
-- ������ : INTERSECT (���� ����)
-- ������ : MINUS (���� ����)
-- ���� ���� �������
-- �� ������ �÷��� ����, Ÿ���� ��ġ �ؾ� �Ѵ�.

-- ������ ������ �����ϱ� ������ �ߺ��Ǵ� �����ʹ� �ѹ��� ����ȴ�.
-- UNION
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698)

UNION

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698);

-- UNION ALL �����ڴ� UNION �����ڿ� �ٸ��� �ߺ��� ����Ѵ�.
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698)

UNION ALL

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698);

-- INTERSECT (������) : ��, �Ʒ� ���տ��� ���� ���� �ุ ��ȸ
SELECT empno, ename
FROM emp
WHERE empno In (7566, 7698, 7369)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno In (7566, 7698);

-- MINUS
SELECT empno, ename
FROM emp
WHERE empno In (7566, 7698, 7369)

MINUS

SELECT empno, ename
FROM emp
WHERE empno In (7566, 7698);

-- ������ ��� ������ ������ ���� ���� ������
-- A UNION B           B UNION A       ==> ����
-- A UNION ALL B       B UNION ALL A   ==> ����(���տ���)
-- A INTERSECT B       B INTERSECT A   ==> ����
-- A MINUS B           B MINUS A       ==> �ٸ�;

-- ���տ����� ��� �÷� �̸��� ù��° ������ �÷����� ������.
SELECT 'X' fir, 'B' SEC
FROM dual

UNION

SELECT 'Y', 'A'
FROM dual;

-- ���� (ORDER BY)�� ���տ��� ���� ������ ���� ������ ���;
SELECT deptno, dname, loc
FROM dept
WHERE deptno IN (10,20)
-- ORDER BY deptno : ORDER BY �� �������� ������Ѵ�. �߰��� ���� �ű⼭ �����ٰ� �����Ѵ�.
UNION

SELECT *
FROM dept
WHERE deptno IN (30,40)
ORDER BY deptno;

SELECT deptno, dname, loc
FROM 
    (SELECT deptno, dname, loc
    FROM dept
    WHERE deptno IN (10,20)
    ORDER BY deptno) -- �̰� ����

UNION

SELECT *
FROM dept
WHERE deptno IN (30,40)
ORDER BY deptno;

-- �ܹ��� ���� ���� ����;
SELECT *
FROM fastfood;

�������� --> (KFC ���� + ����ŷ ���� + �Ƶ����� ����) / �Ե����� ����
�õ�, �ñ���, ��������
�������� ���� ���� ���ð� ���� �������� ����;

SELECT gb, count(gb)
FROM fastfood
GROUP BY gb;

SELECT count(gb)
FROM fastfood
WHERE gb = 'KFC' AND SIDO='������';

SELECT sido, sigungu, COUNT(g1.gb)
FROM fastfood g1
WHERE g1.gb IN('KFC', '�Ƶ�����', '����ŷ') 
GROUP BY sido, sigungu;

SELECT sido, sigungu, COUNT(g2.gb)
FROM fastfood g2
WHERE g2.gb IN('�Ե�����') 
GROUP BY sido, sigungu;


SELECT g1.sido, g1.sigungu, count(g1)
FROM (SELECT sido, sigungu, COUNT(gb)
      FROM fastfood
      WHERE gb IN('KFC', '�Ƶ�����', '����ŷ') 
      GROUP BY sido, sigungu) g1,
     (SELECT sido, sigungu, COUNT(gb)
      FROM fastfood
      WHERE gb IN('�Ե�����') 
      GROUP BY sido, sigungu) g2
WHERE g1.sido = g2.sido AND g1.sigungu = g2.sigungu
GROUP BY g1.sido, g1.sigungu
      
       ;
       
SELECT *
FROM (SELECT sido, sigungu, COUNT(gb)
      FROM fastfood
      WHERE gb IN('KFC', '�Ƶ�����', '����ŷ') 
      GROUP BY sido, sigungu) g1,
     (SELECT sido, sigungu, COUNT(gb)
      FROM fastfood
      WHERE gb IN('�Ե�����') 
      GROUP BY sido, sigungu) g2

      
       ;




