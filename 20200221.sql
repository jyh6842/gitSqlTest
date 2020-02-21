-- PL/SQL
-- 생성 실습 PRO_2
SELECT *
FROM dept_test;
select *
from dept;
 CREATE OR REPLACE PROCEDURE registdept_test(p_deptno IN dept_test.deptno%TYPE,
                                             p_dname IN dept_test.dname%TYPE, 
                                             p_loc IN dept_test.loc%TYPE) IS
--    v_deptno dept_test.deptno%TYPE; -- 필요 없음
--    v_dname dept_test.dname%TYPE;
--    v_loc dept_test.loc%TYPE;
 BEGIN
--    v_deptno := p_deptno;
--    v_dname := p_dname;
--    v_loc := p_loc;
--    v_empcnt := p_empcnt;
    
--    INSERT INTO dept_test (deptno, dname, loc) VALUES(v_deptno, v_dname, v_loc);
    INSERT INTO dept_test (deptno, dname, loc, empcnt) VALUES(p_deptno, p_dname, p_loc, 0);
--    DBMS_OUTPUT.PUT_LINE(v_empno || ', ' || v_ename || ', ' || v_dname);
    COMMIT;
    
 END;
/

 exec registdept_test(96, 'ddit', 'dajeon');
 
 -- pt 19 PRO_3
  CREATE OR REPLACE PROCEDURE UPDATEdept_test(p_deptno IN dept_test.deptno%TYPE,
                                             p_dname IN dept_test.dname%TYPE, 
                                             p_loc IN dept_test.loc%TYPE) IS

 BEGIN

    UPDATE dept_test SET dname = p_dname, loc=p_loc
    WHERE deptno = p_deptno;
    
    COMMIT;
 
 END;
/

EXEC UPDATEdept_test(96, 'ddit_m', 'daejeon');

 복합변수 %rowtype : 특정 테이블의 행의 모든 컬럼을 저장할 수 있는 변수
 사용 방법 : 변수명 테이블명 %ROWTYPE
 ;
 
DECLARE
    v_dept_row dept%ROWTYPE;
BEGIN
    SELECT * INTO v_dept_row
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE(v_dept_row.deptno || ' ' || v_dept_row.dname || v_dept_row.loc);
    
END;
/

-- PT21
 복합변수 RECORD
 개발자가 직접 여러개의 컬럼으 관리할 수 있는 타입을 생성하는 명령
 JAVA를 비유하면 클래스를 선언하는 과정
 인스턴스를 만드는 과정은 변수 선언;
 
 문법
 TYPE 타입이름(개발자가 지정) IS RECORD(
      변수명1 변수타입
      변수명2 변수타입
 );
 
 변수명 타입이름;
 
 DECLARE
    TYPE dept_row IS RECORD(
        deptno NUMBER(2),
        dname VARCHAR2(14)
    ); -- 이게 타입 만들기 선언
    
    -- 이제 변수 만들기
    v_dept_row dept_row;
BEGIN
    SELECT deptno, dname INTO v_dept_row
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE(v_dept_row.deptno || ' ' || v_dept_row.dname);
END;
/


 table type 테이블 타입
 점 : 스칼라 변수
 선 : %ROWTYPE, record type
 면 : table type
      어떤 선(%ROWTYPE, RECORD TYPE)을 저장할 수 있는지
      인덱스 타입은 무엇인지;
 DEPT 테이블의 정보를 담을 수 있는 table type을 선언
 기존에 배운 스칼라 타입, rowtype에서는 한 행의 정보를 담을 수 있었지만
 table 타입 변수를 이용하면 여러 행의 정보를 담을 수 있다.
 
 PL/SQL 에서는 자바와 다르게 배열에 대한 인덱스가 정수로 고정되어 잇지 않고 문자열도 가능하다.
 
 그래서 TABLE 타입을 선언할 때는 인덱스에 대한 타입도 같이 명시
 BINARY_INTEGER 타입은 PL/SQL에서만 사용 가능한 타입으로
 NUMBER 타입을 이용하여 정수만 사용 가능하게 끔한 NUBMER 타입의 서브 타입이다.
 ;
 
 DECLARE 
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    v_dept_tab dept_tab; -- 뒤에 타입명 붙임 -- v_dept_tab 배열임
 BEGIN
    SELECT * BULK COLLECT INTO v_dept_tab
    FROM dept;
    -- 기존 스칼라 변수, record 타입을 실습시에는
    -- 한행만 조회 되도록 WHERE절을 통해 제한하였다.
    
    -- 자바에서는 배열[인덱스 번호]
    -- PL/SQL에서는 table변수(인덱스 번호)로 접근
    FOR i IN 1..v_dept_tab.count LOOP
     DBMS_OUTPUT.PUT_LINE(v_dept_tab(i).deptno || ' ' || v_dept_tab(i).dname);
    END LOOP;
--    DBMS_OUTPUT.PUT_LINE(v_dept_tab(1).deptno || ' ' || v_dept_tab(1).dname);
--    DBMS_OUTPUT.PUT_LINE(v_dept_tab(2).deptno || ' ' || v_dept_tab(2).dname);
--    DBMS_OUTPUT.PUT_LINE(v_dept_tab(3).deptno || ' ' || v_dept_tab(3).dname);
--    DBMS_OUTPUT.PUT_LINE(v_dept_tab(4).deptno || ' ' || v_dept_tab(4).dname);
 END;
 /
 
 조건제어 IF
 문법
 
 IF 조건문 THEN
    실행문;
 ELSE 조건문 THEN
    실행문;
 END IF;
 
 DECLARE 
  p NUMBER(1) := 2; -- 변수 선언과 동시에 값을 대입
 BEGIN
    IF p = 1 THEN
        DBMS_OUTPUT.PUT_LINE('1입니다');
    ELSIF p = 2 THEN        
        DBMS_OUTPUT.PUT_LINE('2입니다');
    ELSE  
        DBMS_OUTPUT.PUT_LINE('알려지지 않았습니다');
    END IF;
END;
/

 CASE 구문
 1. 일반 케이스 ( java의 switch와 유사)
 2. 검색 케이스 ( if, else if, else);
 
 CASE expression
    WHEN value THEN
        실행문;
    WHEN value THEN
        실행문;        
    ELSE
        실행문
 END CASE;
 
 DECLARE
    P NUMBER(1) := 2;
 BEGIN
    CASE p
        WHEN 1 THEN
            DBMS_OUTPUT.PUT_LINE('1입니다');
        WHEN 2 THEN
            DBMS_OUTPUT.PUT_LINE('2입니다');
        ELSE
            DBMS_OUTPUT.PUT_LINE('모르는 값입니다');
    END CASE;
 END;
 
 -- 이게 더 일반적인 형태 왜냐하면 조건을 여러개 달 수 있어서
  DECLARE
    p NUMBER(1) := 2;
 BEGIN
    CASE 
        WHEN p 1 THEN
            DBMS_OUTPUT.PUT_LINE('1입니다');
        WHEN p THEN
            DBMS_OUTPUT.PUT_LINE('2입니다');
        ELSE
            DBMS_OUTPUT.PUT_LINE('모르는 값입니다');
    END CASE;
 END;
 
 
 FOR LOOP 문법;
 FOR 루프변수/ 인덱스 변수 IN [REVERSE] 시작값..종료값 LOOP
     반복할 로직;
 END LOOP;
 ;
 1부터 5까지 FOR LOOP 숫자 출력;
 
 DECLARE
 BEGIN
    FOR i IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
 END;
 /
 
 -- 실습 : 2 ~ 9 단까지의 구구단을 출력
  DECLARE
 BEGIN
    FOR i IN 2..9 LOOP
        FOR j IN 1..9 LOOP
            DBMS_OUTPUT.PUT_LINE(i || '*' || j || '=' || i*j);
         END LOOP;    
    END LOOP;
 END;
 /
 
 while loop 문법
 WHILE 조건 LOOP
    반복실행할 로직
 END LOOP
 ;
 --
    
 DECLARE
   i NUMBER  := 0;
 BEGIN
     WHILE i <= 5 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
        i := i+1;
    END LOOP;
 END;
 /
 
 
 LOOP문 문법 ==> while(true)
 LOOP
    반복실행할 문자;
    EXIT 조건;
 END LOOP;
 
 DECLARE
    i NUMBER := 0;
 BEGIN
    LOOP
        EXIT WHEN i > 5;
        DBMS_OUTPUT.PUT_LINE(i);
        i := i+1;
    END LOOP;
 END;
 /