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

-- users의 테이블의 모든 행에 대해서 조회
-- users에는 5건의 데이터가 존재
SELECT *
FROM users;

-- WHERE 절 : 테이블에서 데이터를 조회할 때 조건에 맞는 행만 조회
-- ex : userid 컬럼의 값이 brown인 행만 조회
-- brown, 'brown' 구분
-- ''이 없으면 brown을 컬럼, 문자열 상수로 인식
SELECT * 
FROM users
WHERE userid = 'brown';

--userid 가 brown이 아닌 행만 조회(brown을 제외한 4rjs)
-- 같을 때 : =, 다를때 : !=, <>
SELECT * 
FROM users
WHERE userid != 'brown';

--emp 테이블에 존재하는 컬럼을 확인 해보세요 (교육 목적으로 만든 테이블임)
SELECT *
FROM emp;

--emp 테이블에서 ename 칼럽 값이 JONES인 행만 조회
-- * SQL KEY WORD는 대소문자를 가리지 않지만
-- 컬럼의 값이나, 문자열 상수는 대소문자를 가린다.
-- 'JONES', 'Jones'는 값이 다른 상수
SELECT * 
FROM emp
WHERE ename = 'JONES';

DESC emp;

-- emp 테이블에서 deptno(부서번호)가 30보다 크거나 같은 사원들만 조회
SELECT * 
FROM emp
WHERE deptno >= 30;

-- 문자열 = '문자열'
-- 숫자 : 50
-- 날짜 : ??? -> 함수와 문자열을 결합하여 표현
--      문자열만 이용하여 표현 가능 (권장하지 않음)
--      국가별로 날짜 표기 방법이 다르다.
--      한국 : 년도4자리-월2자리-일자2자리
--      미국 : 월2자리-일자2자리-년도4자리

-- 입사일자가 1980년 12월 17일 직원만 조회
SELECT * 
FROM emp
WHERE hiredate = '80/12/17'; -- 위험

-- TO_DATE : 문자열을 date 타입으로 변경하는 함수
-- TO_DATE(날짜형식 문자열, 첫번째 인자의 형식)
-- '1980/02/03'
SELECT * 
FROM emp
WHERE hiredate = TO_DATE('19801217', 'YYYY/MM/DD');

--범위 연산
--sal 컬럼의 값이 1000에서 2000 사이인 사람
--sal >= 1000
--sal <= 2000;
SELECT *
FROM emp
WHERE sal >= 1000 AND sal <=2000;

-- 범위연산자를 부등호 대신에 BETWEEN AND 연산자로 대체
SELECT * 
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('19820101','YYYY/MM/DD') AND  TO_DATE('19830101','YYYYMMDD'); 