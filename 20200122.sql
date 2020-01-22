SELECT *
FROM lprod;

SELECT buyer_id, buyer_name
FROM buyer;

SELECT * 
FROM cart;

SELECT mem_id, mem_pass, mem_name
FROM member;

--user 테이블 조회
SELECT *
FROM users;

-- 테이블에 어떤 컬럼이 잇는지 확인하는 방법
-- 1. SELECT * 
-- 2. TOOL의 기능 (사용자-TABLE)
-- 3. DESC 테이블명 (DESC-DESCRIBE)
DESC users;

-- users 테이블에서 userid, usernm, tog_dt 컬럼만 조회하는 sql을 작성하세요
-- 날짜 연산 (reg_dt 컬럼은 date 정보를 담을 수 잇는 타입)
-- SQL 날짜 컬럼 + (더하기 연산)
-- 수학적인 사칙연산이 아닌것들(5+5)
-- String h = "hello";
-- String w = "world";
-- String hw = h+w; --자바에서는 두 문자열을 결합해라
-- SQL에서 정의된 날짜 연산 : 날짜 + 정수를 일자로 취급하여 더한 날짜가 된다. ( 2019/01/28 +5 = 2019/02/02)
-- reg_dt : 등록일자 컬럼
-- null : 값을 모르는 상태
-- null에 대한 연산 결과는 항상 null
-- AS는 별명을 쉽게 구분하기 위해 사용하는 키워드로 사용하지 않아도 된다.
-- null 과 공백은 다르다. "", null

SELECT userid u_id, usernm, reg_dt, reg_dt+5 AS reg_dt_after_5day
FROM users;

SELECT prod_id AS id, prod_name AS name
FROM prod;

SELECT lprod_gu AS gu, lprod_nm AS nm
FROM lprod;

SELECT buyer_id AS 바이어아이디, buyer_name AS 이름
FROM buyer;

-- 문자열 결함
-- 자바 언어에서 문자열 결합 : + ("Hello" + "world")
-- SQL에서는 : || ('Hello' || 'world')
-- SSQL에서는 : concat('Hello', 'world')

-- userid, usernm 칼럼을 결합, 별칭 id_name
SELECT *
FROM users;

SELECT userid || usernm AS id_name,
        CONCAT(userid, usernm) AS concat_id_name
FROM users;

-- 변수, 상수
-- int a = 5; String msg = "Hello, World";
-- 변수를 이용한 출력
-- System.out.println(msg) 
--상수를 이용한 출력
-- System.out.println("Hello, World"); 

-- SQL에서의 변수는 없음
-- (컬럼이 비슷한 역할, pl/sql 변수 개념이 존재)
-- SQL에서 문자열 상수는 실글 쿼테이션으로 표현
-- "Hello, world" --> 'Hello, World'

-- 문자열 상수와 컬럼간의 결합
-- user id : brown
-- user id : cony
SELECT  'user id : ' || userid AS "use rid" --공백이나 대문자를 사용하기 위해서는 "" 더블쿼테이션을 사용 하면 된다.
FROM users;

SELECT 'SELECT * FROM ' || table_name || ';' AS query 
FROM user_tables;

-- ||을 --> CONCAT 으로 해보기
-- CONCAT(agr1, arg2) 인자가 두개 밖에 없음
SELECT CONCAT(CONCAT('SELECT * FROM', table_name), ';') AS query
FROM user_tables;

-- int a = 5; //할당, 대입 연산자
-- if ( a == 5) (a의 값이 5인지 비교)
-- sql 에서는 대입의 개념이 없다. (PL/SQL)
-- sql = --> equal