-- emp 테이블에서 job 컬럼의 값이 SALESMAN 이면서 sal가 1400보다 크면 SAL * 1.05 리턴
--                              SALESMAN 이면서 sal가 1400보다 작으면 SAL * 1.1 리턴
--                              MANAGER 이면 SAL * 1.1 리턴
--                              PRESIDENT 이면 SAL * 1.2 리턴
--                              그밖의 사람들은 SAL을 리턴

-- 1. CASE 만 이용해서
-- 2. DECODE, case를 혼용해서

-- 1. 
SELECT ename, job, sal,
    CASE
        WHEN job = 'SALESMAN' AND sal > 1400 THEN sal * 1.05
        WHEN job = 'SALESMAN' AND sal < 1400 THEN sal * 1.1
        WHEN job = 'MANAGER' THEN sal * 1.1
        WHEN job = 'PRESIDENT' THEN sal * 1.2
        ELSE sal
    END bonus_sal
FROM emp;


--2. 
SELECT ename, job, sal,
        CASE
            WHEN  job = 'SALESMAN' AND sal > 1400 THEN sal * 1.05
            WHEN job = 'SALESMAN' AND sal < 1400 THEN sal * 1.1
            ELSE DECODE(job,'MANAGER', sal * 1.1,
                    'PRESIDENT', sal * 1.2, sal) -- else 안쓰고 맨 마지막에 온 값이 else 값
        END bonus_sal
FROM emp;

--2. DECODE 를 먼저 사용하기 (DECODE 안에 CASE나 DECODE 구문이 중첩이 가능하다.)
SELECT ename, job, sal,
        DECODE(job, 'SALESMAN', CASE
                                    WHEN sal > 1400 THEN sal * 1.05
                                    WHEN sal < 1400 THEN sal * 1.1
                                END,
                    'MANAGER', sal * 1.1,
                    'PRESIDENT', sal * 1.2,
                    sal) bonus_sal
FROM emp;

-- 1. SQL 활용 PART1
-- condition 실습 cond1
-- DECODE로
SELECT empno, ename, 
        DECODE(deptno, 10, 'ACCOUNTING',
                        20, 'RESEARCH',
                        30, 'SALES',
                        40, 'OPERATIONS',
                        'DDIT') dname
FROM emp;
-- CASE
SELECT empno, ename, 
        CASE
            WHEN deptno=10 THEN 'ACCOUNTIN'
            WHEN deptno=20 THEN 'RESEARCH'
            WHEN deptno=30 THEN 'SALES'
            WHEN deptno=40 THEN 'OPERATIONS'
            ELSE 'DDIT'
        END dname         
FROM emp;

-- condition 실습 cond2
-- 올해년도가 짝수이면
--    입사년도가 짝수일 때 건강검진 대상자
--    입사년도가 홀수일 때 건강검진 비대상자
-- 올해년도가 홀수이면
--   입사년도가 짝수일 때 건강검진 비대상자
--   입사년도가 홀수일 때 건강검진 대상자
-- 짝수 -> 2로 나누었을 때 나머지 0
-- 홀수 -> 2로 나누었을 때 나머지 1

SELECT empno, ename, hiredate, MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')),2) sysdate_mod,
    CASE
        WHEN MOD(TO_CHAR(hiredate, 'YYYY'), 2) = 0 
            AND 
             MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) = 0 THEN '검강검진 대상자'
        ELSE '검강검진 비대상자'
    END AS contact_to_doctor
FROM emp;

SELECT empno, ename, hiredate,
    DECODE( MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')),2), MOD(TO_NUMBER(TO_CHAR(hiredate, 'YYYY')),2), '대상자',
            '비대상자')
FROM emp;

-- condition 실습 cond3 (과제)
SELECT userid, usernm, alias, reg_dt,
    CASE
        WHEN (MOD(TO_NUMBER(TO_CHAR(reg_dt, 'YYYY')),2 )) = 0 AND (MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')),2 ))=0 THEN '대상자'
        WHEN (MOD(TO_NUMBER(TO_CHAR(reg_dt, 'YYYY')),2 )) = 1 AND (MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')),2 ))=1 THEN '비대상자'        
    END contacttoddctor
FROM users;

-- pt168
SELECT *
FROM emp;

-- GROUP BY 행을 묶을 기준
-- 부서번호가 같은 ROW 끼리 묶은 경우 : GROUP BY deptno
-- 담당업무가 같은 ROW 끼리 묶는 경우 : GROUP BY job
-- MGR가 같고 담당업무가 같은 ROW 끼리 묶는 경우 : GROUP BY mgr, job

-- 그룹함수의 종류
-- SUM : 합계
-- COUNT : 갯수 - NULL 값이 아닌 ROW의 개수 NULL은 무시되어 갯수에서 제외
-- MAX : 최대값
-- MIN : 최소값
-- AVG : 평균

-- 그룹함수의 특징
-- 해당 컬럼에 NULL값을 갖는 ROW 가 존재할 경우 해당 값은 무시하고 계산한다. (NULL 연산의 결과는 null)

-- GROUP BY 절에 나온 컬럼 이외의 다른 컬럼이 SELECT절에 표현되면 에러 ** 중요 **

-- 부서별 급여 합 
SELECT deptno, ename,
        SUM(sal) sum_sal, MAX(sal) max_sal, MIN(sal) , ROUND(AVG(sal),2) , COUNT(sal) 
FROM emp
GROUP BY deptno, ename;

-- GROUP BY 절에 없는 상태에서 그룹함수를 사용한 경우
-- --> 전체행을 하나의 행으로 묶는다.
SELECT -- 제거 해야함 -- deptno, ename,
        SUM(sal) sum_sal, MAX(sal) max_sal, MIN(sal) , ROUND(AVG(sal),2) , 
        COUNT(sal), -- sal 컬럼의 값이 null이 아닌 row의 갯수
        COUNT(comm), -- COMM 컬럼의 값이 null이 아닌 row의 갯수
        COUNT(*) -- 몇건의 데이터가 있는지
FROM emp;

-- GROUP BY의 기준이 empno이면 결과수가 몇건??  -- 14건

SELECT -- 제거 해야함 -- deptno, ename,
        SUM(sal) sum_sal, MAX(sal) max_sal, MIN(sal) , ROUND(AVG(sal),2) , 
        COUNT(sal), -- sal 컬럼의 값이 null이 아닌 row의 갯수
        COUNT(comm), -- COMM 컬럼의 값이 null이 아닌 row의 갯수
        COUNT(*) -- 몇건의 데이터가 있는지
FROM emp
GROUP BY empno;


-- GROUP BY의 기준이 empno이면 결과수가 몇건??  -- 14건
-- 그룹화와 관련없는 임의의 문자열, 함수, 숫자등은 SELECT절에 나오는 것이 가능
SELECT -- 제거 해야함 -- deptno, ename,
        1, SUM(sal) sum_sal, 'ACCOUNTING', MAX(sal) max_sal, MIN(sal) , ROUND(AVG(sal),2) , 
        COUNT(sal), -- sal 컬럼의 값이 null이 아닌 row의 갯수
        COUNT(comm), -- COMM 컬럼의 값이 null이 아닌 row의 갯수
        COUNT(*) -- 몇건의 데이터가 있는지
FROM emp
GROUP BY empno;

-- SINGLE ROW FUNCTION의 경우 WHERE 절에서 사용하는 것이 가능하나
-- MULTI ROW FUNCTION(GROUP FUNCTION)의 경우 WHERE 절에서 사용하는 것이 불가능 하고
-- HAVING 절에서 조건을 기술하낟.

-- 부서별 급여 합 조회, 단 급여합이 9000 이상인 row만 조회
-- deptno, 급여합
SELECT deptno, SUM(sal) sum_sal
FROM  emp
GROUP BY deptno
HAVING SUM(sal) > 9000;

-- group function 실습 grp1
SELECT MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, 
        COUNT(sal) count_sal, -- 직원 중 급여가 있는 직원의 수 (null 제외)
        COUNT(mgr), -- 직원중 상급자가 잇는 직원의 수(null 제외)
        COUNT(*) count_all -- 전체 직원의 수
FROM emp;

-- group function 실습 grp2
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(avg(sal),2) avg_sal, SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY deptno;

-- group function 실습 grp3
SELECT 
        (CASE
            WHEN deptno=10 THEN 'ACCOUNTING'
            WHEN deptno=20 THEN 'RESEARCH'
            WHEN deptno=30 THEN 'SALES'
        END) dname,
        MAX(sal) max_sal, MIN(sal) min_sal, ROUND(avg(sal),2) avg_sal, SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY (CASE
            WHEN deptno=10 THEN 'ACCOUNTING'
            WHEN deptno=20 THEN 'RESEARCH'
            WHEN deptno=30 THEN 'SALES'
        END) 
ORDER BY (CASE
            WHEN deptno=10 THEN 'ACCOUNTING'
            WHEN deptno=20 THEN 'RESEARCH'
            WHEN deptno=30 THEN 'SALES'
        END);
        
SELECT  DECODE(deptno, 10, 'ACCOUNTING',  20, 'RESEARCH', 30, 'SALES'),
        MAX(sal) max_sal, MIN(sal) min_sal, ROUND(avg(sal),2) avg_sal, SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY DECODE(deptno, 10, 'ACCOUNTING',  20, 'RESEARCH', 30, 'SALES')
ORDER BY DECODE(deptno, 10, 'ACCOUNTING',  20, 'RESEARCH', 30, 'SALES');


-- group function 실습 grp4
-- ORACLE 9i 이전까지는 GROUP BY 절에 기술한 컬럼으로 정렬을 보장
-- ORACLE 10G 이후 부터는 GROUP BY 절에 기술한 컬럼으로 정렬을 보장 하지 않는다. (GROUP BY 연산자 속도 up)
SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm, COUNT(hiredate) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM');

-- group function 실습 grp5
SELECT TO_CHAR(hiredate, 'YYYY'), COUNT(hiredate)
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY');

-- group function 실습 grp6

SELECT COUNT(deptno) cnt
FROM dept;


-- group function 실습 grp7
-- 부서가 뭐가 있는지 일단 확인
select * from emp;

SELECT COUNT(*) cnt
FROM
    (SELECT deptno
    FROM emp
    GROUP BY deptno)
;

