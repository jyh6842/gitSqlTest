-- sub4
-- dept ���̺��� 5���� �����Ͱ� ����
-- emp ���̺��� 14���� ������ �ְ�, ������ �ϳ��� �μ��� ���� �ִ�.(deptno)
-- �μ��� ������ ���� ���� ���� �μ� ������ ��ȸ

-- ������������ �������� ������ �´��� Ȯ���� ������ �ϴ� �������� �ۼ�

SELECT *
FROM dept
WHERE deptno NOT IN (10,20,30);

SELECT *
FROM emp;

SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                    FROM emp);
                    
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                    FROM emp
                    GROUP BY deptno);
                    
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT DISTINCT deptno
                    FROM emp);