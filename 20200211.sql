-- ����
-- 1. emp_test ���̺��� drop �� empno, ename, deptno, hp 4���� �÷����� ���̺� ����
-- 2. empno, ename, deptno 3���� �÷����� (9999, 'brown', 99) �����ͷ� INSERT
-- 3. emp_test ���̺��� hp �÷��� �⺻���� '010'���� ����
-- 4. 2�� ������ �Է��� �������� hp �÷� ���� ��� �ٲ���� Ȯ��

DROP TABLE emp_test;

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    hp VARCHAR2(20)
);

INSERT INTO emp_test (empno, ename, deptno) VALUES (9999, 'brown', 99);

ALTER TABLE emp_test MODIFY (hp VARCHAR2(20) DEFAULT '010');

SELECT *
FROM emp_test;

-- �������� Ȯ�� ���
 1. tool
 2. dictionary view
 -- �������� : USER_CONSTRAINS
 ��������-�÷� : USER_CONS_COLUMNS
 ���������� ��� �÷��� �����Ǿ� �ִ��� �˼� ���� ������ ���̺��� ������ �и��Ͽ� ����
 �� 1 ������;
 
 SELECT *
 FROM USER_CONSTRAINTS
 WHERE table_name IN('EMP', 'DEPT', 'EMP_TEST', 'DEPT_TEST');
 
 EMP,DEPT PK, FK ������ �������� ����
 ���̺� �������� �������� �߰�;
 
 2. EMP : pk(empno)
 3.       fk(deptno) - dept.deptno
 
 1. dept = pk(deptno);
 
 ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno); 
 ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno); 
 ALTER TABLE emp ADD CONSTRAINT fk_emp_dept FOREIGN KEY (deptno) REFERENCES dept (deptno); 
 
 --
 SELECT *
 FROM member;
 
 ���̺�, �÷� �ּ� : DICTIONARY Ȯ�� ����
 ���̺� �ּ� : USER_TAB_COMMENTS
 �÷� �ּ� : USER_COL_COMMENTS
 
 �ּ� ����
 ���̺� �ּ� : COMMENT ON TABLE ���̺�� IS '�ּ�'
 �÷� �ּ� : COMMENT ON COLUM ���̺�.�÷� IS '�ּ�';
 
 emp : ����;
 dept : �μ�;
 
 COMMENT ON TABLE emp IS '����';
 COMMENT ON TABLE dept IS '�μ�';
 
 SELECT *
 FROM USER_TAB_COMMENTS
 WHERE TABLE_NAME IN ('EMP', 'DEPT');
 
  SELECT *
 FROM USER_COL_COMMENTS
 WHERE TABLE_NAME IN ('EMP', 'DEPT');
 
 DEPT DEPTNO : �μ���ȣ
 DEPT DNAME : �μ���
 DEPT LOC : �μ���ġ
 EMP EMPNO : ���� ��ȣ
 EMP ENAME : ���� �̸�
 EMP JOB : ������
 EMP MGR : �Ŵ��� ������ȣ
 EMP HIREDATE : �Ի�����
 EMP SAL : �޿�
 EMP COMM : ������
 EMP DEPTNO : �ҼӺμ� ��ȣ;
 
 COMMENT ON COLUMN dept.deptno IS '�μ���ȣ';
 COMMENT ON COLUMN dept.dname IS '�μ���';
 COMMENT ON COLUMN dept.loc IS '�μ���ġ';
 
 COMMENT ON COLUMN emp.empno IS '������ȣ';
 COMMENT ON COLUMN emp.ename IS '�����̸�';
 COMMENT ON COLUMN emp.job IS '������';
 COMMENT ON COLUMN emp.mgr IS '�Ŵ��� ������ȣ';
 COMMENT ON COLUMN emp.hiredate IS '�Ի�����';
 COMMENT ON COLUMN emp.sal IS '�޿�';
 COMMENT ON COLUMN emp.comm IS '������';
 COMMENT ON COLUMN emp.deptno IS '�ҼӺμ� ��ȣ';
 
 -- �ǽ� comment1
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
TABLE ó�� DBMS�� �̸� �ۼ��� ��ü
==> �ۼ����� �ʰ� QUERY���� �ٷ� �ۼ��� VIEW : IN-LINEVIEW ==> �̸��� ���� ������ ��Ȱ���� �Ұ�
VIEW ���̺��̴�. (X)

������
1. ���� ����(Ư�� �÷��� �����ϰ� ������ ����� �����ڿ��� ����)
2. INLINE-VIEW�� VIEW�� �����Ͽ� ��Ȱ��
    .���� ���� ����
    
�������
CREATE [OR REPLACE] VIEW ���Ī [(column1, column2...)] AS
SUBQUERY;

emp ���̺��� 8���� �÷��� sal, comm �÷��� ������ 6���� �÷��� �����ϴ� v_emp VIEW ����;

CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

�ý��� �������� PC14 �������� VIEW �������� �߰�
�ý��ۿ� ����;
GRANT CREATE VIEW TO jyh6842;
�ٽ� pc14�� ���ƿͼ� �۾�;

���� �ζ��� ��� �ۼ���;
SELECT *
FROM (SELECT empno, ename, job, mgr, hiredate, deptno
        FROM emp);
        
VIEW ��ü Ȱ��;
 SELECT *
 FROM v_emp;
 
emp ���̺��� �μ����� ���� ==> dept ���̺�� ������ ����ϰ� ����
���ε� ����� view�� ���� �س����� �ڵ带 �����ϰ� �ۼ��ϴ°� ����;

-- VIEW : v_emp_dept
-- dname(�μ���), empno(���� ��ȣ), �����̸�(ename), job(������), hiredate(�Ի�����)
 CREATE OR REPLACE VIEW v_emp_dept AS
SELECT dept.dname, emp.empno, emp.ename, emp.job, emp.hiredate
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- �ζ��� ��� �ۼ���
SELECT *
FROM (SELECT dept.dname, emp.empno, emp.ename, emp.job, emp.hiredate
      FROM emp, dept
      WHERE emp.deptno = dept.deptno);
      
-- VIEW Ȱ���
SELECT *
FROM v_emp_dept;

SMITH ���� ������ v_emp_dept view �Ǽ� ��ȭ�� Ȯ��; 
DELETE emp
WHERE ename ='SMITH'; //�ζ��� ��� v_emp_dept���� Ȯ���غ��� �Ѵ� ���� �� ���� ���� �ִ�.

VIEW�� �������� �����͸� ���� �ʰ�, ������ �������� ���� ����(SQL)�̱� ������
VIEW���� �����ϴ� ���̺��� �����Ͱ� ������ �Ǹ� VIEW�� ��ȸ ����� ������ �޴´�.
ROLLBACK;


 
 

 