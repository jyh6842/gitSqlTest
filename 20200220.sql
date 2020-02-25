SELECT *
FROM no_emp;

 1. leaf ���(��)�� � ���������� Ȯ��
 2. LEVEL ==> ���� Ž���� �׷��� ���� ���� �ʿ��� ��
 3. leaf ������ ���� Ž��, ROWNUM;


SELECT LPAD(' ', (LEVEL-1)*4) || org_cd, total 
FROM
    (SELECT org_cd, parent_org_cd, SUM(total) total
     FROM
        (SELECT org_cd, parent_org_cd, no_emp,
               SUM(no_emp) OVER (PARTITION BY gno ORDER BY rn ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) total
         FROM
            (SELECT org_cd, parent_org_cd, lv, ROWNUM rn, lv+ROWNUM gno, -- �������� ���� ����
                    no_emp / COUNT(*) OVER (PARTITION BY org_cd) no_emp -- �ߺ����� ���ֱ����ؼ�
             FROM
                (SELECT no_emp.*, LEVEL lv, CONNECT_BY_ISLEAF leaf 
                 FROM no_emp
                 START WITH parent_org_cd IS NULL
                 CONNECT BY PRIOR org_cd = parent_org_cd)
             START WITH leaf = 1
             CONNECT BY PRIOR parent_org_cd = org_cd))
        GROUP BY org_cd, parent_org_cd)
START WITH parent_org_cd IS NULL
CONNECT BY PRIOR org_cd = parent_org_cd;

-- �ǽ��� ���� ���̺� �����
DROP TABLE gis_dt;
-- CTAS ��
CREATE TABLE gis_dt AS
SELECT SYSDATE + ROUND(DBMS_RANDOM.value(-30, 30)) dt,
       '����� ����� ������ Ű��� ���� ���� ������ �Դϴ� ����� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴ�' v1
FROM dual
CONNECT BY LEVEL <= 1000000;

CREATE INDEX idx_n_gis_dt_01 ON gis_dt (dt, v1);
--------------------

SELECT *
FROM gis_dt;

-- gis_dt�� dt �÷����� 2020�� 2���� �ش��ϴ� ��¥�� �ߺ����� �ʰ� ���Ѵ� : �ִ� 29���� ��
SELECT TO_DATE(dt, 'YYYY-MM-DD'), v1, COUNT(*)
FROM gis_dt
WHERE dt >= TO_DATE('202002', 'YYYYMM') AND dt < TO_DATE('202003', 'YYYYMM')
GROUP BY TO_DATE(dt, 'YYYY-MM-DD'), v1;

SELECT DISTINCT dt, v1
FROM gis_dt
WHERE dt BETWEEN TO_DATE('20200201', 'YYYYMMDD') AND TO_DATE('20200229 23:59:59', 'YYYYMMDD hh24:mi:ss');

-- ��� �ϸ� ������ ��ȸ�� �� ������? ������ ���� ������

SELECT *
FROM
    (SELECT TO_DATE('20200201', 'YYYYMMDD') + (LEVEL-1) dt
     FROM dual
     CONNECT BY LEVEL <= 29) a
WHERE EXISTS ( SELECT 'X'
               FROM gis_dt
               WHERE gis_dt.dt BETWEEN dt AND TO_DATE(TO_CHAR(dt, 'YYYYMMDD') || '235959', 'YYYYMMDDHH24MISS'));
               
SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

PL/SQL ��� ����
DECLARE : ����, ��� ���� [���� ����]
BEGIN : ���� ��� [���� �Ұ�]
EXCEPTION : ���� ó�� [���� ����]

PL/SQL ������
�ߺ� �Ǵ� ������ ���� Ư����
���Կ����ڰ� �Ϲ����� ���α׷��� ���� �ٸ���.
java =
pl/sql :=

PL/SQL ��������
JAVA : Ÿ�� ������ (String str;
PL/SQL : ������ Ÿ�� (deptno NUMBER(2);)

PL/SQL �ڵ� ������ ���� ����� JAVA�� �����ϰ� �����ݷ��� ����Ѵ�.
java : String str;
pl/sql : deptno NUMBER(2);

PL/SQL ����� ���� ǥ���ϴ� ���ڿ� : /
SQL�� ���� ���ڿ�;

�μ� ���̺��� 10�� �μ��� �μ���ȣ�� �μ��̸��� PL/SQL ������ �����ϰ�
������ ���;

Hello World ���;

SET SERVEROUTPUT ON;

DECLARE
    msg VARCHAR2(50);
BEGIN
    msg := 'Hello, World!';
    DBMS_OUTPUT.PUT_LINE(msg); -- PL/SQL���� System.out.println �� ���Ұ� ������ �ܿ��ֶ�
END; -- �̸��� ����
/
�μ� ���̺��� 10�� �μ���ȣ��, �μ��̸��� PL/SQL ������ �����ϰ� ������ ���;

DECLARE 
    v_deptno NUMBER(2);
    v_dname VARCHAR2(14);
BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    --WHERE deptno = 10; -- ����� �������� ���� ���;��ϱ� ������ �ȵ�
    
    DBMS_OUTPUT.PUT_LINE(v_deptno || ' : ' || v_dname);
END;
/


PL/SQL ���� Ÿ��
�μ� ���̺��� �μ���ȣ, �μ����� ��ȸ�Ͽ� ������ ��� ����
�μ���ȣ, �μ����� Ÿ���� �μ� ���̺� ���ǰ� �Ǿ�����

NUMBER, VARCHAR2 Ÿ���� ���� ����ϴ°� �ƴ϶� �ش� ���̺��� �÷��� Ÿ���� �����ϵ���
���� Ÿ���� ������ �� �ִ�.
v_deptno NUMBER(2) ==> dept.deptno%TYPE -- �ش� �÷��� ������ �� �ְ� ������ִ°�
;
DECLARE 
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = 10; -- ����� �������� ���� ���;��ϱ� ������ �ȵ� (���� �ۿ� �ȵ�)
    
    DBMS_OUTPUT.PUT_LINE(v_deptno || ' : ' || v_dname); -- DBMS_OUTPUT.PUT_LINE == sysout�� ���� ������ ��
END;
/

-- pt10
 ���ν��� ��� ����
 �͸� ���(�̸��� ���� ��)
 . ������ �Ұ����ϴ�.(IN-LINE VIEW VS VIEW)
 
 ���ν��� (�̸��� �ִ� ��)
 . ������ �����ϴ�.
 . �̸��� �ִ�.
 . ���ν����� ������ �� �Լ�ó�� ���ڸ� ���� �� �ִ�.
 
 �Լ� (�̸��� �ִ� ��)
 . ������ �����ϴ�.
 . �̸��� �ִ�.
 . ���ν����� �ٸ����� ���� ���� �ִ�.;
 
 ���ν��� ����
 CREATE OR REPLACE PROCEDURE ���ν��� �̸� is (IN param, OUT param, IN OUT PARAM) -- �������°��� �޴°���? IN, OUT, INOUT
    ����� (DECLARE���� ������ ����)
    BEGIN
    EXCEPTION (�ɼ�)
 END;
 /
 
 �μ� ���̺��� 10�� �μ��� �μ���ȣ�� �μ��̸��� PL/SQL ������ �����ϰ�
 DBMS.OUTPUT.PUT_LINE �Լ��� �̿��Ͽ� ȭ�鿡 ����ϴ� printdept, ���ν����� ����;
 
 CREATE OR REPLACE PROCEDURE printdept IS
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
 BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = 10;
        
    DBMS_OUTPUT.PUT_LINE(v_deptno || ' : ' || v_dname);
 END;
 /
 
 ���ν��� ���� ���
 exec ���ν�����(����...);
 
 printdept_p ���ڷ� �μ���ȣ�� �޾Ƽ�
 �ش� �μ���ȣ�� �ش��ϴ� �μ��̸��� ���������� �ֿܼ� ����ϴ� ���ν���;
 
 CREATE OR REPLACE PROCEDURE printdept_p(p_deptno IN dept.deptno%TYPE) IS
    v_dname dept.dname%TYPE;
    v_loc dept.loc%TYPE;
 BEGIN
    SELECT dname, loc INTO v_dname, v_loc --(INTO�� ���� ������ �޴� ��)
    FROM dept
    WHERE deptno = p_deptno;
    
    DBMS_OUTPUT.PUT_LINE(v_dname || ', ' || v_loc);
 END;
 /
 
 exec printdept_p(50);
 
 SELECT *
 FROM emp;
 
 SET SERVEROUTPUT ON; -- �̰� �ؾ� PL/SQL�� �����

 CREATE OR REPLACE PROCEDURE printemp(p_empno IN emp.empno%TYPE) IS
    v_empno emp.empno%TYPE;
    v_ename emp.ename%TYPE;
    v_dname dept.dname%TYPE;
 BEGIN
    SELECT empno, ename, dname INTO v_empno, v_ename, v_dname
    FROM emp, dept
    WHERE empno = p_empno AND emp.deptno = dept.deptno;
    
    DBMS_OUTPUT.PUT_LINE(v_empno || ', ' || v_ename || ', ' || v_dname);
 END;
 /
 
 exec printemp(7499);