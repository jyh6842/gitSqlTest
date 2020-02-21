-- PL/SQL
-- ���� �ǽ� PRO_2
SELECT *
FROM dept_test;
select *
from dept;
 CREATE OR REPLACE PROCEDURE registdept_test(p_deptno IN dept_test.deptno%TYPE,
                                             p_dname IN dept_test.dname%TYPE, 
                                             p_loc IN dept_test.loc%TYPE) IS
--    v_deptno dept_test.deptno%TYPE; -- �ʿ� ����
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

 ���պ��� %rowtype : Ư�� ���̺��� ���� ��� �÷��� ������ �� �ִ� ����
 ��� ��� : ������ ���̺�� %ROWTYPE
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
 ���պ��� RECORD
 �����ڰ� ���� �������� �÷��� ������ �� �ִ� Ÿ���� �����ϴ� ���
 JAVA�� �����ϸ� Ŭ������ �����ϴ� ����
 �ν��Ͻ��� ����� ������ ���� ����;
 
 ����
 TYPE Ÿ���̸�(�����ڰ� ����) IS RECORD(
      ������1 ����Ÿ��
      ������2 ����Ÿ��
 );
 
 ������ Ÿ���̸�;
 
 DECLARE
    TYPE dept_row IS RECORD(
        deptno NUMBER(2),
        dname VARCHAR2(14)
    ); -- �̰� Ÿ�� ����� ����
    
    -- ���� ���� �����
    v_dept_row dept_row;
BEGIN
    SELECT deptno, dname INTO v_dept_row
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE(v_dept_row.deptno || ' ' || v_dept_row.dname);
END;
/


 table type ���̺� Ÿ��
 �� : ��Į�� ����
 �� : %ROWTYPE, record type
 �� : table type
      � ��(%ROWTYPE, RECORD TYPE)�� ������ �� �ִ���
      �ε��� Ÿ���� ��������;
 DEPT ���̺��� ������ ���� �� �ִ� table type�� ����
 ������ ��� ��Į�� Ÿ��, rowtype������ �� ���� ������ ���� �� �־�����
 table Ÿ�� ������ �̿��ϸ� ���� ���� ������ ���� �� �ִ�.
 
 PL/SQL ������ �ڹٿ� �ٸ��� �迭�� ���� �ε����� ������ �����Ǿ� ���� �ʰ� ���ڿ��� �����ϴ�.
 
 �׷��� TABLE Ÿ���� ������ ���� �ε����� ���� Ÿ�Ե� ���� ���
 BINARY_INTEGER Ÿ���� PL/SQL������ ��� ������ Ÿ������
 NUMBER Ÿ���� �̿��Ͽ� ������ ��� �����ϰ� ���� NUBMER Ÿ���� ���� Ÿ���̴�.
 ;
 
 DECLARE 
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    v_dept_tab dept_tab; -- �ڿ� Ÿ�Ը� ���� -- v_dept_tab �迭��
 BEGIN
    SELECT * BULK COLLECT INTO v_dept_tab
    FROM dept;
    -- ���� ��Į�� ����, record Ÿ���� �ǽ��ÿ���
    -- ���ุ ��ȸ �ǵ��� WHERE���� ���� �����Ͽ���.
    
    -- �ڹٿ����� �迭[�ε��� ��ȣ]
    -- PL/SQL������ table����(�ε��� ��ȣ)�� ����
    FOR i IN 1..v_dept_tab.count LOOP
     DBMS_OUTPUT.PUT_LINE(v_dept_tab(i).deptno || ' ' || v_dept_tab(i).dname);
    END LOOP;
--    DBMS_OUTPUT.PUT_LINE(v_dept_tab(1).deptno || ' ' || v_dept_tab(1).dname);
--    DBMS_OUTPUT.PUT_LINE(v_dept_tab(2).deptno || ' ' || v_dept_tab(2).dname);
--    DBMS_OUTPUT.PUT_LINE(v_dept_tab(3).deptno || ' ' || v_dept_tab(3).dname);
--    DBMS_OUTPUT.PUT_LINE(v_dept_tab(4).deptno || ' ' || v_dept_tab(4).dname);
 END;
 /
 
 �������� IF
 ����
 
 IF ���ǹ� THEN
    ���๮;
 ELSE ���ǹ� THEN
    ���๮;
 END IF;
 
 DECLARE 
  p NUMBER(1) := 2; -- ���� ����� ���ÿ� ���� ����
 BEGIN
    IF p = 1 THEN
        DBMS_OUTPUT.PUT_LINE('1�Դϴ�');
    ELSIF p = 2 THEN        
        DBMS_OUTPUT.PUT_LINE('2�Դϴ�');
    ELSE  
        DBMS_OUTPUT.PUT_LINE('�˷����� �ʾҽ��ϴ�');
    END IF;
END;
/

 CASE ����
 1. �Ϲ� ���̽� ( java�� switch�� ����)
 2. �˻� ���̽� ( if, else if, else);
 
 CASE expression
    WHEN value THEN
        ���๮;
    WHEN value THEN
        ���๮;        
    ELSE
        ���๮
 END CASE;
 
 DECLARE
    P NUMBER(1) := 2;
 BEGIN
    CASE p
        WHEN 1 THEN
            DBMS_OUTPUT.PUT_LINE('1�Դϴ�');
        WHEN 2 THEN
            DBMS_OUTPUT.PUT_LINE('2�Դϴ�');
        ELSE
            DBMS_OUTPUT.PUT_LINE('�𸣴� ���Դϴ�');
    END CASE;
 END;
 
 -- �̰� �� �Ϲ����� ���� �ֳ��ϸ� ������ ������ �� �� �־
  DECLARE
    p NUMBER(1) := 2;
 BEGIN
    CASE 
        WHEN p 1 THEN
            DBMS_OUTPUT.PUT_LINE('1�Դϴ�');
        WHEN p THEN
            DBMS_OUTPUT.PUT_LINE('2�Դϴ�');
        ELSE
            DBMS_OUTPUT.PUT_LINE('�𸣴� ���Դϴ�');
    END CASE;
 END;
 
 
 FOR LOOP ����;
 FOR ��������/ �ε��� ���� IN [REVERSE] ���۰�..���ᰪ LOOP
     �ݺ��� ����;
 END LOOP;
 ;
 1���� 5���� FOR LOOP ���� ���;
 
 DECLARE
 BEGIN
    FOR i IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
 END;
 /
 
 -- �ǽ� : 2 ~ 9 �ܱ����� �������� ���
  DECLARE
 BEGIN
    FOR i IN 2..9 LOOP
        FOR j IN 1..9 LOOP
            DBMS_OUTPUT.PUT_LINE(i || '*' || j || '=' || i*j);
         END LOOP;    
    END LOOP;
 END;
 /
 
 while loop ����
 WHILE ���� LOOP
    �ݺ������� ����
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
 
 
 LOOP�� ���� ==> while(true)
 LOOP
    �ݺ������� ����;
    EXIT ����;
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