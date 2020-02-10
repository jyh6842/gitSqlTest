

-- 1. PRIMARY KEY ���� ���� ������ ����Ŭ dbms�� �ش� �÷����� unique index�� �ڵ����� �����Ѵ�.
--    (*** ��Ȯ���� UNIQUE ���࿡ ���� UNIQUE �ε����� �ڵ����� �����ȴ�.
--        PRIMARY KEY = UNIQUE + NOT NULL )
-- index : �ش� �÷����� �̸� ������ �س��� ��ü
-- ������ �Ǿ��ֱ� ������ ã���� �ϴ� ���� �����ϴ��� ������ �˼��� �ִ�.
-- ���࿡ �ε����� ���ٸ� ���ο� �����͸� �Է��� ��
-- �ߺ��Ǵ� ���� ã�� ���ؼ� �־��� ��� ���̺��� ��� �����͸� ã�ƾ� �Ѵ�.
-- ������ �ε����� ������ �̹� ������ �Ǿ��ֱ� ������ �ش� ���� ���� ���¸� ������ �˼��� �ִ�.;

 2. FOREIGN KEY �������ǵ�
 �����ϴ� ���̺� ���� �ִ����� Ȯ���ؾ��Ѵ�.
 �׷��� �����ϴ� �÷��� �ε����� �վ������ FOREIGN KEY ������ ������ ���� �ִ�.;
 
  FOREIGN KEY ������ �ɼ�
  FOREIGN KEY (���� ���Ἲ) : �����ϴ� ���̺��� �÷��� �����ϴ� ���� �Է� �� �� �ֵ��� ����
  (ex : emp ���̺� ���ο� �����͸� �Է½� deptno �÷����� dept ���̺� �����ϴ� �μ���ȣ�� �Է� �� �� �ִ�.);
  
  FOREIGN KEY �� �����ʿ� ���� �����͸� ������ �� ������
  � ���̺��� �����ϰ� �ִ� �����͸� �ٷ� ������ �ȵ�
  (ex : EMP.deptno ==> DEPT.deptno �÷��� �����ϰ� ���� ��
        �μ� ���̺��� �����͸� ���� �� ���� ����);
        
 SELECT *
 FROM emp_test;
 
 select *
 FROM dept_test;
 
 INSERT INTO dept_test VALUES (98, 'ddit2', '����');
 INSERT INTO emp_test (empno, ename, deptno) VALUES (9999, 'brown', 99);
 emp : 9999, 99
 dept : 98, 99
 ==> 98�� �μ��� �����ϴ� emp ���̺��� �����ʹ� ����
     99�� �μ��� �����ϴ� emp ���̺��� �����ʹ� 9999�� ����� ����
 
 ���࿡ ���� ������ �����ϰ� �Ǹ�;
 DELETE dept_test
 WHERE deptno = 99;
 
 emp ���̺��� �����ϴ� �����Ͱ� ���� 98�� �μ��� �����ϸ� ?? ;
 DELETE dept_test
 WHERE deptno = 98;
 
 FOREIGN KEY �ɼ�
 1. ON DELETE CASCADE : �θ� ������ ���(dept) �����ϴ� �ڽ� �����͵� ���� �����Ѵ�(emp)
 2. ON DELETE SET NULL : �θ� ������ ���(dept) �����ϴ� �ڽ� �������� �÷��� NULL�� ����
 
 emp_test ���̺��� DROP�� �ɼ��� ������ ���� ������ ���� �׽�Ʈ;
 DROP TABLE emp_test;
 CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2), 
    
    CONSTRAINT PK_emp_test primary KEY (empno),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno)
            REFERENCES dept_test(deptno) ON DELETE CASCADE
            
);
INSERT INTO emp_test VALUES (9999,'brown',99);
COMMIT;

emp_test ���̺��� deptno �÷��� dept_test ���̺��� deptno �÷��� ����(ON DELETE CASCADE)
�ɼǿ� ���� �θ����̺�(dept_test) ������ �����ϰ� �մ� �ڽ� �����͵� ���� �����ȴ�.

DELETE dept_test
WHERE deptno = 99;
�ɼ� �ο����� �ʾ��� ���� ���� DELETE ������ ������ �߻�
�ɼǿ� ���� �����ϴ� �ڽ����̺��� �����Ͱ� ���������� �����Ǿ����� SELECT Ȯ��
SELECT *
FROM emp_test;



 FK ON DELETE SET NULL �ɼ� �׽�Ʈ
 �θ� ���̺��� ������ ������ (dept_test) �ڽ� ���̺��� �����ϴ� �����͸� NULL�� ������Ʈ;
 ROLLBACK;
 
 SELECT *
 FROM dept_test;
 
 SELECT *
 FROM emp_test;
 
 DROP TABLE emp_test;
 
 CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2), 
    
    CONSTRAINT PK_emp_test primary KEY (empno),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno)
            REFERENCES dept_test(deptno) ON DELETE SET NULL
            
 );
 INSERT INTO emp_test VALUES (9999,'brown',99);
 COMMIT;
 
 dept_test ���̺��� 99�� �μ��� �����ϰ� �Ǹ� (�θ� ���̺��� �����ϸ�)
 99�� �μ��� �����ϴ� emp_test ���̺��� 9999��(brown) �������� deptno �÷���
 FK �ɼǿ� ���� NULL�� �����Ѵ�;
 
 DELETE dept_test
 WHERE deptno = 99;
 
 �θ� ���̺��� ������ ������ �ڽ� ���̺��� �����Ͱ� null�� ����Ǿ����� Ȯ��
 
 SELECT *
 FROM emp_test;
 

 ROLLBACK;
 
 CHECK �������� : �÷��� ���� ���� ������ ������ �� ���
 ex : �޿� �÷��� ���ڷ� ����, �޿��� ������ ���� ������?
      �Ϲ����� ��� �޿����� > 0
      CHECK ������ ����� ��� �޿����� 0���� ū���� �˻� ����.
      emp ���̺��� job �÷��� ��ﳪ�� ���� ���� 4������ ���� ����
      'SALESMAN', 'PRESIENT', 'ANALYST', 'MANAGER';
      
 ���̺� ������ Į�� ����� �Բ� CHECK ���� ����
 emp_test ���̺��� sal �÷��� 0���� ũ�ٴ� CHECK �������� ����;
 
 DROP TABLE emp_test;
 
 INSERT INTO dept_test VALUES (99, 'ddit','����');
 
 CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    sal NUMBER CHECK (sal > 0),
    
    CONSTRAINT PK_emp_test PRIMARY KEY (empno),
    CONSTRAINT FK_emp_dept_test FOREIGN KEY (deptno)
            REFERENCES dept_test (deptno)
 );
 INSERT INTO emp_test VALUES(9999,'brown', 99, 1000);
 INSERT INTO emp_test VALUES(9999,'sally', 99, -1000); --(sal üũ ���ǿ� ���� 0���� ū ���� �Է� ����)
 
 
 ���ο� ���̺� ����
 CREATE ���̺� ����
 CREATE TABLE ���̺�� (
    �÷�1....
 );
 
-- CTAS (���̺� ������ NOT NULL �������Ǹ� ���� (PRIMARY KEY, FOREIGN KEY�� ������ ����);
 CREATE TABLE ���̺�� AS
 SELECT ����� ���ο� ���̺�� ����
 emp ���̺��� �̿��ؼ� �μ��� 10�� ����鸸 ��ȸ�Ͽ� �ش� �����ͷ� emp_test ���̺� ����;
 
 CREATE TABLE emp_test2 AS -- �̷��� ����� ���� �ϱ⵵ ��(������ �ƴ�) TEST�� ���� ��
 SELECT *
 FROM emp
 WHERE deptno = 10;
 
 CREATE TABLE emp_test3 AS -- �̷��� ����� ���� �ϱ⵵ ��(������ �ƴ�) TEST�� ���� ��
 SELECT empno, deptno
 FROM emp
 WHERE deptno = 10;
 
 TABLE ����
 1. �÷� �߰�
 2. �÷� ������ ����, Ÿ�Ժ���
 3. �⺻�� ����
 4. �÷����� RENAME
 5. �÷��� ����
 6. �������� �߰�/����
 
 TABLE ���� 1. �÷� �߰� (HP VARCHAR2(20));
 DROP TABLE emp_test;
 
 CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT PK_emp_test PRIMARY KEY (empno),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno)
 );
 
 ALTER TABLE ���̺�� ADD (�ű��÷��� �ű��÷� Ÿ��);
 
 ALTER TABLE emp_test ADD( hp VARCHAR2(20));
 
 DESC EMP_TEST;
 
 TABLE ���� 2. �÷� ������ ����, Ÿ�� ���� ( �߾Ⱦ�);
 ex : �÷� VARCHAR2(20) ==> VARCHAR2(5)
      ���� �����Ͱ� ������ ��� ���������� ������ �ȵ� Ȯ���� �ſ� ����
 �Ϲ������� �����Ͱ� �������� �ʴ� ����, �� ���̺��� ������ ���Ŀ� �÷��� ������, Ÿ���� �߸� �� ���
 �÷� ������, Ÿ���� ������.
 �����Ͱ� �Էµ� ���ķδ� Ȱ�뵵�� �ſ� ������(����� �ø��� �͸� ����);
 
 DESC emp_test;
 hp VARCHAR2(20) ==> hp VARCHAR2(30);
 
 ALTER TABLE ���̺�� MODIFY (���� �÷��� �ű� �÷� Ÿ��(������));
 
 ALTER TABLE emp_test MODIFY(hp VARCHAR2(30));
  DESC emp_test;
  
 �÷� Ÿ�� ����
 hp VARCHAR2(30) ==> hp NUMBER;
 ALTER TABLE emp_test MODIFY (hp NUMBER);
 
 DESC emp_test;
 
 �÷� �⺻�� ����;
 ALTER TABLE ���̺�� MODIFY (�÷��� DEFAULT �⺻��);
 
 HP NUMBER ==> HP VARCHAR2(20) DEFAULT '010';
 ALTER TABLE emp_test MODIFY (hp VARCHAR2(20) DEFAULT '010');
 DESC emp_test;
 
 hp �÷����� ���� ���� �ʾ����� DEFAULT ������ ���� '010' ���ڿ��� �⺻������ ����ȴ�.
 INSERT INTO emp_test (empno, ename, deptno) VALUES (9999,'brown',99);
 
 TABLE 4. ����� �÷� ����
 �����Ϸ��� �ϴ� �÷��� FK ����, PK ������ �־ ��� ����
 ALTER TABLE ���̺�� RENAME COLUMN ���� �÷��� TO �ű� �÷���;
 hp ==> hp_n;
 
 
 ALTER TABLE emp_test RENAME COLUMN hp to hp_n;
 SELECT *
 FROM emp_test;
 


 ���̺� ���� 5. �÷� ����
 ALTER TABLE ���̺�� DROP COLUNM �÷���
 emp_test ���̺��� hp_n �÷� ����
 
 emp_testdp hp_n �÷��� �ִ� ���� Ȯ��;
 SELECT *
 FROM emp_test;
 
 ALTER TABLE emp_test DROP COLUMN hp_n;
 
 emp_test hp_n �÷��� �����Ǿ����� Ȯ��;
 SELECT *
 FROM emp_test;
 
 -- ����
 1. emp_test ���̺��� drop �� empno, ename, deptno, hp 4���� �÷��� �����̺� ����
 2. empno, ename, deptno 3���� �÷����� (9999,'brown',99) �����ͷ� INSERT
 3. emp_test ���̺��� hp �÷��� �⺻���� '010'���� ����
 4. 2�� ������ �Է��� �������� hp �÷� ���� ��� �ٲ���� Ȯ��
 
 TABLE ���� 6. �������� �߰�/����
 ALTER TABLE ���̺�� ADD CONSTRAINT �������Ǹ� �������� Ÿ�� (PRIMARY KEY, FOREIGN KEY) (�ش� �÷�); -- �߰�
 ALTER TABLE ���̺�� DROP CONSTRAINT �������Ǹ�; -- ����
 
 1. emp_test ���̺� ������
 2. �������� ���� ���̺� ����
 3. PRIMARY KEY, FOREIGN KEY ������ ALTER TABLE ������ ���� ����;
 
 DROP TABLE emp_test;
 
 CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2)
 );
 
 ALTER TABLE emp_test ADD CONSTRAINT PK_emp_test PRIMARY KEY (empno);
 ALTER TABLE emp_test ADD CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno);
 
 PRIMARY KEY �׽�Ʈ;
 INSERT INTO emp_test VALUES (9999, 'brown', 99);
 INSERT INTO emp_test VALUES (9999, 'sally', 99); ù��° insert ������ ���� �ߺ��ǹǷ� ����;
 
 FOREIGN KEY �׽�Ʈ;
 INSERT INTO emp_test VALUES (9998, 'sally', 97); dept_test ���̺� �������� �ʴ� �μ���ȣ�̹Ƿ� ����;
 
 �������� ���� : PRIMARY KEY, FOREIGN KEY;
 ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;
 ALTER TABLE emp_test DROP CONSTRAINT fk_emp_test_dept_test;
 
 ���������� �����Ƿ� empno�� �ߺ��� ���� �� �� �հ�, dept_test ���̺� �������� �ʴ� deptno ���� �� �� �ִ�.
 
 �ߺ��� empno ������ ������ �Է�
 INSERT INTO emp_test VALUES (9999, 'brown', 99);
 INSERT INTO emp_test VALUES (9999, 'sally', 99); 
 
 �������� �ʴ� 98�� �μ��� ������ �Է�
 INSERT INTO emp_test VALUES (9998, 'sally', 97); 
 
 SELECT *
 FROM emp_test;
 
 
 PRIMARY KEY, FOREIGN KEY
 NOT NULL, UNIQUE, CHECK �� PT�θ� �����ϰ� ��;
 
 �������� Ȱ��ȭ / ��Ȱ��ȭ
 ALTER TABLE ���̺�� ENABLE | DISABLE CONSTRAINT �������Ǹ�;
 
 1. emp_test ���̺� ����
 2. emp_test ���̺� ����
 3. ALTER TABLE PRIMARY KEY(empno), FOREIGN KEY (dept_test.deptno) �������� ����
 4. �ΰ��� ���������� ��Ȱ��ȭ
 5. ��Ȱ��ȭ�� �Ǿ����� INSERT�� ���� Ȯ��
 6. ���������� ������ �����Ͱ� �� ���¿��� �������� Ȱ��ȭ;
 DROP TABLE dept_test;
  CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    CONSTRAINT pk_dept_test PRIMARY KEY(deptno)
);
 DROP TABLE emp_test;
 CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2));
    
 ALTER TABLE emp_test ADD CONSTRAINT PK_emp_test PRIMARY KEY (empno);
 ALTER TABLE emp_test ADD CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno);
 
 ALTER TABLE emp_test DISABLE CONSTRAINT pk_emp_test;

 INSERT INTO dept_test VALUES (99,'ddit', 'daejeon');
 select *
 from dept_test;
 select  *
 from emp_test;
 
 INSERT INTO emp_test VALUES (9999,'brown',99); -- 99 �� �Ƿ��� ALTER TABLE emp_test DISABLE CONSTRAINT pk_emp_test; �̰� ������
 INSERT INTO emp_test VALUES (9999,'sally',98); -- FOREIGN KEY�� ��Ȱ��ȭ ����� ��
 COMMIT;
 
 SELECT *
 FROM emp_test;
 
 emp_test ���̺��� empno �÷��� ���� 9999�� ����� �θ� �����ϱ� ������
 PRIMARY KEY ���������� Ȱ��ȭ �� ���� ����;
 ==> EMPNO �÷��� ���� �ߺ����� �������� �����ϰ� �������� Ȱ��ȭ �Ҽ� �ִ�.;
 ALTER TABLE emp_test ENABLE CONSTRAINT PK_emp_test;
 
 SELECT *
 FROM emp_test;
 
 empno �ߺ� ������ ����
 DELETE emp_test
 WHERE ename = 'brown';
 
 PRIMARY KEY �������� Ȱ��ȭ;
 ALTER TABLE emp_test ENABLE CONSTRAINT PK_emp_test;
 
 SELECT *
 FROM emp_test;
 
 dept_test ���̺� �������� �ʴ� �μ���ȣ98�� emp_test���� �����
 1. dept_test ���̺� 98�� �μ��� ����ϰų�
 2. sally�� �μ���ȣ�� 99������ �����ϰų�
 3. sally�� ����ų�
 
 ���⼭�� ������ �ϰ���
 UPDATE emp_test SET deptno=99
 WHERE ename ='sally';
 
 ALTER TABLE emp_test ENABLE CONSTRAINT fk_emp_test_dept_test;
 
