-- �ǽ� h_2
SELECT deptcd, LPAD(' ', (LEVEL - 1) * 4) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;
-- LPAD �� 3��° ���� ���� ����

-- ����� ���� ���� (leaf ==> root node(���� node))
-- ��ü ��带 �湮�ϴ°� �ƴ϶� �ڽ��� �θ��常 �湮 (����İ� �ٸ� ��)
-- ������ : ��������
-- ������ : �����μ�;

 SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL - 1)*4) || deptnm  
 FROM dept_h
 START WITH deptnm = '��������'
 CONNECT BY PRIOR p_deptcd = deptcd;

-- �ǽ� h_4 �� �ϱ� ���� ����
-- ���������� ����.sql
create table h_sum as
select '0' s_id, null ps_id, null value from dual union all
select '01' s_id, '0' ps_id, null value from dual union all
select '012' s_id, '01' ps_id, null value from dual union all
select '0123' s_id, '012' ps_id, 10 value from dual union all
select '0124' s_id, '012' ps_id, 10 value from dual union all
select '015' s_id, '01' ps_id, null value from dual union all
select '0156' s_id, '015' ps_id, 20 value from dual union all

select '017' s_id, '01' ps_id, 50 value from dual union all
select '018' s_id, '01' ps_id, null value from dual union all
select '0189' s_id, '018' ps_id, 10 value from dual union all
select '11' s_id, '0' ps_id, 27 value from dual;

 
-- �ǽ� h_4 (�����)
select *
from h_sum;

DESC h_sum;

SELECT LPAD(' ', (LEVEL - 1) * 4) || s_id s_id, value
FROM h_sum
START WITH s_id = '0' -- 0�� ����
CONNECT BY PRIOR s_id = ps_id;

-- ���������� ��ũ��Ʈ
-- �ǽ� h_5�� �ϱ� ���ؼ�
create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XXȸ��', null, 1);
insert into no_emp values('�����ý��ۺ�', 'XXȸ��', 2);
insert into no_emp values('����1��', '�����ý��ۺ�', 5);
insert into no_emp values('����2��', '�����ý��ۺ�', 10);
insert into no_emp values('������ȹ��', 'XXȸ��', 3);
insert into no_emp values('��ȹ��', '������ȹ��', 7);
insert into no_emp values('��ȹ��Ʈ', '��ȹ��', 4);
insert into no_emp values('�����κ�', 'XXȸ��', 1);
insert into no_emp values('��������', '�����κ�', 7);

commit;

-- �ǽ� h_5
SELECT *
FROM no_emp;

DESC no_emp;

SELECT LPAD(' ', (LEVEL-1)*4) || org_cd org_cd, no_emp 
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;

-- pt82
-- ������ ������ �� ���� ���� ��� ��ġ�� ���� ��� �� (pruning branch - ����ġ��)
 FROM => START WITH, CONNECT BY => WHERE
 1. WHERE : ������ ������ �ϰ� ���� ���� ����
 2. CONNECT BY : ���� ������ �ϴ� �������� ���� ����;
 
 WHERE �� ��� �� : �� 9���� ���� ��ȸ�Ǵ� ���� Ȯ��
 WHERE �� (org_cd != '������ȹ��') : ������ȹ�θ� ������ 8���� �� ��ȸ�Ǵ� �� Ȯ��;
 
SELECT LPAD(' ', (LEVEL-1)*4) || org_cd org_cd, no_emp 
FROM no_emp
WHERE org_cd != '������ȹ��' -- 9�� �� 1���� ���� ��ȹ�ΰ� ����� (������ ���� ���¿��� ����)
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;

 CONNECT BY ���� ������ ���;
 
SELECT LPAD(' ', (LEVEL-1)*4) || org_cd org_cd, no_emp 
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd AND org_cd != '������ȹ��'; -- ������ȹ�ΰ� ������ �ȵǱ� ������ ���� ������ �ƿ� ���� ��

-- pt84
 CONNECT_BY_ROOT(�÷�) : �ش� �÷��� �ֻ��� ��(���)�� ���� return
 SYS_CONNECT_BY_PATH(�÷�, ������) : �ش� ���� �÷��� ���Ŀ� �÷� ���� ����, �����ڷ� �̾��ش�.
 CONNECT_BY_ISLEAF : �ش� ���� LEAF �������(����� �ڽ��� ������) ���� ���� (1:leaf, 0:no leaf;
 
SELECT LPAD(' ', (LEVEL-1)*4) || org_cd org_cd, no_emp,
       CONNECT_BY_ROOT(org_cd) root,
       LTRIM(SYS_CONNECT_BY_PATH(org_cd,'-'),'-') path, -- SYS_CONNECT_BY_PATH(org_cd,'-') �̰� �տ� trim�� �ι�° ���ڸ� �ָ� ���ʿ��� �ѹ� ����. LTRIM(SYS_CONNECT_BY_PATH(org_cd,'-'),'-') : ������ ���δٰ� ��
       CONNECT_BY_ISLEAF leaf
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd ;

-- �Խñ� ������ ���� ���� �ڷ�.sql (������ ������ ��ົ?)
-- �ǽ� h6
create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, 'ù��° ���Դϴ�');
insert into board_test values (2, null, '�ι�° ���Դϴ�');
insert into board_test values (3, 2, '����° ���� �ι�° ���� ����Դϴ�');
insert into board_test values (4, null, '�׹�° ���Դϴ�');
insert into board_test values (5, 4, '�ټ���° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (6, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (7, 6, '�ϰ���° ���� ������° ���� ����Դϴ�');
insert into board_test values (8, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (9, 1, '��ȩ��° ���� ù��° ���� ����Դϴ�');
insert into board_test values (10, 4, '����° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (11, 10, '���ѹ�° ���� ����° ���� ����Դϴ�');
commit;

 SELECT *
 FROM board_test;
 desc board_test;
 
-- �ǽ� h6
SELECT seq,LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH parent_seq is null
CONNECT BY PRIOR seq = parent_seq ;

-- �̷������ �ִ�.
SELECT seq,LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH seq IN(1,2,4)
CONNECT BY PRIOR seq = parent_seq ;

-- �ǽ� h7
SELECT seq,LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH parent_seq is null
CONNECT BY PRIOR seq = parent_seq 
ORDER BY seq DESC; -- ������ �Ǹ鼭 ������ ���� ���� ������������ ORDER BY ���� SIBLINGS BY �� �����

-- �ǽ� h8 �ֽű� �� (SIBLINGS BY) (h7 ����)
SELECT seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH parent_seq is null
CONNECT BY PRIOR seq = parent_seq 
ORDER SIBLINGS BY seq DESC;

-- h9
-- �׷� ��ȣ�� ������ �÷��� �߰�
ALTER TABLE board_test ADD (gn NUMBER);

UPDATE board_test SET gn = 4
WHERE seq IN(4,5,6,7,8,10,11);

UPDATE board_test SET gn = 2
WHERE seq IN(2,3);

UPDATE board_test SET gn = 1
WHERE seq IN(1,9);

commit;

 SELECT *
 FROM board_test;

-- ������ 
SELECT gn, seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH parent_seq is null
CONNECT BY PRIOR seq = parent_seq 
ORDER SIBLINGS BY gn DESC, seq ASC;

-- ������ --���� ���ϰ���
SELECT LPAD(' ', (LEVEL-1)*4) || title title, DECODE(parent_seq, NULL, seq, parent_seq) root,seq, parent_seq
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq 
ORDER SIBLINGS BY root DESC, seq ASC;

SELECT *
FROM emp
ORDER BY deptno DESC, empno ASC;

SELECT *
FROM emp
WHERE sal = (SELECT MAX(sal)
             FROM emp);
             
             
             
-- �м� �Լ�
-- �ǽ� ana0

SELECT *
FROM
(SELECT ename, sal, deptno, max(sal)
FROM emp
group by ename, sal, deptno
order by deptno, MAX(sal) desc);


-- �μ��� ����
SELECT ename, sal, deptno
FROM emp
group by ename, sal, deptno
order by deptno;

SELECT rownum, a.deptno
FROM (SELECT deptno
                FROM emp, 
                where deptno = 10
                order by deptno, ) a;
                
                
                
SELECT *
FROM dual
CONNECT BY LEVEL <= 14; -- EMP ���̺��� ���� ��

SELECT deptno, count(*) cnt
FROM emp
GROUP BY deptno; -- �� �μ��� ������ ��


SELECT *
FROM 
    (SELECT LEVEL lv
    FROM dual
    CONNECT BY LEVEL <= 14) a,
    
    (SELECT deptno, count(*) cnt
    FROM emp
    GROUP BY deptno) b
    
    (SELECT deptno, sal
     FROM emp) c
    
    

    

WHERE b.cnt >= a.lv AND b.deptno = c.deptno
ORDER BY b.deptno, a.lv;



