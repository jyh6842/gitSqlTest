-- GROUP_AD_2-1
SELECT DECODE(GROUPING(job) || GROUPING(deptno), '00', job,
                                                 '01', job,
                                                 '11', '총') job,
       DECODE(GROUPING(job) || GROUPING(deptno), '00', deptno,
                                                 '01', '소계',
                                                 '11', '계') deptno,
       SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

 MERGE : SELECT 하고나서 데이터가 조회되면 UPDATE
        SELECT 하고나서 데이터가 조회되지 않으면 INSERT
 SELECT + UPDATE / SELECT + INSERT ==> MERGE;

 REPORT GROUP FUNCTION
 1. ROLLUP
    - GROUP BY ROLLUP (컬럼1, 컬럼2)
    - ROLLUP 절에 기술한 컬럼을 오른쪽에서 하나씩 제거한 컬럼으로 SUBGROUP
    - GROUP BY 컬럼1, 컬럼2
      UNION
      GROUP BY 컬럼1
      UNION
      GROUP BY
 2. CUBE
 3. GROUPPING SETS
 
 -- 실습 GROUP_AD3
SELECT deptno,job, 
       SUM(sal + NVL(comm, 0)) sal
 FROM emp
 GROUP BY ROLLUP(deptno, job);
 
 -- 실습 GROUP_AD4
SELECT dname, job,
       SUM(sal + NVL(comm, 0)) sal
 FROM emp,dept
 WHERE emp.deptno = dept.deptno
 GROUP BY ROLLUP(dname, job);
 
 -- 실습 GROUP_AD4 2번째 방법
SELECT b.dname, a.job, a.sal
FROM
 (SELECT deptno, job, SUM(sal) sal
 FROM emp
 GROUP BY ROLLUP(deptno, job )) a, dept b
WHERE a.deptno = b.deptno(+);

 -- 실습 GROUP_AD5
SELECT DECODE(GROUPING(dname), 0, dname,
                               1, '총합') dname,
       job,
       SUM(sal + NVL(comm, 0)) sal
 FROM emp,dept
 WHERE emp.deptno = dept.deptno
 GROUP BY ROLLUP(dname, job);

 -- 실습 GROUP_AD5
SELECT (GROUPING(dname)), dname, job,
       SUM(sal + NVL(comm, 0)) sal
 FROM emp,dept
 WHERE emp.deptno = dept.deptno
 GROUP BY ROLLUP(dname, job);
 
  -- 실습 GROUP_AD5 2번째 방법
SELECT NVL(dept.dname,'총합') dname, job,
       SUM(sal + NVL(comm, 0)) sal
 FROM emp,dept
 WHERE emp.deptno = dept.deptno
 GROUP BY ROLLUP(dname, job);
 
 -----
 REPORT GROUP FUNCTION
 1. ROLLUP
 2. CUBE
 3. GROUPING
 활용도
 3, 1 >>>>>>>>>>>>>>>>>>>>>>>>> CUBE;
 
 GROUPING SETS
 순서와 관계없이 서브 그룹을 사용자가 직접 선언
 사용방법 : GROUP BY GROUPING SETS(col1, col2...)
 
 GROUP BY GROUPING SETS(col1, col2)
 ==>
 GROUP BY col1
 UNION ALL
 GROUP BY col2
 
 GROUP BY GROUPING SETS ( (col1, col2), col3, col4)
 ==> 
 GROUP BY col1, col2
 UNION ALL
 GROUP BY col3
 UNION ALL
 GROUP BY col4;
 
 GROUPING SETS의 경우 컬럼 기술 순서가 결과에 영향을 미치지 않는다.
 ROLLUP은 컬럼 기술 순서가 결과 영향을 미친다.
 GROUP BY GROUPING SETS(col1, col2)
 GROUP BY GROUPING SETS(col2, col1)
 ==>
 GROUP BY col1
 UNION ALL
 GROUP BY col2
 
 GROUP BY col2
 UNION ALL
 GROUP BY col1
 
 
 
 SELECT job, deptno, SUM(sal) sal
 FROM emp
 GROUP BY GROUPING SETS(job, deptno);
 
 GROUP BY GROUPING SETS(job, deptno)
 ==> 
 GROUP BY job
 UNION ALL
 GROUP BY deptno;
 
 
 
 SELECT job, SUM(sal) sal
 FROM emp
 GROUP BY GROUPING SETS(job, job); -- 이렇게 하면 union인지 union all 인지 개수를 생각해보면 값을 알 수 있다.
 
 job, deptno로 GROUP BY 한 결과와
 mgr로 GROUP BY한 결과가 조회하는 SQL을 GROUPING SETS로 급여합 SUM(sal) 작성;
 
 SELECT job, deptno, mgr, SUM(sal)
 FROM emp
 GROUP BY GROUPING SETS ((job, deptno), mgr);
 
 CUBE
 가능한 모든조합으로 컬름을 조합한 SUB GROUP을 생성한다.
 단, 기술한 컬럼의 순서는 지킨다;
 
 EX : GROUP BY CUBE (col1, col2);
 (col1, col2) ==> co1포함 되는지 안되는지, col2가 포함되는지 안되는지 총 4가지 경우
 (null, col2) ==> GROUP BY col2
 (null, null) ==> GROUP BY 전체
 (col1, null) ==> GROUP BY col1
 (col1, col2) ==> GROUP BY col1,col2;
 
 만약 컬럼 3개를 CUBE절에 기술한 경우 나올수 잇는 가지수는??;
 SELECT job, deptno, SUM(sal) sal
 FROM emp
 GROUP BY CUBE(job, deptno); -- 엑셀 CUBE 총 4가지의 색
 
 혼종; (과제) 색으로 칠하기
 SELECT job, deptno, mgr, SUM(sal) sal
 FROM emp
 GROUP BY job, rollup(deptno), CUBE(mgr); //job은 default, rollup은 전체와 deptno, cube는 mgr이 있고 없고
 
 GROUP BY job, deptno, mgr ==> GROUP BY job, deptno, mgr 
 GROUP BY job, deptno ==> GROUP BY job, deptno
 GROUP BY job, null, mgr ==> GROUP BY job, mgr
 GROUP BY job, null, null ==> GROUP BY job
 
 서브쿼리 UPDATE 
 1. emp_test 테이블 drop
 2. emp 테이블을 이용해서 emp_test 테이블 생성 (모든 행에 대해 ctas)
 3. emp_test 테이블에 dname VARCHAR2(14)컬럼 추가
 4. emp_test.dname 컬럼을 dept 테이블을 이용해서 부서명을 업데이트;
 
 DROP TABLE emp_test;
 
 CREATE TABLE emp_test AS
 SELECT *
 FROM emp;
 
 ALTER TABLE emp_test ADD (dname VARCHAR2(14));
 
 SELECT *
 FROM emp_test;
 
 UPDATE emp_test SET dname = (SELECT dname
                              FROM dept
                              WHERE dept.deptno = emp_test.deptno);
 COMMIT;
 
 -- 실습 sub_a1
 1. dept_test DROP 하기
 
 DROP TABLE dept_test;
 
 CREATE TABLE dept_test AS
 SELECT *
 FROM dept;
 
 ALTER TABLE dept_test ADD (empcnt NUMBER);
 
 SELECT *
 FROM emp_test; -- 어떤 테이블과 같은지 
 

 
 10	ACCOUNTING	NEW YORK
 20	RESEARCH	DALLAS
 30	SALES	CHICAGO
 40	OPERATIONS	BOSTON;
 
 UPDATE dept_test SET empcnt = 0;
 
 SELECT *
 FROM dept_test;
 
 SELECT deptno, COUNT(*)
 FROM emp
 GROUP BY deptno;

 UPDATE dept_test SET empcnt = (SELECT COUNT(dname)
                               FROM emp_test
                               WHERE dept_test.dname = emp_test.dname); -- 서브쿼리는 메인쿼리의 값을 사용할 수 있다. -- 0 으로 나옴
                               
 UPDATE dept_test SET empcnt = NVL((SELECT COUNT(*) cnt
                                    FROM emp
                                    WHERE deptno = dept_test.deptno
                                    GROUP BY deptno),0); -- null 값으로 나옴 -- 0 값으로 바꿔주기 위해서
                                
 SELECT COUNT(*) cnt
 FROM emp
 WHERE deptno = 40
 GROUP BY deptno;
 
 
 
-- 실습 sub_a2
 dept_test 테이블에 있는 부서중에 직원이 속하지 않은 부서 정보를 삭제
 *dept_test.empcnt 컬럼은 사용하지 않고
 emp 테이블을 이용하여 삭제;
 INSERT INTO dept_test VALUES (99, 'it1', 'daejeon', 0); 
 INSERT INTO dept_test VALUES (98, 'it2', 'daejeon', 0); 
 COMMIT;
 
 직원이 속하지 않은 부서 정보 조회?
 직원 있다 없다...?
 10번 부서에 직원 있다 없다?
 SELECT COUNT(*)
 FROM dept_test
 WHERE empcnt = 10;
 
 SELECT *
 FROM dept_test
 WHERE 0 = (SELECT COUNT(*)
            FROM emp
            WHERE deptno = dept_test.deptno); -- 0인 아무도 없는 부서를 지우고 싶다.
            
 DELETE dept_test
 WHERE 0 = (SELECT COUNT(*)
            FROM emp
            WHERE deptno = dept_test.deptno);

 SELECT *
 FROM dept_test;
 
 -- 실습 sub_a3
 
 DROP TABLE emp_test;
 
 CREATE TABLE emp_test AS
 SELECT *
 FROM emp;
 
 SELECT *
 FROM emp_test;
                
7369	SMITH	20	CLERK	7902	1980/12/17	800	
7900	JAMES	30	CLERK	7698	1981/12/03	950	
7876	ADAMS	20	CLERK	7788	1983/01/12	1100
 UPDATE emp_test A SET sal = sal +200
 WHERE sal < (SELECT AVG(sal)
              FROM emp_test B
              WHERE a.deptno = B.deptno);
7369	SMITH	20	CLERK	7902	1980/12/17	1000	
7900	JAMES	30	CLERK	7698	1981/12/03	1150	
7876	ADAMS	20	CLERK	7788	1983/01/12	1300	

 UPDATE emp_test SET sal =   (SELECT avg(sal) + 200
                              FROM emp_test
                              GROUP BY deptno);
              
 SELECT *
 FROM emp_test;

 WITH 절
 하나의 쿼리에서 반복되는 SUBQUERY 가 있을 대
 해당 SUBQUERY 를 별도로 선언하여 재사용.
 
 MAIN 쿼리가 실행될 때 WITH 선언한 쿼리 블럭이 메모리에 임시적으로 저장
 ==> MAIN 쿼리가 종료 되면 메모리 해제
 SUBQUERY 작성시에는 해당 SUBQUERY의 결과를 조회하기 위해서 I/O 반복적으로 일어나지만
 WITH절을 통해 선언하면 한번만 SUQUERY가 실행되고 그 결과를 메모리에 저장해 놓고 재사용
 단, 하나의 쿼리에서 동일한 SUBQUERY가 반복적으로 나오는거는 잘못 작성한 SQL일 확률이 높음;
 
 WITH 쿼리블록이름 AS (
    서브쿼리
 )
 
 SELECT *
 FROM 쿼리블록이름;
 
 직원의 부서별 급여 평균을 조회하는 쿼리블록을 WITH절을 통해 선언;
 WITH sal_avg_dept AS (
    SELECT deptno, ROUND(AVG(sal),2) sal
    FROM emp
    GROUP BY deptno
 ),
  dept_empcnt AS(
    SELECT deptno, COUNT(*) empcnt
    FROM emp
    GROUP BY deptno)
 
 SELECT *
 FROM sal_avg_dept a, dept_empcnt b
 WHERE a.deptno = b.deptno; 
 
 with 절을 이용한 테이스 테이블 작성
 WITH temp AS ( -- 가짜 데이터 만들때 많이 쓰지만 잘 안쓴다. 대부분 다른거 쓴다. 예를 들면 view 같은거
    SELECT sysdate -1 FROM dual UNION ALL
    SELECT sysdate -2 FROM dual UNION ALL 
    SELECT sysdate -3 FROM dual)
 SELECT *
 FROM temp;
 
 SELECT *
 FROM 
 (  SELECT sysdate -1 FROM dual UNION ALL
    SELECT sysdate -2 FROM dual UNION ALL 
    SELECT sysdate -3 FROM dual); -- WITH 말고 이런식으로 짬 WITH를 쓰면 쿼리가 짧아짐
    
 
 
 
 
 달력만들기
 CONNECT BY LEVEL <[=] 정수
 해당 테이블의 행을 정수 만큼 복제하고 복제된 햄을 구별하기 위해서 LEVEL을 부여
 LEVEL은 1부터 시작;
 SELECT dummy, LEVEL
 FROM dual
 CONNECT BY LEVEL <= 10;
 
 SELECT dept.*, LEVEL
 FROM dept
 CONNECT BY LEVEL <= 5;


 2020년 2월의 달력을 생성
 :dt = 202002, 202003
 해당월의 일수가 필요함
 달력
 일  월   화   수   목   금   토
 1.
 SELECT SYSDATE, LEVEL
 FROM dual
 CONNECT BY LEVEL <= :dt;
 
 SELECT TO_DATE('202002','YYYYMM') + (LEVEL-1), -- 레벨을 0으로 맞추기 위해 1을 뺌, 레벨은 1부터 시작한다. 다시 설명하면 TO_DATE('202002','YYYYMM')은 이미 레벨을 가지고 있다. LEVEL은 초기값이 1이다. + (LEVEL-1)을 해줘야 1일이 가진 요일값에 영향을 주지 않을 수 있다. 일 1 월 2 화 3 ... 토 7
        TO_CHAR(TO_DATE('202002','YYYYMM') + (LEVEL-1), 'D'),
        DECODE(TO_CHAR(TO_DATE('202002','YYYYMM') + (LEVEL-1), 'D'), 1, TO_DATE('202002','YYYYMM') + (LEVEL-1)) sun,
        DECODE(TO_CHAR(TO_DATE('202002','YYYYMM') + (LEVEL-1), 'D'), 2, TO_DATE('202002','YYYYMM') + (LEVEL-1)) mon,
        DECODE(TO_CHAR(TO_DATE('202002','YYYYMM') + (LEVEL-1), 'D'), 3, TO_DATE('202002','YYYYMM') + (LEVEL-1)) tue,
        DECODE(TO_CHAR(TO_DATE('202002','YYYYMM') + (LEVEL-1), 'D'), 4, TO_DATE('202002','YYYYMM') + (LEVEL-1)) wen,
        DECODE(TO_CHAR(TO_DATE('202002','YYYYMM') + (LEVEL-1), 'D'), 5, TO_DATE('202002','YYYYMM') + (LEVEL-1)) thu,
        DECODE(TO_CHAR(TO_DATE('202002','YYYYMM') + (LEVEL-1), 'D'), 6, TO_DATE('202002','YYYYMM') + (LEVEL-1)) fri,
        DECODE(TO_CHAR(TO_DATE('202002','YYYYMM') + (LEVEL-1), 'D'), 7, TO_DATE('202002','YYYYMM') + (LEVEL-1)) sat
 FROM dual
 CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202002', 'YYYYMM')), 'DD'); -- D 하나면 요일임
 
 SELECT TO_DATE('202002' 'YYYYMM'
 
 
 SELECT TO_CHAR(LAST_DAY(TO_DATE('202002', 'YYYYMM')), 'DD') -- 이걸로 달의 일수를 구할 수 있음
 FROM dual;
