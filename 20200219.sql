-- 쿼리 실행 결과 11건
-- 페이징 처리(페이지당 10건의 게시글)
-- 1페이지 : 1 ~ 10
-- 2페이지 : 11 ~ 20
-- 바인드변수 :page, :pagesize

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


-- 분석 함수
-- 실습 ana0 (부서별 급여랭킹)
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


 위에 쿼리를 분석함수를 사용해서 표현하면..;
 SELECT ename, sal, deptno, RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) rank
 FROM emp; -- 비교 값이 같으면 순위가 동일하고 다음 랭크는 앞 인원수 다음 순위
 
 SELECT ename, sal, deptno, ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rank
 FROM emp; -- 비교 값이 같아도 먼저 찾아진 순위가 빠르다.
 
-- 분석 함수 문법
-- 분석함수명([인자]) OVER ([PARTITION BY 컬럼] [ORDER BY 컬럼] [WINDWING])
-- PARTITION BY 컬럼 : 해당 컬럼이 같은 ROW 끼리 하나의 그룹으로 묶는다.
-- ORDER BY 컬럼 : PARTITION BY에 의해 묶은 그룹 내에서 ORDER BY 컬럼으로 정렬

-- ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rank;

 순위 관련 분석 함수
 RANK() : 같은 값을 가질때 중복 순위를 인정, 후순위는 중복 값만큼 떨어진 값부터 시작
          2등이 2명이면 3등은 없고 4등부터 후순위가 생성된다.
 DENSE_RANK() : 같은 값을 가질때 중복 순위를 인정, 후순위는 중복순위 다음부터 시작
                2등이 2명이더라도 후순위는 3등부터 시작
 ROW_NUMBER() : ROWNUM과 유사, 중복된 값을 허용하지 않음;
 
 부서별, 급여 순위를 3대의 랭킹 관련함수를 적용;
 SELECT empno, ename, sal, deptno,
        RANK() OVER (PARTITION BY deptno ORDER BY sal) sal_rank,
        DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal) sal_dense_rank,
        ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal) sal_row_number
 FROM emp;
 
-- 실습 ana1
 SELECT ename, sal, deptno,
        RANK() OVER (ORDER BY sal, empno DESC) sal_rank,
        DENSE_RANK() OVER (ORDER BY sal, empno DESC) sal_dense_rank,
        ROW_NUMBER() OVER (ORDER BY sal, empno DESC) sal_row_number
 FROM emp;
 
 그룹 함수 : 전체 직원수
 SELECT COUNT(*)
 FROM emp;
 
 no_ana1 : 사원 전체 급여 순위
 분석함수 에서 그룹 : PARTITION BY ==> 기술하지 않으면 전체행을 대상으로;
 
-- 실습 no_ana2
SELECT a.empno, a.ename, a.deptno, b.
FROM
 (SELECT deptno, COUNT(*) cnt
 FROM emp
 GROUP BY deptno) b,-- 이렇게 해서 deptno로 각 부서에 몇명이 있는지 구함
 
 (SELECT empno, ename, deptno
 FROM emp) a
WHERE b.deptno = a.deptno
ORDER BY b.deptno;

SELECT emp.empno, emp.ename, emp.deptno, a.cnt
FROM emp,
 (SELECT deptno, COUNT(*) cnt
 FROM emp
 GROUP BY deptno) a-- 이렇게 해서 deptno로 각 부서에 몇명이 있는지 구함
 
WHERE emp.deptno = a.deptno
ORDER BY a.deptno;

 통계관련 분석함수(GROUP 함수에서 제공하는 함수 종류와 동일)
 SUM(컬럼)
 COUNT(*), CONT(컬럼)
 MIN(컬럼)
 MAX(컬럼)
 AVG(컬럼)
 
 no_ana2를 분석함수를 사용하여 작성
 부서별 직원 수;

 SELECT empno, ename, deptno, COUNT(*) OVER (PARTITION BY deptno) cnt
 FROM emp;
 
-- 실습 ana2
SELECT empno, ename, sal, deptno, ROUND (AVG(sal) OVER (PARTITION BY deptno), 2) avg_sal
FROM emp;

-- 실습 ana3
SELECT empno, ename, sal, deptno, ROUND (MAX(sal) OVER (PARTITION BY deptno), 2) max_sal
FROM emp;

-- 실습 ana4
SELECT empno, ename, sal, deptno, ROUND (MIN(sal) OVER (PARTITION BY deptno), 2) min_sal
FROM emp;

-- 급여를 내림차순으로 정렬하고, 급여가 같을 때는 입사일자가 빠른 사람이 높은 우선순위가 되도록 정렬하여
-- 현재행의 다음행(LEAD)의 SAL 컬럼을 구하는 쿼리 작성

SELECT empno, ename, hiredate, sal, LEAD(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal
FROM emp; -- 한 단계씩 올라감

-- 실습 ana5(이전행의 값을 가져오는 것)
SELECT empno, ename, hiredate, sal, LAG(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal
FROM emp; -- 한 단계씩 내려감

-- 실습 ana6 
-- 모든 사원에 대해, 담당업무별 급여 순위가 1단계 높은 사람
-- 
SELECT empno, ename, hiredate, sal, LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) lead_sal
FROM emp; -- 한 단계씩 올라감

select *
from emp;

-- 실습 no_ana3 (분석함수 없이)
SELECT A.empno, A.ename, A.sal, SUM(b.sal) c_sum -- b가 작을때 까지
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
WHERE A.rn >= B.rn -- 이렇게 조건을 뒀어도 select에서 B가 왔기 때문에
group by A.empno, A.ename, A.sal
order by c_sum
;
 
-- 실습 no_ana3 분석 함수를 이용하여 SQL 작성
SELECT empno, ename, sal, SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) cumm_sal
FROM emp;

-- 현재행을 기준으로 이전 한행부터 이후 한행까지 총 3개행의 sal 합계 구하기;
SELECT empno, ename, sal, SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) c_sum
FROM emp;

-- 실습 ana7
-- 부서별로 급여, 사원번호 오름차순 정렬 햇을 때, 자신의 급여와 선행하는(이전) 사원들의 급여합을 조회하는 쿼리 작성
-- 컬럼 : empno, ename, deptno, sal, 누적합
-- ORDER BY  기술후 WINDOWING  절을 기술하지 않을 경우 다음 WINDOWING이 기본 값으로 적용된다.
-- RANGE UNBOUNDED PRECEDING
-- 이걸 짧게 표현하면 바로 위 표현 RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW;
SELECT empno, ename, deptno, sal, SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;

-- 이것도 됨
SELECT empno, ename, deptno, sal, SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno) c_sum
FROM emp;

-- pt128
WINDOWING 의 RANGE, ROWS 비교
RANGE : 논리적인 행의 단위, 같은 값을 가지는 컬럼까지 자신의 행으로 취급
ROWS : 물리적인 행 단위
RANGE는 중복된 값을 포함(값이 같은 경우가 생기면 같은 값을 모두 더함)
ORDER BY  기술 후 WINDOWING절을 기술하지 않을 경우 다음 WINDOWING이 기본 값으로 적용된다.;
SELECT empno, ename, deptno, sal, 
        SUM(sal) OVER (PARTITION BY deptno ORDER BY sal ROWS UNBOUNDED PRECEDING) row_,
        SUM(sal) OVER (PARTITION BY deptno ORDER BY sal range UNBOUNDED PRECEDING) range_,
        SUM(sal) OVER (PARTITION BY deptno ORDER BY sal ) default_
FROM emp;

