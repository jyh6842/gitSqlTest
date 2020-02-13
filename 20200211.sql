-- 과제
-- 1. emp_test 테이블을 drop 후 empno, ename, deptno, hp 4개의 컬럼으로 테이블 생성
-- 2. empno, ename, deptno 3가지 컬럼에만 (9999, 'brown', 99) 데이터로 INSERT
-- 3. emp_test 테이블의 hp 컬럼의 기본값을 '010'으로 설정
-- 4. 2번 과정에 입력한 데이터의 hp 컬럼 값이 어떻게 바뀌는지 확인

DROP TABLE emp_test;

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    hp VARCHAR2(20)
);

INSERT INTO emp_test (empno, ename, deptno) VALUES (9999, 'brown', 99);

ALTER TABLE emp_test MODIFY (hp VARCHAR2(20) DEFAULT '010');
commit;

SELECT *
FROM emp_test;

-- 제약조건 확인 방법
 1. tool
 2. dictionary view
 -- 제약조건 : USER_CONSTRAINS
 제약조건-컬럼 : USER_CONS_COLUMNS
 제약조건이 몇개의 컬럼에 관려되어 있는지 알수 없기 때문에 테이블을 별도로 분리하여 설계
 제 1 정규형;
 
 SELECT *
 FROM USER_CONSTRAINTS
 WHERE table_name IN('EMP', 'DEPT', 'EMP_TEST', 'DEPT_TEST');
 
 EMP,DEPT PK, FK 제약이 존재하지 않음
 테이블 수정으로 제약조건 추가;
 
 2. EMP : pk(empno)
 3.       fk(deptno) - dept.deptno
 
 1. dept = pk(deptno);
 
 ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno); 
 ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno); 
 ALTER TABLE emp ADD CONSTRAINT fk_emp_dept FOREIGN KEY (deptno) REFERENCES dept (deptno); 
 
 --
 SELECT *
 FROM member;
 
 테이블, 컬럼 주석 : DICTIONARY 확인 가능
 테이블 주석 : USER_TAB_COMMENTS
 컬럼 주석 : USER_COL_COMMENTS
 
 주석 생성
 테이블 주석 : COMMENT ON TABLE 테이블명 IS '주석'
 컬럼 주석 : COMMENT ON COLUMN 테이블.컬럼 IS '주석';
 
 emp : 직원;
 dept : 부서;
 
 COMMENT ON TABLE emp IS '직원';
 COMMENT ON TABLE dept IS '부서';
 
 SELECT *
 FROM USER_TAB_COMMENTS
 WHERE TABLE_NAME IN ('EMP', 'DEPT');
 
  SELECT *
 FROM USER_COL_COMMENTS
 WHERE TABLE_NAME IN ('EMP', 'DEPT');
 
 DEPT DEPTNO : 부서번호
 DEPT DNAME : 부서명
 DEPT LOC : 부서위치
 EMP EMPNO : 직원 번호
 EMP ENAME : 직원 이름
 EMP JOB : 담당업무
 EMP MGR : 매니저 직원번호
 EMP HIREDATE : 입사일자
 EMP SAL : 급여
 EMP COMM : 성과급
 EMP DEPTNO : 소속부서 번호;
 
 COMMENT ON COLUMN dept.deptno IS '부서번호';
 COMMENT ON COLUMN dept.dname IS '부서명';
 COMMENT ON COLUMN dept.loc IS '부서위치';
 
 COMMENT ON COLUMN emp.empno IS '직원번호';
 COMMENT ON COLUMN emp.ename IS '직원이름';
 COMMENT ON COLUMN emp.job IS '담당업무';
 COMMENT ON COLUMN emp.mgr IS '매니저 직원번호';
 COMMENT ON COLUMN emp.hiredate IS '입사일자';
 COMMENT ON COLUMN emp.sal IS '급여';
 COMMENT ON COLUMN emp.comm IS '성과급';
 COMMENT ON COLUMN emp.deptno IS '소속부서 번호';
 
 -- 실습 comment1
 SELECT *
 FROM USER_TAB_COMMENTS
 WHERE TABLE_NAME IN ('CUSTOMER', 'CYCLE', 'DAILY', 'PRODUCT');
 
 SELECT *
 FROM USER_COL_COMMENTS
 WHERE TABLE_NAME IN ('CUSTOMER', 'CYCLE', 'DAILY', 'PRODUCT');
 
 

SELECT *
FROM USER_TAB_COMMENTS, USER_COL_COMMENTS
WHERE USER_TAB_COMMENTS.TABLE_NAME IN ('CUSTOMER', 'CYCLE', 'DAILY', 'PRODUCT') 
AND USER_TAB_COMMENTS.TABLE_NAME = USER_COL_COMMENTS.TABLE_NAME;


VIEW = QUERY
TABLE 처럼 DBMS에 미리 작성한 객체
==> 작성하지 않고 QUERY에서 바로 작성한 VIEW : IN-LINEVIEW ==> 이름이 없기 때문에 재활용이 불가
VIEW 테이블이다. (X)

사용목적
1. 보안 목적(특정 컬럼을 제외하고 나머지 결과만 개발자에게 제공)
2. INLINE-VIEW를 VIEW로 생성하여 재활용
    .쿼리 길이 단축
    
생성방법
CREATE [OR REPLACE] VIEW 뷰명칭 [(column1, column2...)] AS
SUBQUERY;

emp 테이블에서 8개의 컬럼중 sal, comm 컬럼을 제외한 6개의 컬럼을 제공하는 v_emp VIEW 생성;

CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

시스템 계정에서 PC14 계정으로 VIEW 생성권한 추가
시스템에 가서;
GRANT CREATE VIEW TO jyh6842;
다시 pc14로 돌아와서 작업;

기존 인라인 뷰로 작성시;
SELECT *
FROM (SELECT empno, ename, job, mgr, hiredate, deptno
        FROM emp);
        
VIEW 객체 활용;
 SELECT *
 FROM v_emp;
 
emp 테이블에는 부서명이 없음 ==> dept 테이블과 조인을 비번하게 진행
조인된 결과를 view로 생성 해놓으면 코드를 간결하게 작성하는게 가능;

-- VIEW : v_emp_dept
-- dname(부서명), empno(직원 번호), 직원이름(ename), job(담당업무), hiredate(입사일자)
 CREATE OR REPLACE VIEW v_emp_dept AS
SELECT dept.dname, emp.empno, emp.ename, emp.job, emp.hiredate
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- 인라인 뷰로 작성시
SELECT *
FROM (SELECT dept.dname, emp.empno, emp.ename, emp.job, emp.hiredate
      FROM emp, dept
      WHERE emp.deptno = dept.deptno);
      
-- VIEW 활용시
SELECT *
FROM v_emp_dept;

SMITH 직원 삭제후 v_emp_dept view 건수 변화를 확인; 
DELETE emp
WHERE ename ='SMITH'; //인라인 뷰와 v_emp_dept에서 확인해보면 둘다 삭제 된 것을 볼수 있다.

VIEW는 물리적인 데이터를 갖지 않고, 논리적인 데이터의 정의 집합(SQL)이기 때문에
VIEW에서 참조하는 테이블의 데이터가 변경이 되면 VIEW의 조회 결과도 영향을 받는다.
ROLLBACK;

SEQUENCD : 시퀀스 - 중복되지 않는 정수값을 리턴해주는 오라클 객체
CREATE SEQUENCE 시퀀스 이름
[OPTION ...]
명명 규칙 : SEQ_테이블명;

emp 테이블에서 사용한 시퀀스 생성;

CREATE SEQUENCE seq_emp;

시퀀스 제공 함수
NEXTVAL : 시퀀스에서 다음 값을 가져올 때 사용
CURRVAL : NEXTVAL를 사용하고나서 현재 읽어 들인 값을 재확인;

SELECT seq_emp.NEXTVAL
FROM dual;

SELECT *
FROM emp_test;

INSERT INTO emp_test VALUES (seq_emp.NEXTVAL, 'james', 99, '017');

시퀀스 주의점 
ROLLBACK을 하더라도 NEXTVAL를 통해 얻은 값이 원복되진 않는다.
NEXTVAL를 통해 값을 받아오면 그 값을 다시 사용할 수 없다.



INDEX;
SELECT ROWID, emp.*
FROM emp
WHERE ROWID='AAAE5dAAFAAAACLAAG';

인덱스가 없을때 empno값으로 조회 하는 경우
emp 테이블에서 pk_emp 제약조건을 삭제하여 empno컬럼으로 인덱스가 존재하지 않는 환경을 조성

ALTER TABLE emp DROP CONSTRAINT pk_emp;

explain plan for
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

 emp 테이블의 empno 컬럼으로 PK 제약을 생성하고 동일한 SQL을 실행
 PK: UNIQUE + NOT NULL
     (UNIQUE 인덱스를 생성해준다.)
 ==> empno 컬럼으로 unique 인덱스가 생성됨
 인덱스로 SQL을 실행하게 되면 인덱스가 없을 때와 어떻게 다른지 차이점을 확인;
 
 ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
 
 SELECT rowid, emp.*
 FROM emp;
 
 SELECT empno, rowid
 FROM emp
 ORDER BY empno;
 
 explain plan for
 SELECT *
 FROM emp
 WHERE empno = 7782;
 
 SELECT *
 FROM TABLE(dbms_xplan.display);
 
 INSERT INTO emp VALUES(7369, 'SMITH','CLERK', 7902, TO_DATE('19801217', 'YYYY/MM/DD'),800, NULL, 20); -- 않넣어짐
 
 SELECT *
 FROM emp
 WHERE ename = 'SMITH';
 
 SELECT 조회컬럼이 테이블 접근에 미치는 영향;
 SELECT * FROM emp WHERE empno = 7782;
 
 SELECT empno FROM emp WHERE empno = 7782;
 
  explain plan for
 SELECT *
 FROM emp
 WHERE empno = 7782;
 
 SELECT *
 FROM TABLE(dbms_xplan.display);
 Plan hash value: 2949544139
 
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    87 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    87 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782);

 UNIQUE VS NON-UNIQUE 인덱스의 차이 확인
 1. PK_EMP 삭제
 2. EMPNO 컬럼으로 NON-UNIQUE 인덱스 생성
 3. 실행계획 확인;
 
 ALTER TABLE emp DROP CONSTRAINT pk_emp;
 CREATE INDEX idx_n_emp_01 ON emp(empno);
 
 explain plan for
 SELECT *
 FROM emp
 WHERE empno = 7782;
 
 SELECT *
 FROM TABLE(dbms_xplan.display);

Plan hash value: 2778386618
 
--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_N_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)
 
Note
-----
   - dynamic sampling used for this statement (level=2); 
   
 emp 테이블에 job 컬럼을 기준으로 하는 새로운 non-unique 인덱스를 생성;

 CREATE INDEX idx_n_emp_02 ON emp (job); //emp로 인덱스 만듬 2번째 인덱스를 활용해서 찾는다. 인덱스를 잘 활용하면 실행 속도가 빠르다.
 
 SELECT job, rowid
 FROM emp
 ORDER BY job;
 
 -- 선택가능한 사항
 1. emp 테이블을 전체 읽기
 2. idx_n_emp_01(empno) 활용
 3. idx_n_emp_02(job) 활용; -- 이거 사용하는게 좋다. 내가 원하는 값을 딱 얻을 수 있음 -- 이거 실행할지는 모름
 explain plan for
 SELECT *
 FROM emp
 WHERE job = 'MANAGER';
 
 select *
 from table(dbms_xplan.display);
 Plan hash value: 2645879471
 
-------------------------------------------------------------------------------------------
| Id  | Operation                   | Name        | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |             |     3 |   261 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP         |     3 |   261 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_N_EMP_02 |     1 |       |     1   (0)| 00:00:01 |
-------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')
 
Note
-----
   - dynamic sampling used for this statement (level=2);