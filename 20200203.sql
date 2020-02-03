-- 실습 join3
--oracle 문법
SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member, cart, prod
WHERE member.mem_id = cart.cart_member
AND cart.cart_prod = prod.prod_id;

-- ANSI 문법
SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member JOIN cart ON (member.mem_id = cart.cart_member)
            JOIN prod ON (cart.cart_prod = prod.prod_id);
            
--batch.sql 그리고 모델링.png 사진
SELECT *
FROM customer;

SELECT *
FROM product;

SELECT *
FROM cycle;

-- 판매점 : 200 ~250
-- 고객당 2.5개 제품

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

SYSTEM 계정을 통해 HR 계정 활성화;

-- join7 ~ 13 과제

-- OUTER JOIN
OUTER JOIN 
두 테이블을 조인할 때 연결 조건을 만족 시키지 못하는 데이터를 
기준으로 지정한 테이블의 데이터만이라도 조회 되게끔 하는 조인 방식;

연결조건 : e.mgr = m.empno : KING의 MGR 은 NULL이기 때문에 조인에 실패한다
emp 테이블의 데이터는 총 14건 이지만 아래와 같은 쿼리에서는 결과가 13건이 된다. ( 1건이 조인 실패)
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

ANSI OUTER; 
1. 조인에 실패하더라도 조회가 될 테이블을 선정 (매니저 정보가 없어도 사원 정보는 나오게끔);

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e LEFT OUTER JOIN emp m ON e.mgr = m.empno; --> LEFT OUTER JOIN 왼쪽에 있는 emp e 가 기준이 된다. 

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp m RIGHT OUTER JOIN emp e ON e.mgr = m.empno;

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON e.mgr = m.empno; --> 왜 다르지? emp e 와 emp m 자리를 바꾸지 않으면 왜 다르지?

-- ORACLE OUTER JOIN;
데이터가 없는 쪽의 테이블 컬럼 뒤에 (+) 기호를 붙여 준다.
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

위의 SQL ANSI로 SQL(OUTER JOIN)으로 변경 해보세요.
매니저의 부서번호가 10번인 직원만 조회;
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m
ON e.mgr = m.empno 
AND m.deptno = 10; --> 조인에 실패한 애들도 나옴

아래 LEFT OUTER 조인은 실질적으로 OUTER 조인이 아니다.;
아래 INNTER 조인과 결과가 동일하다.;
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m
ON e.mgr = m.empno --> 여기 까지가 조인의 결과임
WHERE m.deptno = 10; --> 조회 결과가 다름 조회에 실패한 애들은 나오지 않음 --> OUTER JOIN이 제대로 안된 것임

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e JOIN emp m
(ON e.mgr = m.empno) 
WHERE m.deptno = 10;

-- 오라클 OUTER JOIN;
-- 오라클 OUTER JOIN시 기준 테이블의 반대편 테이블의 모든 컬럼에 (+)를 붙여야
-- 정상적인 OUTER JOIN으로 동작한다.
-- 한 컬럼이라도 (+)를 누락하면 INNER 조인으로 동작한다.

아래 ORACLE OUTER 조인은 INNER 조인으로 동작 : m.deptno 컬럼에 (+)가 붙지 않음
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
AND m.deptno = 10;

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
AND m.deptno(+) = 10;

사원 - 매니저간 RIGHT OUTER JOIN;
SELECT empno, ename, mgr
FROM emp e;

SELECT empno, ename, mgr
FROM emp m;

SELECT e.empno, e.ename, e.mgr, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno);

-- FULL OUTER : LEFT OUTER + RIGHT OUTER - 중복 제거;
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
-- AND TO_CHAR(b.buy_date, 'YYYYMMDD') = '20050125'; -- 이것도 된다.
 
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b,prod p 
WHERE b.buy_prod(+) = p.prod_id AND b.buy_date(+) = TO_DATE('2005/01/25','YYYY/MM/DD');

 
 
 
SELECT count(*) -- 148
FROM buyprod;

SELECT count(*) -- 74
FROM prod; -- 총 물건 수

SELECT count(*) -- 왜 148? -- 물건을 아무리 많이 사도 prod 안에 있는 걸 넘을 수 없다.
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



