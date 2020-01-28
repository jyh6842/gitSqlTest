-- 1. SQL 활용 PART1

-- 데이터 정렬 (ORDER BY 실습 orderby4)

SELECT *
FROM emp
WHERE deptno IN(10,30) AND sal > 1500
ORDER BY ename DESC;

-- 데이터 정렬
-- tool 에서 제공해주는 행의 번호를 컬럼으로 갖을 수 없을까?

-- ROWNUM : 행번호를 나타내는 칼럼
SELECT ROWNUM, empno, ename
FROM emp
WHERE deptno IN(10,30)
AND sal > 1500;

-- ROWNUM을 WHERE절에서도 사용 가능
-- 동작 하는 거 : ROWNUM = 1, ROWNUM <= 2   ---> ROWNUM=1, ROWNUM <= N
-- 동작하지 않는 거 : ROWNUM = 2, ROWNUM >= 2   ---> ROWNUM = N(N이 1이 아닌 정수), ROWNUM >= N (N은 1이 아닌 정수)
-- ROWNUM 이미 읽은 데이터에다가 순서를 부여 
-- ** 유의점1 : 읽지 않은 상태의 값들( ROWNUM이 부여되지 않은 행)은 조회할 수가 없다. (이미 읽을 수 있도록 하자)
-- ** 유의점2 : ORDER BY 절은 SELECT 절 이후에 실행
-- 테이블에 있는 모든 행을 소화하는 것이 아니라 우리가 원하는 페이지에 해당하는 행 데이터만 조회를 한다.( ex - 게시판 )
-- 페이징 처리시 고려사항 : 1페이지당 건수, 정렬 기준(최신순, 오래된 순, ....)
-- emp 테이블 중 row 건수 : 14
-- 페이징당 5건의 데이터 조회
-- *paeg size : 5, 정렬기준은 ename
-- 1 page : rn 1~5
-- 2 page : rn 6 ~ 10
-- 3 page : rn 11 ~ 15
-- n page : rn (n-1)*pageSize + 1 ~ n * pageSize

SELECT ROWNUM rn, empno, ename
FROM emp
ORDER BY ename;

-- 정렬된 결과에 ROWNUM을 부여 하기 위해서는 IN LINE VIEW를 사용한다.
-- 요점정리 : 1. 정렬, 2. ROWNU 부여

-- SELECT *(아스테리스크)를 기술할 경우 다른 EXPRESSION을 표기 하기위해서는 
-- 테이블명.* 테이블명칭.*로 표현해야한다.
SELECT ROWNUM, emp.*
FROM emp;

SELECT ROWNUM, e.*
FROM emp e;


SELECT ROWNUM, a.*
FROM
    (SELECT empno, ename
    FROM emp -- 하나의 테이블
    ORDER BY ename) a; -- () 하나의 테이블로 생각, 일회성
    
 SELECT *
 FROM
    (SELECT ROWNUM rn, a.*
     FROM
        (SELECT empno, ename
        FROM emp -- 하나의 테이블
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
WHERE ROWNUM = 2; -- 안됨

SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM >= 2; -- 안됨


-- 가상컬럼 ROWNUM 실습 row_1
SELECT *
FROM 
    (SELECT ROWNUM rn , e.*
     FROM 
        (SELECT empno, ename
         FROM emp ) e)
WHERE rn BETWEEN 1 AND 10;

-- 가상컬럼 ROWNUM 실습 row_2
SELECT *
FROM
    (SELECT ROWNUM rn, e.*    
    FROM
        (SELECT empno, ename
        FROM emp) e)
WHERE rn > 10;

-- 가상컬럼 ROWNUM 실습 row_3
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
WHERE rn BETWEEN (:page-1)* :pageSize-1 AND 1* :pageSize; -- :변수명 (콜론)(변수명)



-- DUAL 테이블 : 데이터와 관계 없이, 함수를 테스트 해볼 목적으로
SELECT *
FROM dual;

SELECT LENGTH('TEST')
FROM dual;

-- 문자열 대소문자 : LOWR, UPPER, INITCAP
SELECT LOWER('Hello, world!'), UPPER('Hello, world!'), INITCAP('Hello, world!')
FROM dual;

SELECT LOWER(ename), UPPER('Hello, world!'), INITCAP('Hello, world!')
FROM emp;

-- 함수는 WHERE 절에서도 사용 가능
-- 사원 이름이 SMITH인 사원만 조회
SELECT *
FROM emp
WHERE ename = UPPER(:ename);

-- SQL 작성시 아래 형태는 지양 해야한다. 
-- 테이블의 칼럼을 가공하지 않는 형태로 SQL을 작성한다.
-- SQL 칠거지악 검색 ㄱ
SELECT *
FROM emp
WHERE LOWER(ename) = :ename;

SELECT CONCAT('Hello', ' World') CONCAT,
    SUBSTR('Hello, World', 1, 5) sub, -- 1~5
    LENGTH('Hello, World') len,
    INSTR('Hello, World', 'o') ins,
    INSTR('Hello, World', 'o', 6) ins2, -- 6번째 이후에 나오는 o 는 몇번째 인지?
    LPAD('Hello, World', 15, '*') LP, -- 대상값을 포함하여 채울 크기, 넣을 값
    RPAD('Hello, World', 15, '*') RP,
    REPLACE('Hello, World', 'H', 'T') REP, -- 앞 인자를 뒷인자로 바꾸기
    TRIM('          Hello, World              ') TR,-- 앞뒤 공백 제거
    TRIM('d' FROM '          Hello, World') TR -- 공백이 아닌 소문자 d 제거
FROM dual;

-- 숫자 함수
-- ROUND : 반올림 ( 10.6을 소수점 첫번째자리에서 반올림 -> 11)
-- TRUNC : 절삭(버림) (10.6을 소수점 첫번째 자리에서 절삭 --> 10)
-- ROUND, TRUNC : 몇번째 자리에서 반올림/ 절삭
-- MOD : 나머지 ( 몫이 아니라 나누기 연산을 한 나머지 값) (13/5 -> 몫:2, 나머지: 3) --> 활용해서 많이 쓰는 함수임

-- ROUND(대상 숫자, 최종 결과 자리) 
SELECT ROUND(105.54, 1), -- 반올림 결과가 소수점 첫번째 자리 까지 나오도록 --> 두번째 자리에서 반올림
       ROUND(105.55, 1), -- 반올림 결과가 소수점 첫번째 자리 까지 나오도록 --> 두번째 자리에서 반올림
       ROUND(105.55, 0), -- 반올림 결과가 정수부만 나오도록 --> 소수점 첫번째 자리에서 반올림
       ROUND(105.55, -1), -- 반올림 결과가 10의자리까지 나오도록 --> 일의 자리에서 반올림하면서 일의자리는 0으로 변환
       ROUND(105.54) -- 두번째 인자의 기본값은 0
FROM dual;

SELECT TRUNC(105.54, 1), -- 절삭의 결과가 소수점 첫번째 자리까지 나오도록 -> 두번째 자리에서 절삭
       TRUNC(105.55, 1), -- 절삭의 결과가 소수점 첫번째 자리까지 나오도록 -> 두번째 자리에서 절삭
       TRUNC(105.55, 0), -- 절삭의 결과가 정수부(일의 자리)까지 나오도록 -> 소수점 첫번째 자리에서 절삭
       TRUNC(105.55, -1), -- 절삭의 결과가 정수부(십의 자리)까지 나오도록 -> 정수부 일의 자리에서 절삭
       TRUNC(105.55) -- 절삭의 결과가 정수부(일의 자리)까지 나오도록 -> 소수점 첫번째 자리에서 절삭 -- TRUNC(105.55, 0) 동일
FROM dual;

-- EMP 테이블에서 사람의 급여(sal)를 1000으로 나눴을때 몫
SELECT ename, sal, sal/1000,
        TRUNC(sal/1000, 0), -- 몫
        -- mod의 결과는 divisior보다 항상 작다.
        MOD(sal, 1000) -- 0~999
FROM emp;

--년도 2자리/월2 자리/일 2자리
SELECT ename, hiredate
FROM emp;

-- SYSDATE : 현재 오라클 서버의 시분초가 포함된 날짜 정보를 리턴해주는 특수 함수
-- 함수명(인자1, 인자2)
-- date + 정수 = 일자 연산
-- 정수 1 - 하루
-- 1시간 = 1/24
-- 2020/01/28 + 5

-- 숫자 표기 : 숫자 --> 100
-- 문자 표기 : 싱글 쿼테이션 + 문자열 + 싱클 쿼테이션 -- > '문자열'
-- 날짜 표기 : TO_DATE('문자열 날짜 값', '문자열 날짜 값의 표기 원칙') 
            --> TO_DATE('2020-01-28', 'YYYY-MM-DD')

SELECT SYSDATE + 5, SYSDATE + 1/24
FROM dual;




