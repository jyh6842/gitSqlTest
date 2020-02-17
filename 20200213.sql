-- synonym : 동의어
-- 1. 객체 별칭을 부여
--     ==> 이름을 간단하게 표현
--    
-- sem 사용자가 자신의 테이블 emp테이블을 사용해서 만든 v_emp view
-- hr 사용자가 사용할 수 있게 끔 권한을 부여

-- v_emp : 민감한 정보 sal, comm 를 제외한 view

-- hr 사용자 v_emp를 사용하기 위해 다음과 같이 작성
 SELECT *
 FROM jyh6842.v_emp;

-- hr 계정에서
-- synonym sem.v_empo ==> v_emp
-- v_emp == sem.v_emp

 SELECT *
 FROM v_emp; 
 
-- 1. sem 계정에서 v_emp를 hr 계정에서 조회할 수 있도록 조회권한 부여;
-- GRANT SELECT ON v_emp TO hr;

-- 2. hr 계정 v_emp 조회하는게 가능 (권한 1번에서 받았기 때문에)
--   사용시 해당 객체의 소유자를 명시 : sem.v_emp
--   간단하게 sem.v_emp ==> v_emp 사용하고 싶은 상황
--   synonym 생성
  
-- CREATE SYNONYM 시노님 이름 FOR 원객체명;
 
 SELECT *
 FROM v_emp;
 
-- SYNONYM 삭제
-- DROP SYNONYM 시노님 이름;

-- GRANT CONNECT TO SEM; -- 시스템 권한
-- GRANT SELECT ON 객체명 TO HR; -- 객체권한

 권한 종류
 1. 시스템 권한 : TABLE을 생성, VIEW 생성 권한 ...
 2. 객체 권한 : 특정 객체에 대해 SELECT, UPDATE, INSERT, DELETE...
 
 ROLE : 권한을 모아놓은 집합
 사용자별로 개별 권한을 부여하게 되면 관리의 부담.
 특정 ROLE에 권한을 부여하고 해당 ROLE 사용자에게 부여
 해당 ROLE을 수정하게 되면 ROLE을 갖고 있는 모든 사용자에게 영향
 
 권한 부여/회수
 시스템 권한 : GRANT 권한이름 TO 사용자 | ROLE;
             REVOKE 권한이름 FROM 사용자 | ROLE;
 객체 권한 : GRANT 권한이름 ON 객체명 TO 사용자 | ROLE;
           REVOKE 권한이름 ON 객체명 FROM 사용자 | ROLE;
           
           
 data dictionary : 사용자가 관리하지 않고, dbms가 자체적으로 관리하는 시스템 정보를 담은 view;
 
 data dictionary 접두어
 1. USER : 해당 사용자가 소유한 객체
 2. ALL : 해당 사용자가 소유한 객체 + 다른 사용자로부터 권한을 부여 받은 객체
 3. DBA : 모든 사용자의 객체
 
 * V$ 특수 VIEW;
 
 SELECT *
 FROM USER_TABLES;
 
 SELECT *
 FROM ALL_TABLES;
 
 SELECT *
 FROM DBA_TABLES; -- 우리는 일반 사용자라서 조회가 안된다.
 
 DICTIONARY 종류 확인 : SYS.DICTIONARY;
 
 SELECT *
 FROM DICTIONARY;
 
 대표적인 dictionary
 OBJECT : 객체 정보 조회(테이블, 인덱스, VIEW, SYSNONYM... ) 
 TABLE : 테이블 정보만 조회
 TAB_COLUMNS : 테이블의 컬럼 정보 조회
-- INDEXS : 인덱스 정보 조회 -- 실행 계획을 할 것이라면 
-- IND_COLUMNS : 인덱스 구성 컬럼 조회 -- 실행 계획을 할 것이라면 요 2개가 중요하다.
 CONSTRAINTS : 제약조건 조회
 CONS_COLUMNS : 제약조건 구성 컬럼 조회
 TAB_COMMENTS : 테이블 주석
 COL_COMMENTS : 테이블의 컬럼 주석;
 
 SELECT *
 FROM USER_OBJECTS; -- OBJECT_TYPE를 보면 사용자가 가지고 잇는 객체를 모두 볼수 있고 어디에 속해 있는지 알수 있을거다.
 
 emp, dept 테이블의 인덱스와 인덱스 컬럼 정보 조회;
 user_indexes, user_ind_columns join
 테이블 명,     인덱스 명,      컬럼명
 emp,       ind_n_emp04,    ename
 emp,       ind_n_emp04,    job
 
 -- 테이블 인덱스
 SELECT *
 FROM USER_indexes;
 
 -- 인덱스 컬럼 
 SELECT *
 FROM user_ind_columns;
 
 --  emp, dept 테이블의 인덱스와 인덱스 컬럼 정보 조회
 SELECT table_name, index_name, column_name, column_position
 FROM user_ind_columns
 ORDER BY table_name, index_name, column_name, column_position;
 
 
 
 
 ----------------------------------------------------------------------------
 
 multiple insert : 하나의 insert 구문으로 여러 테이블에 데이터를 입력하는 DML;
 UPDATE dept_test SET loc = '대전' WHERE loc = 'daejeon'; -- 값이 안바뀌어서 따로 넣은 것
 commit;

 SELECT *
 FROM dept_test;
 
 SELECT *
 FROM dept_test2;
 
 동일한 값을 여러 테이블에 동시 입력하는 multiple insert;
 INSERT ALL
    INTO dept_test
    INTO dept_test2
 SELECT 98, '대덕', '중앙로' FROM dual UNION ALL 
 SELECT 97, 'IT', '영민' FROM dual;
 
 
 테이블에 입력할 컬럼을 지정 mutiple insert;
 ROLLBACK;
 
 INSERT ALL
    INTO dept_test (deptno, loc) VALUES ( deptno, loc)
    INTO dept_test2
 SELECT 98 deptno, '대덕' dname, '중앙로' loc FROM dual UNION ALL 
 SELECT 97, 'IT', '영민' FROM dual; -- 여러 테이블에 같은 값이 들어가는 것은 테이블 작성이 잘못 되었을 확률이 높음
 
 테이블에 입력할 데이터를 조건에 따라 multiple insert;
 CASE
    WHEN 조건 기술 THEN 
 END;

 ROLLBACK;
 INSERT ALL
    WHEN deptno = 98 THEN -- 98이라는 조건에 만족해서 insert 됨 1행 입력
        INTO dept_test (deptno, loc) VALUES ( deptno, loc)
        INTO dept_test2
    ELSE
        INTO dept_test2
 SELECT 98 deptno, '대덕' dname, '중앙로' loc FROM dual UNION ALL 
 SELECT 97, 'IT', '영민' FROM dual; -- else 부분이 insert 됨 2행 입력됨
 
 SELECT *
 FROM dept_test;
 
 SELECT *
 FROM dept_test2;
 
 조건을 만족하는 첫번째 insert만 실행하는 multiple insert;
 
ROLLBACK;


 INSERT FIRST -- FIRST 라서 조건을 만족하는 첫번째 조건문만 실행됨
    WHEN deptno >= 98 THEN
        INTO dept_test (deptno, loc) VALUES ( deptno, loc)
    WHEN deptno >= 97 then
        INTO dept_test2
    ELSE
        INTO dept_test2
 SELECT 98 deptno, '대덕' dname, '중앙로' loc FROM dual UNION ALL -- 98이라는 조건에 만족해서 insert 됨 1행 입력
 SELECT 97, 'IT', '영민' FROM dual; -- else 부분이 insert 됨 2행 입력됨
 
 SELECT *
 FROM dept_test;
 
 SELECT *
 FROM dept_test2;
 -----------------------------------------
 -- 어제 했던 인덱스 추가 설명
 오라클 객체 : 테이블에 여러개의 국역을 파티션으로 구분
 테이블 이름이 동일하나 갑의 종류에 따라 오라클 내부적으로 별도의 분리된 영역에 데이터를 저장;
 
 dept_test ==> dept_test_20200201
 
 INESRT FIRST
    WHEN deptno >=98 THEN
        INTO dept_test
    WHEN dpetno >= 97 THEN
        INTO dept_test_20200202
    ELSE
        INTO dept_test2
    SELECT 98 deptno, '대덕' dname, '중앙로' loc FROM dual UNION ALL
    SELECT 97, 'IT', '영민' FROM dual;
--------------------------- 여기까지 추가 설명

 MERGE : 통합
 테이블에 데이터를 입력/갱신 하려고 함
 1. 내가 입력하려고 하는 데이터가 존재하면
    ==> 업데이트
 2. 내가 입력하려고 하는 데이터가 존재하지 않으면 
    ==> INSERT

 1. SELECT 실행
 2-1. SELECT 실행 결과가 0 ROW이면 INSERT
 2-2. SELECT 실행 결과가 1 ROW이면 UPDATE
 
 MERGE 구문을 사용하게 되면 SELECT 를 하지 않아도 자동으로 데이터 유무에 따라
 INSERT 혹은 UPDATE 실행한다.
 2번의 쿼리를 한번으로 준다.
 
 MERGE INTO 테이블명 [alias]
 USING (TABLE | VIEW | IN-LINE-VIEW)
 ON (조인조건)
 WHEN MATCHED THEN
    UPDATE SET col1  = 컬럼값, col2  = 컬럼값,...
 WHEN NOT MATCHED THEN
    INSERT (컬럼1, 컬럼2...) VALUES (컬럼값1, 컬럼값2...);
    
    테이블명은 위에서 이미 기술 했기 때문에 UPDATE 하거나 INSERT 할때에는 할 필요가 없음
    
 SELECT *
 FROM emp_test;

 DELETE emp_test;

 로그를 안남긴다. ==> 복구가 안된다 ==> 테스트용으로...
 TRUNCATE TABLE emp_test;

 emp 테이블에서 emp_test 테이블로 데이터를 복사 (7369-SMITH);
 
 INSERT INTO emp_test
 SELECT empno, ename, deptno, '010'
 FROM emp
 WHERE empno = 7369;
 
 데이터가 잘 입력 되었는지 확인;
 
 SELECT *
 FROM emp_test;
 
 이름을 바꿔보자;
 UPDATE emp_test SET ename = 'brown'
 WHERE empno = 7369;
 commit;
 
 emp 테이블의 모든 직원을 emp_test테이블로 통합
 emp 테이블에는 존재하지만 emp_test에는 존재하지 않으면 insert
 emp 테이블에는 존재하고 emp_test에도 존재하면 ename, deptno를 update;
 
 emp 테이블에 존재하는 14건의 데이터중 emp_test에도 존재하는 7369를 제외한 13건의 데이터가
 emp_test 테이블에 신규로 입력이 되고
 emp_test에 존재하는 7369번의 데이터는 ename(brown)이 emp테이블에 존재하는 이름인 SMITH로 갱신.;
 
 MERGE INTO emp_test a
 USING emp b
 ON (a.empno = b.empno )
 WHEN MATCHED THEN
    UPDATE SET a.ename = b.ename, 
               a.deptno = b.deptno
 WHEN NOT MATCHED THEN
    INSERT (empno, ename, deptno) VALUES (b.empno, b.ename, b.deptno);
    
 SELECT *
 FROM emp_test; ==> brown 에서 SMITH로 바뀌었다.
 -------------------------------------------------------------------------- 
 해당 테이블에 데이터가 있으면 insert, 없으면 update
 emp_test 테이블에 사번이 9999번인 사람이 없으면 새롭게 insert
 있으면 update
 (9999,'brown', 10, '010');
 
 INSERT INTO dept_test VALUES (9999, 'brown', 10, '010');
 
 UPDATE dept_test SET ename = 'brown'
                      deptno = 10
                      hp = '010'
 WHERE empno = 9999;
 
 select *
 from dept_test;
 
 ------------------------- 이거는 합친걸 보여주려고 해 놓은 것인데 안되는 것이 맞음
 
 MERGE INTO emp_test
 USING dual
 ON (empno = 9999)
 WHEN MATCHED THEN
    UPDATE SET ename = ename || '_u',
               deptno = 10,
               hp = '010'
 WHEN NOT MATCHED THEN
    INSERT VALUES (9999, 'brown', 10, '010');
    
 SELECT *
 FROM emp_test;
 

 
 merge, window function(분석함수);
 
 -- 실습 GROUP_AD1
 SELECT null, SUM(sal)
 FROM emp
 
 union all
 
 select deptno, sum(sal)
 from emp
 group by deptno;

 
 
 I/O 에서 머가 가장 빨라요?
 CPU CACHE RAM > SSD > HDD > NETWORK;
 
 REPORT GROP FUNCTION
 ROLLUP
 CUBE
 GROUPING;
 
 ROLLUP
 사용 방법 : GROUP BY ROLLUP (컬럼1, 컬럼2...)
 SUBGROUP을 자동으로 생성
 SUBGROUP을 생성하는 규칙 : ROLLUP에 기술한 컬럼을 [오른쪽]에서부터 하나씩 제거하면서 
                         SUB GROUP을 생성;
 EX : GROUP BY ROLLUP (deptno)
 ==> 
 첫번째 sub group : GROUP BY deptno
 두번째 sub group : GROUP BY NULL ==> 전체 행을 대상;
 
 GROUP BY job, deptno : 담당업무, 부서별 급여합
 GROUP BY job : 담당업무별 급여합
 GROUP BY : 전체 급여합;
 
 
 GROUP_AD1을 GROUP BY ROLLUP 절을 사용하여 작성;
 SELECT deptno, SUM(sal)
 FROM emp
 GROUP BY ROLLUP (deptno);
 
  SELECT job, deptno,
    GROUPING(job), GROUPING(deptno),
    SUM(sal + NVL(comm, 0)) sal
 FROM emp
 GROUP BY ROLLUP(job, deptno);
 
 SELECT job, deptno, SUM(sal + NVL(comm, 0)) sal
 FROM emp
 GROUP BY ROLLUP(job, deptno);
 
 
 -- GROUP_AD2
 SELECT CASE 
            WHEN GROUPING(job) = 1 AND GROUPING(deptno) = 1 THEN '총계'
                else job
            END job,
        deptno, 
        SUM(sal + NVL(comm, 0)) sal
 FROM emp
 GROUP BY ROLLUP(job, deptno);
 
 -- GROUP_AD2-1 (DECODE)로 해보기
  SELECT DECODE ( GROUPING(job)+ GROUPING(deptno), 2, '총계', 
                                                   1, job,
                                                   0, job) job,
         
        deptno, 
        SUM(sal + NVL(comm, 0)) sal
 FROM emp
 GROUP BY ROLLUP(job, deptno);
 
  -- GROUP_AD2-2 
  SELECT DECODE ( GROUPING(job)+ GROUPING(deptno), 2, '총', 
                                                   1, job,
                                                   0, job) job,
         
         DECODE ( GROUPING(job)+ GROUPING(deptno), 2, '계', 
                                                   1, '소계',
                                                   0, deptno) deptno, 
        SUM(sal + NVL(comm, 0)) sal
 FROM emp
 GROUP BY ROLLUP(job, deptno);
 
 

 
 