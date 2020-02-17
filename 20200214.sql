-- GROUP_AD_2-1
SELECT DECODE(GROUPING(job) || GROUPING(deptno), '00', job,
                                                 '01', job,
                                                 '11', '��') job,
       DECODE(GROUPING(job) || GROUPING(deptno), '00', deptno,
                                                 '01', '�Ұ�',
                                                 '11', '��') deptno,
       SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

 MERGE : SELECT �ϰ��� �����Ͱ� ��ȸ�Ǹ� UPDATE
        SELECT �ϰ��� �����Ͱ� ��ȸ���� ������ INSERT
 SELECT + UPDATE / SELECT + INSERT ==> MERGE;

 REPORT GROUP FUNCTION
 1. ROLLUP
    - GROUP BY ROLLUP (�÷�1, �÷�2)
    - ROLLUP ���� ����� �÷��� �����ʿ��� �ϳ��� ������ �÷����� SUBGROUP
    - GROUP BY �÷�1, �÷�2
      UNION
      GROUP BY �÷�1
      UNION
      GROUP BY
 2. CUBE
 3. GROUPPING SETS
 
 -- �ǽ� GROUP_AD3
SELECT deptno,job, 
       SUM(sal + NVL(comm, 0)) sal
 FROM emp
 GROUP BY ROLLUP(deptno, job);
 
 -- �ǽ� GROUP_AD4
SELECT dname, job,
       SUM(sal + NVL(comm, 0)) sal
 FROM emp,dept
 WHERE emp.deptno = dept.deptno
 GROUP BY ROLLUP(dname, job);
 
 -- �ǽ� GROUP_AD4 2��° ���
SELECT b.dname, a.job, a.sal
FROM
 (SELECT deptno, job, SUM(sal) sal
 FROM emp
 GROUP BY ROLLUP(deptno, job )) a, dept b
WHERE a.deptno = b.deptno(+);

 -- �ǽ� GROUP_AD5
SELECT DECODE(GROUPING(dname), 0, dname,
                               1, '����') dname,
       job,
       SUM(sal + NVL(comm, 0)) sal
 FROM emp,dept
 WHERE emp.deptno = dept.deptno
 GROUP BY ROLLUP(dname, job);

 -- �ǽ� GROUP_AD5
SELECT (GROUPING(dname)), dname, job,
       SUM(sal + NVL(comm, 0)) sal
 FROM emp,dept
 WHERE emp.deptno = dept.deptno
 GROUP BY ROLLUP(dname, job);
 
  -- �ǽ� GROUP_AD5 2��° ���
SELECT NVL(dept.dname,'����') dname, job,
       SUM(sal + NVL(comm, 0)) sal
 FROM emp,dept
 WHERE emp.deptno = dept.deptno
 GROUP BY ROLLUP(dname, job);
 
 -----
 REPORT GROUP FUNCTION
 1. ROLLUP
 2. CUBE
 3. GROUPING
 Ȱ�뵵
 3, 1 >>>>>>>>>>>>>>>>>>>>>>>>> CUBE;
 
 GROUPING SETS
 ������ ������� ���� �׷��� ����ڰ� ���� ����
 ����� : GROUP BY GROUPING SETS(col1, col2...)
 
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
 
 GROUPING SETS�� ��� �÷� ��� ������ ����� ������ ��ġ�� �ʴ´�.
 ROLLUP�� �÷� ��� ������ ��� ������ ��ģ��.
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
 GROUP BY GROUPING SETS(job, job); -- �̷��� �ϸ� union���� union all ���� ������ �����غ��� ���� �� �� �ִ�.
 
 job, deptno�� GROUP BY �� �����
 mgr�� GROUP BY�� ����� ��ȸ�ϴ� SQL�� GROUPING SETS�� �޿��� SUM(sal) �ۼ�;
 
 SELECT job, deptno, mgr, SUM(sal)
 FROM emp
 GROUP BY GROUPING SETS ((job, deptno), mgr);
 
 CUBE
 ������ ����������� �ø��� ������ SUB GROUP�� �����Ѵ�.
 ��, ����� �÷��� ������ ��Ų��;
 
 EX : GROUP BY CUBE (col1, col2);
 (col1, col2) ==> co1���� �Ǵ��� �ȵǴ���, col2�� ���ԵǴ��� �ȵǴ��� �� 4���� ���
 (null, col2) ==> GROUP BY col2
 (null, null) ==> GROUP BY ��ü
 (col1, null) ==> GROUP BY col1
 (col1, col2) ==> GROUP BY col1,col2;
 
 ���� �÷� 3���� CUBE���� ����� ��� ���ü� �մ� ��������??;
 SELECT job, deptno, SUM(sal) sal
 FROM emp
 GROUP BY CUBE(job, deptno); -- ���� CUBE �� 4������ ��
 
 ȥ��; (����) ������ ĥ�ϱ�
 SELECT job, deptno, mgr, SUM(sal) sal
 FROM emp
 GROUP BY job, rollup(deptno), CUBE(mgr); //job�� default, rollup�� ��ü�� deptno, cube�� mgr�� �ְ� ����
 
 GROUP BY job, deptno, mgr ==> GROUP BY job, deptno, mgr 
 GROUP BY job, deptno ==> GROUP BY job, deptno
 GROUP BY job, null, mgr ==> GROUP BY job, mgr
 GROUP BY job, null, null ==> GROUP BY job
 
 �������� UPDATE 
 1. emp_test ���̺� drop
 2. emp ���̺��� �̿��ؼ� emp_test ���̺� ���� (��� �࿡ ���� ctas)
 3. emp_test ���̺� dname VARCHAR2(14)�÷� �߰�
 4. emp_test.dname �÷��� dept ���̺��� �̿��ؼ� �μ����� ������Ʈ;
 
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
 
 -- �ǽ� sub_a1
 1. dept_test DROP �ϱ�
 
 DROP TABLE dept_test;
 
 CREATE TABLE dept_test AS
 SELECT *
 FROM dept;
 
 ALTER TABLE dept_test ADD (empcnt NUMBER);
 
 SELECT *
 FROM emp_test; -- � ���̺�� ������ 
 

 
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
                               WHERE dept_test.dname = emp_test.dname); -- ���������� ���������� ���� ����� �� �ִ�. -- 0 ���� ����
                               
 UPDATE dept_test SET empcnt = NVL((SELECT COUNT(*) cnt
                                    FROM emp
                                    WHERE deptno = dept_test.deptno
                                    GROUP BY deptno),0); -- null ������ ���� -- 0 ������ �ٲ��ֱ� ���ؼ�
                                
 SELECT COUNT(*) cnt
 FROM emp
 WHERE deptno = 40
 GROUP BY deptno;
 
 
 
-- �ǽ� sub_a2
 dept_test ���̺� �ִ� �μ��߿� ������ ������ ���� �μ� ������ ����
 *dept_test.empcnt �÷��� ������� �ʰ�
 emp ���̺��� �̿��Ͽ� ����;
 INSERT INTO dept_test VALUES (99, 'it1', 'daejeon', 0); 
 INSERT INTO dept_test VALUES (98, 'it2', 'daejeon', 0); 
 COMMIT;
 
 ������ ������ ���� �μ� ���� ��ȸ?
 ���� �ִ� ����...?
 10�� �μ��� ���� �ִ� ����?
 SELECT COUNT(*)
 FROM dept_test
 WHERE empcnt = 10;
 
 SELECT *
 FROM dept_test
 WHERE 0 = (SELECT COUNT(*)
            FROM emp
            WHERE deptno = dept_test.deptno); -- 0�� �ƹ��� ���� �μ��� ����� �ʹ�.
            
 DELETE dept_test
 WHERE 0 = (SELECT COUNT(*)
            FROM emp
            WHERE deptno = dept_test.deptno);

 SELECT *
 FROM dept_test;
 
 -- �ǽ� sub_a3
 
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

 WITH ��
 �ϳ��� �������� �ݺ��Ǵ� SUBQUERY �� ���� ��
 �ش� SUBQUERY �� ������ �����Ͽ� ����.
 
 MAIN ������ ����� �� WITH ������ ���� ���� �޸𸮿� �ӽ������� ����
 ==> MAIN ������ ���� �Ǹ� �޸� ����
 SUBQUERY �ۼ��ÿ��� �ش� SUBQUERY�� ����� ��ȸ�ϱ� ���ؼ� I/O �ݺ������� �Ͼ����
 WITH���� ���� �����ϸ� �ѹ��� SUQUERY�� ����ǰ� �� ����� �޸𸮿� ������ ���� ����
 ��, �ϳ��� �������� ������ SUBQUERY�� �ݺ������� �����°Ŵ� �߸� �ۼ��� SQL�� Ȯ���� ����;
 
 WITH ��������̸� AS (
    ��������
 )
 
 SELECT *
 FROM ��������̸�;
 
 ������ �μ��� �޿� ����� ��ȸ�ϴ� ��������� WITH���� ���� ����;
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
 
 with ���� �̿��� ���̽� ���̺� �ۼ�
 WITH temp AS ( -- ��¥ ������ ���鶧 ���� ������ �� �Ⱦ���. ��κ� �ٸ��� ����. ���� ��� view ������
    SELECT sysdate -1 FROM dual UNION ALL
    SELECT sysdate -2 FROM dual UNION ALL 
    SELECT sysdate -3 FROM dual)
 SELECT *
 FROM temp;
 
 SELECT *
 FROM 
 (  SELECT sysdate -1 FROM dual UNION ALL
    SELECT sysdate -2 FROM dual UNION ALL 
    SELECT sysdate -3 FROM dual); -- WITH ���� �̷������� « WITH�� ���� ������ ª����
    
 
 
 
 
 �޷¸����
 CONNECT BY LEVEL <[=] ����
 �ش� ���̺��� ���� ���� ��ŭ �����ϰ� ������ ���� �����ϱ� ���ؼ� LEVEL�� �ο�
 LEVEL�� 1���� ����;
 SELECT dummy, LEVEL
 FROM dual
 CONNECT BY LEVEL <= 10;
 
 SELECT dept.*, LEVEL
 FROM dept
 CONNECT BY LEVEL <= 5;


 2020�� 2���� �޷��� ����
 :dt = 202002, 202003
 �ش���� �ϼ��� �ʿ���
 �޷�
 ��  ��   ȭ   ��   ��   ��   ��
 1.
 SELECT SYSDATE, LEVEL
 FROM dual
 CONNECT BY LEVEL <= :dt;
 
 SELECT TO_DATE('202002','YYYYMM') + (LEVEL-1), -- ������ 0���� ���߱� ���� 1�� ��, ������ 1���� �����Ѵ�. �ٽ� �����ϸ� TO_DATE('202002','YYYYMM')�� �̹� ������ ������ �ִ�. LEVEL�� �ʱⰪ�� 1�̴�. + (LEVEL-1)�� ����� 1���� ���� ���ϰ��� ������ ���� ���� �� �ִ�. �� 1 �� 2 ȭ 3 ... �� 7
        TO_CHAR(TO_DATE('202002','YYYYMM') + (LEVEL-1), 'D'),
        DECODE(TO_CHAR(TO_DATE('202002','YYYYMM') + (LEVEL-1), 'D'), 1, TO_DATE('202002','YYYYMM') + (LEVEL-1)) sun,
        DECODE(TO_CHAR(TO_DATE('202002','YYYYMM') + (LEVEL-1), 'D'), 2, TO_DATE('202002','YYYYMM') + (LEVEL-1)) mon,
        DECODE(TO_CHAR(TO_DATE('202002','YYYYMM') + (LEVEL-1), 'D'), 3, TO_DATE('202002','YYYYMM') + (LEVEL-1)) tue,
        DECODE(TO_CHAR(TO_DATE('202002','YYYYMM') + (LEVEL-1), 'D'), 4, TO_DATE('202002','YYYYMM') + (LEVEL-1)) wen,
        DECODE(TO_CHAR(TO_DATE('202002','YYYYMM') + (LEVEL-1), 'D'), 5, TO_DATE('202002','YYYYMM') + (LEVEL-1)) thu,
        DECODE(TO_CHAR(TO_DATE('202002','YYYYMM') + (LEVEL-1), 'D'), 6, TO_DATE('202002','YYYYMM') + (LEVEL-1)) fri,
        DECODE(TO_CHAR(TO_DATE('202002','YYYYMM') + (LEVEL-1), 'D'), 7, TO_DATE('202002','YYYYMM') + (LEVEL-1)) sat
 FROM dual
 CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202002', 'YYYYMM')), 'DD'); -- D �ϳ��� ������
 
 SELECT TO_DATE('202002' 'YYYYMM'
 
 
 SELECT TO_CHAR(LAST_DAY(TO_DATE('202002', 'YYYYMM')), 'DD') -- �̰ɷ� ���� �ϼ��� ���� �� ����
 FROM dual;
