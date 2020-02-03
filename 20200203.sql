-- �ǽ� join3
--oracle ����
SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member, cart, prod
WHERE member.mem_id = cart.cart_member
AND cart.cart_prod = prod.prod_id;

-- ANSI ����
SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member JOIN cart ON (member.mem_id = cart.cart_member)
            JOIN prod ON (cart.cart_prod = prod.prod_id);
            
--batch.sql �׸��� �𵨸�.png ����
SELECT *
FROM customer;

SELECT *
FROM product;

SELECT *
FROM cycle;

-- �Ǹ��� : 200 ~250
-- ���� 2.5�� ��ǰ

-- join4
SELECT cycle.cid, customer.cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer, cycle
WHERE cycle.cid = customer.cid AND customer.cnm IN('brown', 'sally');

SELECT cycle.cid, customer.cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer JOIN cycle ON cycle.cid = customer.cid AND customer.cnm IN('brown', 'sally');

--join5

SELECT customer.cid, customer.cnm, product.pid, product.pnm, cycle.day, cycle.cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid AND product.pid = cycle.pid
AND customer.cnm IN('brown', 'sally');

--join6
SELECT customer.cid, customer.cnm, product.pid, product.pnm, SUM(cycle.cnt)
FROM customer, cycle, product
WHERE customer.cid = cycle.cid AND product.pid = cycle.pid
GROUP BY customer.cid, customer.cnm, product.pid, product.pnm;

SYSTEM ������ ���� HR ���� Ȱ��ȭ;

-- join7 ~ 13 ����

-- OUTER JOIN
OUTER JOIN 
�� ���̺��� ������ �� ���� ������ ���� ��Ű�� ���ϴ� �����͸� 
�������� ������ ���̺��� �����͸��̶� ��ȸ �ǰԲ� �ϴ� ���� ���;

�������� : e.mgr = m.empno : KING�� MGR �� NULL�̱� ������ ���ο� �����Ѵ�
emp ���̺��� �����ʹ� �� 14�� ������ �Ʒ��� ���� ���������� ����� 13���� �ȴ�. ( 1���� ���� ����)
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

ANSI OUTER; 
1. ���ο� �����ϴ��� ��ȸ�� �� ���̺��� ���� (�Ŵ��� ������ ��� ��� ������ �����Բ�);

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e LEFT OUTER JOIN emp m ON e.mgr = m.empno; --> LEFT OUTER JOIN ���ʿ� �ִ� emp e �� ������ �ȴ�. 

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp m RIGHT OUTER JOIN emp e ON e.mgr = m.empno;

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON e.mgr = m.empno; --> �� �ٸ���? emp e �� emp m �ڸ��� �ٲ��� ������ �� �ٸ���?

-- ORACLE OUTER JOIN;
�����Ͱ� ���� ���� ���̺� �÷� �ڿ� (+) ��ȣ�� �ٿ� �ش�.
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

���� SQL ANSI�� SQL(OUTER JOIN)���� ���� �غ�����.
�Ŵ����� �μ���ȣ�� 10���� ������ ��ȸ;
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m
ON e.mgr = m.empno 
AND m.deptno = 10; --> ���ο� ������ �ֵ鵵 ����

�Ʒ� LEFT OUTER ������ ���������� OUTER ������ �ƴϴ�.;
�Ʒ� INNTER ���ΰ� ����� �����ϴ�.;
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m
ON e.mgr = m.empno --> ���� ������ ������ �����
WHERE m.deptno = 10; --> ��ȸ ����� �ٸ� ��ȸ�� ������ �ֵ��� ������ ���� --> OUTER JOIN�� ����� �ȵ� ����

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e JOIN emp m
(ON e.mgr = m.empno) 
WHERE m.deptno = 10;

-- ����Ŭ OUTER JOIN;
-- ����Ŭ OUTER JOIN�� ���� ���̺��� �ݴ��� ���̺��� ��� �÷��� (+)�� �ٿ���
-- �������� OUTER JOIN���� �����Ѵ�.
-- �� �÷��̶� (+)�� �����ϸ� INNER �������� �����Ѵ�.

�Ʒ� ORACLE OUTER ������ INNER �������� ���� : m.deptno �÷��� (+)�� ���� ����
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
AND m.deptno = 10;

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
AND m.deptno(+) = 10;

��� - �Ŵ����� RIGHT OUTER JOIN;
SELECT empno, ename, mgr
FROM emp e;

SELECT empno, ename, mgr
FROM emp m;

SELECT e.empno, e.ename, e.mgr, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno);

-- FULL OUTER : LEFT OUTER + RIGHT OUTER - �ߺ� ����;
-- 
SELECT e.empno, e.ename, e.mgr, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);

-- outerjoin1
select * 
from prod;
select * 
from buyprod;

SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p ON b.buy_prod(+) = p.prod_id  
AND b.buy_date = TO_DATE('2005/01/25','YYYY/MM/DD');
-- AND TO_CHAR(b.buy_date, 'YYYYMMDD') = '20050125'; -- �̰͵� �ȴ�.
 
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b,prod p 
WHERE b.buy_prod(+) = p.prod_id AND b.buy_date(+) = TO_DATE('2005/01/25','YYYY/MM/DD');

 
 
 
SELECT count(*) -- 148
FROM buyprod;

SELECT count(*) -- 74
FROM prod; -- �� ���� ��

SELECT count(*) -- �� 148? -- ������ �ƹ��� ���� �絵 prod �ȿ� �ִ� �� ���� �� ����.
FROM prod, buyprod
WHERE prod.prod_id = buyprod.buy_prod;

-- outerjoin2

SELECT NVL(b.buy_date, TO_DATE('20050125', 'YYYY/MM/DD')), b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p ON b.buy_prod(+) = p.prod_id  
AND TO_CHAR(b.buy_date, 'YYYYMMDD') = '20050125';
-- join7
select *
from cycle;

select *
from product;

select p.pid, p.pnm, sum(c.cnt) cnt
from cycle c, product p
where p.pid = c.pid
group by p.pid, p.pnm;



