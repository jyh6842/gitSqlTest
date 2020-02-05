-- sub4
-- dept 테이블에는 5건의 데이터가 존재
-- emp 테이블에는 14명의 직원이 있고, 직원은 하나의 부서에 속해 있다.(deptno)
-- 부서중 직원이 속해 있지 않은 부서 정보를 조회

-- 서브쿼리에서 데이터의 조건이 맞는지 확인자 역할을 하는 서브쿼리 작성

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
                    
-- 실습 sub5
SELECT * 
FROM cycle;

SELECT * 
FROM product;

-- cid=1 인 고객이 애음하는 제품
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

--1번째 방법
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

--2번째 방법
SELECT cy.cid, c.cnm, cy.pid, p.pnm, cy.day, cy.cnt
FROM cycle cy, customer c, product p
WHERE cy.cid = 1
AND cy.pid IN (SELECT pid
            FROM cycle
            WHERE cid = 2)
AND cy.cid = c.cid
AND cy.pid = p.pid;

--3번째 방법 (하지 말아야할 쿼리)
SELECT cy.cid, (SELECT cnm FROM CUSTOMER WHERE CID = CY.CID) CNM,
        cy.PID, (SELECT PNM FROM PRODUCT WHERE PID = CY.PID) PNM,
        cy.day, cy.CNT
FROM cycle cy
WHERE cid=1 
AND pid IN (SELECT pid
            FROM cycle
            WHERE cid = 2);
            
-- 매니저가 존재하는 직원을 조회(KING을 제외한 13명의 데이터가 조회)            
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- EXISTS 연산자
-- EXISTS 조건에 만족하는 행이 존재 하는지 확인하는 연산자
-- 다른 연산자와 다르게 WHERE 절에 컬럼을 기술하지 않는다.
    . WHERE empno = 7369
    . WHERE EXISTS (SELECT 'X'
                    FROM .....);

매니저가 존재하는 직원을 EXISTS 연산자를 통해 조회
매니저도 직원
SELECT empno, ename, mgr
FROM emp e
WHERE EXISTS (SELECT 'X'
              FROM emp m
              WHERE e.mgr = m.empno);

-- sub9
-- 1 번 고객이 애음하는 제품 --> 100, 400;
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
                                 
-- 집합연산
-- 합집합 : UNION - 중복제거(집합개념) / UNION ALL - 중복을 제거하지 않음(속도 향상)
-- 교집합 : INTERSECT (집합 개념)
-- 차집합 : MINUS (집합 개념)
-- 집합 연산 공통사항
-- 두 집합의 컬럼의 개수, 타입이 일치 해야 한다.

-- 동일한 집합을 합집하기 때문에 중복되는 데이터는 한번만 적용된다.
-- UNION
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698)

UNION

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698);

-- UNION ALL 연산자는 UNION 연산자와 다르게 중복을 허용한다.
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698)

UNION ALL

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698);

-- INTERSECT (교집합) : 위, 아래 집합에서 값이 같은 행만 조회
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

-- 집합의 기술 순서가 영향이 가는 집합 연산자
-- A UNION B           B UNION A       ==> 같음
-- A UNION ALL B       B UNION ALL A   ==> 같음(집합에서)
-- A INTERSECT B       B INTERSECT A   ==> 같음
-- A MINUS B           B MINUS A       ==> 다름;

-- 집합연산의 결과 컬럼 이름은 첫번째 집합의 컬럼명을 따른다.
SELECT 'X' fir, 'B' SEC
FROM dual

UNION

SELECT 'Y', 'A'
FROM dual;

-- 정렬 (ORDER BY)는 집합연산 가장 마지막 집합 다음에 기술;
SELECT deptno, dname, loc
FROM dept
WHERE deptno IN (10,20)
-- ORDER BY deptno : ORDER BY 는 마지막에 써줘야한다. 중간에 들어가면 거기서 끝났다고 생각한다.
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
    ORDER BY deptno) -- 이건 가능

UNION

SELECT *
FROM dept
WHERE deptno IN (30,40)
ORDER BY deptno;

-- 햄버거 도시 발전 지수;
SELECT *
FROM fastfood;

버거지수 --> (KFC 개수 + 버거킹 개수 + 맥도날드 개수) / 롯데리아 개수
시도, 시군구, 버거지수
버거지수 값이 높은 도시가 먼저 나오도록 정렬;

SELECT gb, count(gb)
FROM fastfood
GROUP BY gb;

SELECT count(gb)
FROM fastfood
WHERE gb = 'KFC' AND SIDO='강원도';

SELECT sido, sigungu, COUNT(g1.gb)
FROM fastfood g1
WHERE g1.gb IN('KFC', '맥도날드', '버거킹') 
GROUP BY sido, sigungu;

SELECT sido, sigungu, COUNT(g2.gb)
FROM fastfood g2
WHERE g2.gb IN('롯데리아') 
GROUP BY sido, sigungu;


SELECT g1.sido, g1.sigungu, count(g1)
FROM (SELECT sido, sigungu, COUNT(gb)
      FROM fastfood
      WHERE gb IN('KFC', '맥도날드', '버거킹') 
      GROUP BY sido, sigungu) g1,
     (SELECT sido, sigungu, COUNT(gb)
      FROM fastfood
      WHERE gb IN('롯데리아') 
      GROUP BY sido, sigungu) g2
WHERE g1.sido = g2.sido AND g1.sigungu = g2.sigungu
GROUP BY g1.sido, g1.sigungu
      
       ;
       
SELECT *
FROM (SELECT sido, sigungu, COUNT(gb)
      FROM fastfood
      WHERE gb IN('KFC', '맥도날드', '버거킹') 
      GROUP BY sido, sigungu) g1,
     (SELECT sido, sigungu, COUNT(gb)
      FROM fastfood
      WHERE gb IN('롯데리아') 
      GROUP BY sido, sigungu) g2

      
       ;




