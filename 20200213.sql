-- synonym : ���Ǿ�
-- 1. ��ü ��Ī�� �ο�
--     ==> �̸��� �����ϰ� ǥ��
--    
-- sem ����ڰ� �ڽ��� ���̺� emp���̺��� ����ؼ� ���� v_emp view
-- hr ����ڰ� ����� �� �ְ� �� ������ �ο�

-- v_emp : �ΰ��� ���� sal, comm �� ������ view

-- hr ����� v_emp�� ����ϱ� ���� ������ ���� �ۼ�
 SELECT *
 FROM jyh6842.v_emp;

-- hr ��������
-- synonym sem.v_empo ==> v_emp
-- v_emp == sem.v_emp

 SELECT *
 FROM v_emp; 
 
-- 1. sem �������� v_emp�� hr �������� ��ȸ�� �� �ֵ��� ��ȸ���� �ο�;
-- GRANT SELECT ON v_emp TO hr;

-- 2. hr ���� v_emp ��ȸ�ϴ°� ���� (���� 1������ �޾ұ� ������)
--   ���� �ش� ��ü�� �����ڸ� ��� : sem.v_emp
--   �����ϰ� sem.v_emp ==> v_emp ����ϰ� ���� ��Ȳ
--   synonym ����
  
-- CREATE SYNONYM �ó�� �̸� FOR ����ü��;
 
 SELECT *
 FROM v_emp;
 
-- SYNONYM ����
-- DROP SYNONYM �ó�� �̸�;

-- GRANT CONNECT TO SEM; -- �ý��� ����
-- GRANT SELECT ON ��ü�� TO HR; -- ��ü����

 ���� ����
 1. �ý��� ���� : TABLE�� ����, VIEW ���� ���� ...
 2. ��ü ���� : Ư�� ��ü�� ���� SELECT, UPDATE, INSERT, DELETE...
 
 ROLE : ������ ��Ƴ��� ����
 ����ں��� ���� ������ �ο��ϰ� �Ǹ� ������ �δ�.
 Ư�� ROLE�� ������ �ο��ϰ� �ش� ROLE ����ڿ��� �ο�
 �ش� ROLE�� �����ϰ� �Ǹ� ROLE�� ���� �ִ� ��� ����ڿ��� ����
 
 ���� �ο�/ȸ��
 �ý��� ���� : GRANT �����̸� TO ����� | ROLE;
             REVOKE �����̸� FROM ����� | ROLE;
 ��ü ���� : GRANT �����̸� ON ��ü�� TO ����� | ROLE;
           REVOKE �����̸� ON ��ü�� FROM ����� | ROLE;
           
           
 data dictionary : ����ڰ� �������� �ʰ�, dbms�� ��ü������ �����ϴ� �ý��� ������ ���� view;
 
 data dictionary ���ξ�
 1. USER : �ش� ����ڰ� ������ ��ü
 2. ALL : �ش� ����ڰ� ������ ��ü + �ٸ� ����ڷκ��� ������ �ο� ���� ��ü
 3. DBA : ��� ������� ��ü
 
 * V$ Ư�� VIEW;
 
 SELECT *
 FROM USER_TABLES;
 
 SELECT *
 FROM ALL_TABLES;
 
 SELECT *
 FROM DBA_TABLES; -- �츮�� �Ϲ� ����ڶ� ��ȸ�� �ȵȴ�.
 
 DICTIONARY ���� Ȯ�� : SYS.DICTIONARY;
 
 SELECT *
 FROM DICTIONARY;
 
 ��ǥ���� dictionary
 OBJECT : ��ü ���� ��ȸ(���̺�, �ε���, VIEW, SYSNONYM... ) 
 TABLE : ���̺� ������ ��ȸ
 TAB_COLUMNS : ���̺��� �÷� ���� ��ȸ
-- INDEXS : �ε��� ���� ��ȸ -- ���� ��ȹ�� �� ���̶�� 
-- IND_COLUMNS : �ε��� ���� �÷� ��ȸ -- ���� ��ȹ�� �� ���̶�� �� 2���� �߿��ϴ�.
 CONSTRAINTS : �������� ��ȸ
 CONS_COLUMNS : �������� ���� �÷� ��ȸ
 TAB_COMMENTS : ���̺� �ּ�
 COL_COMMENTS : ���̺��� �÷� �ּ�;
 
 SELECT *
 FROM USER_OBJECTS; -- OBJECT_TYPE�� ���� ����ڰ� ������ �մ� ��ü�� ��� ���� �ְ� ��� ���� �ִ��� �˼� �����Ŵ�.
 
 emp, dept ���̺��� �ε����� �ε��� �÷� ���� ��ȸ;
 user_indexes, user_ind_columns join
 ���̺� ��,     �ε��� ��,      �÷���
 emp,       ind_n_emp04,    ename
 emp,       ind_n_emp04,    job
 
 -- ���̺� �ε���
 SELECT *
 FROM USER_indexes;
 
 -- �ε��� �÷� 
 SELECT *
 FROM user_ind_columns;
 
 --  emp, dept ���̺��� �ε����� �ε��� �÷� ���� ��ȸ
 SELECT table_name, index_name, column_name, column_position
 FROM user_ind_columns
 ORDER BY table_name, index_name, column_name, column_position;
 
 
 
 
 ----------------------------------------------------------------------------
 
 multiple insert : �ϳ��� insert �������� ���� ���̺� �����͸� �Է��ϴ� DML;
 UPDATE dept_test SET loc = '����' WHERE loc = 'daejeon'; -- ���� �ȹٲ� ���� ���� ��
 commit;

 SELECT *
 FROM dept_test;
 
 SELECT *
 FROM dept_test2;
 
 ������ ���� ���� ���̺� ���� �Է��ϴ� multiple insert;
 INSERT ALL
    INTO dept_test
    INTO dept_test2
 SELECT 98, '���', '�߾ӷ�' FROM dual UNION ALL 
 SELECT 97, 'IT', '����' FROM dual;
 
 
 ���̺� �Է��� �÷��� ���� mutiple insert;
 ROLLBACK;
 
 INSERT ALL
    INTO dept_test (deptno, loc) VALUES ( deptno, loc)
    INTO dept_test2
 SELECT 98 deptno, '���' dname, '�߾ӷ�' loc FROM dual UNION ALL 
 SELECT 97, 'IT', '����' FROM dual; -- ���� ���̺� ���� ���� ���� ���� ���̺� �ۼ��� �߸� �Ǿ��� Ȯ���� ����
 
 ���̺� �Է��� �����͸� ���ǿ� ���� multiple insert;
 CASE
    WHEN ���� ��� THEN 
 END;

 ROLLBACK;
 INSERT ALL
    WHEN deptno = 98 THEN -- 98�̶�� ���ǿ� �����ؼ� insert �� 1�� �Է�
        INTO dept_test (deptno, loc) VALUES ( deptno, loc)
        INTO dept_test2
    ELSE
        INTO dept_test2
 SELECT 98 deptno, '���' dname, '�߾ӷ�' loc FROM dual UNION ALL 
 SELECT 97, 'IT', '����' FROM dual; -- else �κ��� insert �� 2�� �Էµ�
 
 SELECT *
 FROM dept_test;
 
 SELECT *
 FROM dept_test2;
 
 ������ �����ϴ� ù��° insert�� �����ϴ� multiple insert;
 
ROLLBACK;


 INSERT FIRST -- FIRST �� ������ �����ϴ� ù��° ���ǹ��� �����
    WHEN deptno >= 98 THEN
        INTO dept_test (deptno, loc) VALUES ( deptno, loc)
    WHEN deptno >= 97 then
        INTO dept_test2
    ELSE
        INTO dept_test2
 SELECT 98 deptno, '���' dname, '�߾ӷ�' loc FROM dual UNION ALL -- 98�̶�� ���ǿ� �����ؼ� insert �� 1�� �Է�
 SELECT 97, 'IT', '����' FROM dual; -- else �κ��� insert �� 2�� �Էµ�
 
 SELECT *
 FROM dept_test;
 
 SELECT *
 FROM dept_test2;
 -----------------------------------------
 -- ���� �ߴ� �ε��� �߰� ����
 ����Ŭ ��ü : ���̺� �������� ������ ��Ƽ������ ����
 ���̺� �̸��� �����ϳ� ���� ������ ���� ����Ŭ ���������� ������ �и��� ������ �����͸� ����;
 
 dept_test ==> dept_test_20200201
 
 INESRT FIRST
    WHEN deptno >=98 THEN
        INTO dept_test
    WHEN dpetno >= 97 THEN
        INTO dept_test_20200202
    ELSE
        INTO dept_test2
    SELECT 98 deptno, '���' dname, '�߾ӷ�' loc FROM dual UNION ALL
    SELECT 97, 'IT', '����' FROM dual;
--------------------------- ������� �߰� ����

 MERGE : ����
 ���̺� �����͸� �Է�/���� �Ϸ��� ��
 1. ���� �Է��Ϸ��� �ϴ� �����Ͱ� �����ϸ�
    ==> ������Ʈ
 2. ���� �Է��Ϸ��� �ϴ� �����Ͱ� �������� ������ 
    ==> INSERT

 1. SELECT ����
 2-1. SELECT ���� ����� 0 ROW�̸� INSERT
 2-2. SELECT ���� ����� 1 ROW�̸� UPDATE
 
 MERGE ������ ����ϰ� �Ǹ� SELECT �� ���� �ʾƵ� �ڵ����� ������ ������ ����
 INSERT Ȥ�� UPDATE �����Ѵ�.
 2���� ������ �ѹ����� �ش�.
 
 MERGE INTO ���̺�� [alias]
 USING (TABLE | VIEW | IN-LINE-VIEW)
 ON (��������)
 WHEN MATCHED THEN
    UPDATE SET col1  = �÷���, col2  = �÷���,...
 WHEN NOT MATCHED THEN
    INSERT (�÷�1, �÷�2...) VALUES (�÷���1, �÷���2...);
    
    ���̺���� ������ �̹� ��� �߱� ������ UPDATE �ϰų� INSERT �Ҷ����� �� �ʿ䰡 ����
    
 SELECT *
 FROM emp_test;

 DELETE emp_test;

 �α׸� �ȳ����. ==> ������ �ȵȴ� ==> �׽�Ʈ������...
 TRUNCATE TABLE emp_test;

 emp ���̺��� emp_test ���̺�� �����͸� ���� (7369-SMITH);
 
 INSERT INTO emp_test
 SELECT empno, ename, deptno, '010'
 FROM emp
 WHERE empno = 7369;
 
 �����Ͱ� �� �Է� �Ǿ����� Ȯ��;
 
 SELECT *
 FROM emp_test;
 
 �̸��� �ٲ㺸��;
 UPDATE emp_test SET ename = 'brown'
 WHERE empno = 7369;
 commit;
 
 emp ���̺��� ��� ������ emp_test���̺�� ����
 emp ���̺��� ���������� emp_test���� �������� ������ insert
 emp ���̺��� �����ϰ� emp_test���� �����ϸ� ename, deptno�� update;
 
 emp ���̺� �����ϴ� 14���� �������� emp_test���� �����ϴ� 7369�� ������ 13���� �����Ͱ�
 emp_test ���̺� �űԷ� �Է��� �ǰ�
 emp_test�� �����ϴ� 7369���� �����ʹ� ename(brown)�� emp���̺� �����ϴ� �̸��� SMITH�� ����.;
 
 MERGE INTO emp_test a
 USING emp b
 ON (a.empno = b.empno )
 WHEN MATCHED THEN
    UPDATE SET a.ename = b.ename, 
               a.deptno = b.deptno
 WHEN NOT MATCHED THEN
    INSERT (empno, ename, deptno) VALUES (b.empno, b.ename, b.deptno);
    
 SELECT *
 FROM emp_test; ==> brown ���� SMITH�� �ٲ����.
 -------------------------------------------------------------------------- 
 �ش� ���̺� �����Ͱ� ������ insert, ������ update
 emp_test ���̺� ����� 9999���� ����� ������ ���Ӱ� insert
 ������ update
 (9999,'brown', 10, '010');
 
 INSERT INTO dept_test VALUES (9999, 'brown', 10, '010');
 
 UPDATE dept_test SET ename = 'brown'
                      deptno = 10
                      hp = '010'
 WHERE empno = 9999;
 
 select *
 from dept_test;
 
 ------------------------- �̰Ŵ� ��ģ�� �����ַ��� �� ���� ���ε� �ȵǴ� ���� ����
 
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
 

 
 merge, window function(�м��Լ�);
 
 -- �ǽ� GROUP_AD1
 SELECT null, SUM(sal)
 FROM emp
 
 union all
 
 select deptno, sum(sal)
 from emp
 group by deptno;

 
 
 I/O ���� �Ӱ� ���� �����?
 CPU CACHE RAM > SSD > HDD > NETWORK;
 
 REPORT GROP FUNCTION
 ROLLUP
 CUBE
 GROUPING;
 
 ROLLUP
 ��� ��� : GROUP BY ROLLUP (�÷�1, �÷�2...)
 SUBGROUP�� �ڵ����� ����
 SUBGROUP�� �����ϴ� ��Ģ : ROLLUP�� ����� �÷��� [������]�������� �ϳ��� �����ϸ鼭 
                         SUB GROUP�� ����;
 EX : GROUP BY ROLLUP (deptno)
 ==> 
 ù��° sub group : GROUP BY deptno
 �ι�° sub group : GROUP BY NULL ==> ��ü ���� ���;
 
 GROUP BY job, deptno : ������, �μ��� �޿���
 GROUP BY job : �������� �޿���
 GROUP BY : ��ü �޿���;
 
 
 GROUP_AD1�� GROUP BY ROLLUP ���� ����Ͽ� �ۼ�;
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
            WHEN GROUPING(job) = 1 AND GROUPING(deptno) = 1 THEN '�Ѱ�'
                else job
            END job,
        deptno, 
        SUM(sal + NVL(comm, 0)) sal
 FROM emp
 GROUP BY ROLLUP(job, deptno);
 
 -- GROUP_AD2-1 (DECODE)�� �غ���
  SELECT DECODE ( GROUPING(job)+ GROUPING(deptno), 2, '�Ѱ�', 
                                                   1, job,
                                                   0, job) job,
         
        deptno, 
        SUM(sal + NVL(comm, 0)) sal
 FROM emp
 GROUP BY ROLLUP(job, deptno);
 
  -- GROUP_AD2-2 
  SELECT DECODE ( GROUPING(job)+ GROUPING(deptno), 2, '��', 
                                                   1, job,
                                                   0, job) job,
         
         DECODE ( GROUPING(job)+ GROUPING(deptno), 2, '��', 
                                                   1, '�Ұ�',
                                                   0, deptno) deptno, 
        SUM(sal + NVL(comm, 0)) sal
 FROM emp
 GROUP BY ROLLUP(job, deptno);
 
 

 
 