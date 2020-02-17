:dt ==> 202004;

SELECT DECODE(d, 1, iw+1, iw) i,--��, ��, ȭ, ��, ��, ��, ��,
       MIN(DECODE(d, 1, dt)) sun, -- MIN�� �ϴ� ������ ���� �ϳ��� ������ �Ϸ���
       MIN(DECODE(d, 2, dt)) mon,
       MIN(DECODE(d, 3, dt)) tue,
       MIN(DECODE(d, 4, dt)) wed,
       MIN(DECODE(d, 5, dt)) tur,
       MIN(DECODE(d, 6, dt)) fri,
       MIN(DECODE(d, 7, dt)) sat
FROM
    (SELECT 
            TO_DATE(:dt, 'yyyymm') + (LEVEL-1) dt,
            TO_CHAR(TO_DATE(:dt, 'yyyymm') + (LEVEL-1), 'D') d, -- D �ϳ��� ������
            TO_CHAR(TO_DATE(:dt, 'yyyymm') + (LEVEL-1), 'iw') iw -- ����
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')),'DD')) -- DD�� �ϼ�
    GROUP BY DECODE(d, 1, iw+1, iw)
    ORDER BY DECODE(d, 1, iw+1, iw);
    
 1. �ش� ���� 1���ڰ� ���� ���� �Ͽ��� ���ϱ�
 2. �ش� ���� ������ ���ڰ� ���� ���� ����� ���ϱ�
 3. 2-1�� �Ͽ� �� �ϼ� ���ϱ�;
 
 20200401 ==> 20200329(�Ͽ���)
 20200430 ==> 20200502(�����)
 ������ ���ڷ� ǥ���� �� �ִ�.
 ������ 7��(1~7);
 SELECT TO_DATE(20200401, 'YYYYMMDD')
 FROM dual;
 
 SELECT TO_DATE(20200401, 'YYYYMMDD') - 3 --�Ͽ��� 03/29
 FROM dual;
 
 SELECT LAST_DAY(TO_DATE(20200401, 'YYYYMMDD')) +2 -- ����� 05/02
 FROM dual;
 
 SELECT 
        dt - (7-d),
        NEXT_DAY(dt2, 7)
 FROM 
 (SELECT TO_DATE(:dt || '01', 'YYYYMMDD') dt, -- ó�� ��¥
         TO_CHAR(TO_DATE(:dt || '01', 'YYYYMMDD'), 'D') d, 
         
         LAST_DAY(TO_DATE(:dt, 'YYYYMM')) dt2, -- ������ ��¥
         TO_CHAR(LAST_DAY(:dt, 'YYYYMM')), 'D') d2
 FROM dual);
 
 --- �ϵ��ڵ�
 ����: �������� 1��, ������ ��¥ : �ش���� ������ ����;
 SELECT TO_DATE('202002', 'YYYYMM') + (LEVEL-1)
 FROM dual
 CONNECT BY LEVEL <= 29;
 
 ���� : �������� : �ش���� 1���ڰ� ���� ���� �Ͽ���
        ��������¥ : �ش���� ���������ڰ� ���� ���� �����
 SELECT TO_DATE('20200126', 'YYYYMMDD') + (LEVEL-1)
 FROM dual
 CONNECT BY LEVEL <= 35;
 
 -- �̷��� �ϸ� �ϵ��ڵ� Ż�� 
 -- 1���ڰ� ���� ���� �Ͽ��ϱ��ϱ�
 -- ���������ڰ� ���� ���� ����ϱ� �ϱ�
 -- �ϼ� ���ϱ�;
    SELECT 
        TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1) st,
        LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7-TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D')) ed,
        LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7-TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D')) 
                    - (TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt,'yyyymm'),'D'))) daycnt
    FROM dual;
----- 1����, �����ڰ� ���� �������� ǥ���� �޷�
SELECT DECODE(d, 1, iw+1, iw) i,
       MIN(DECODE(d, 1, dt)) sun,
       MIN(DECODE(d, 2, dt)) mon,
       MIN(DECODE(d, 3, dt)) tue,
       MIN(DECODE(d, 4, dt)) wed,
       MIN(DECODE(d, 5, dt)) tur,
       MIN(DECODE(d, 6, dt)) fri,
       MIN(DECODE(d, 7, dt)) sat
FROM 
(SELECT TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1) + (level-1) dt,
        TO_CHAR(TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1)  + (LEVEL-1), 'D') d, -- d �ϳ��� ����
        TO_CHAR(TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1)  + (LEVEL-1), 'iw') iw
 FROM dual
 CONNECT BY LEVEL <=  last_day(to_date(:dt,'yyyymm'))+(7-to_char(last_day(to_date(:dt,'yyyymm')),'D'))
                    -to_date(:dt,'yyyymm')-(to_char(to_date(:dt,'yyyymm'),'D')-1)  )
 GROUP BY DECODE(d, 1, iw+1, iw)
 ORDER BY DECODE(d, 1, iw+1, iw);
 
 
 -- �޷¸���� ���� ������.sql
 create table sales as 
select to_date('2019-01-03', 'yyyy-MM-dd') dt, 500 sales from dual union all
select to_date('2019-01-15', 'yyyy-MM-dd') dt, 700 sales from dual union all
select to_date('2019-02-17', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-02-28', 'yyyy-MM-dd') dt, 1000 sales from dual union all
select to_date('2019-04-05', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-04-20', 'yyyy-MM-dd') dt, 900 sales from dual union all
select to_date('2019-05-11', 'yyyy-MM-dd') dt, 150 sales from dual union all
select to_date('2019-05-30', 'yyyy-MM-dd') dt, 100 sales from dual union all
select to_date('2019-06-22', 'yyyy-MM-dd') dt, 1400 sales from dual union all
select to_date('2019-06-27', 'yyyy-MM-dd') dt, 1300 sales from dual;

SELECT *
FROM sales;

-- �ǽ� calendar1
 1. dt (DLFWK) ==> ��, �������� SUM(SALES) ==> ���� ����ŭ ���� �׷��� �ȴ�.;

SELECT TO_CHAR(dt, 'MM'), SUM(sales) m_s
FROM sales
GROUP BY TO_CHAR(dt, 'MM');

SELECT 
        SUM(jan) jan, SUM(far) far, 
        NVL(SUM(MAR),0) MAR, 
        SUM(APR) APR, SUM(MAY) MAY, SUM(JUN) JUN
FROM 
      (SELECT DECODE(TO_CHAR(dt, 'MM'), 01, SUM(SALES)) JAN,
      (DECODE(TO_CHAR(dt, 'MM'), 02, SUM(SALES))) FAR,
      (DECODE(TO_CHAR(dt, 'MM'), 03, SUM(SALES))) MAR,
      (DECODE(TO_CHAR(dt, 'MM'), 04, SUM(SALES))) APR,
      (DECODE(TO_CHAR(dt, 'MM'), 05, SUM(SALES))) MAY,
      (DECODE(TO_CHAR(dt, 'MM'), 06, SUM(SALES))) JUN
       FROM sales
       GROUP BY TO_CHAR(dt, 'MM'))
;


-------------------- depth.SQL
create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);

insert into dept_h values ('dept0', 'XXȸ��', '');
insert into dept_h values ('dept0_00', '�����κ�', 'dept0');
insert into dept_h values ('dept0_01', '������ȹ��', 'dept0');
insert into dept_h values ('dept0_02', '�����ý��ۺ�', 'dept0');
insert into dept_h values ('dept0_00_0', '��������', 'dept0_00');
insert into dept_h values ('dept0_01_0', '��ȹ��', 'dept0_01');
insert into dept_h values ('dept0_02_0', '����1��', 'dept0_02');
insert into dept_h values ('dept0_02_1', '����2��', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '��ȹ��Ʈ', 'dept0_01_0');
commit;


 ����Ŭ ������ ���� ����
 SELECT ...
 FROM ...
 WHERE
 START WITH ���� : � ���� ���������� ������
 
 CONNECT BY ��� ���� �����ϴ� ����
            PRIOR : �̹� ���� �� -- �̰ɷ� ���� !!!!!
            "   " : ������ ���� ��;
            
 ����� : �������� �ڽĳ��� ���� (�� ==> �Ʒ�);
 
 XXȸ��(�ֻ��� ����) ���� �����Ͽ� ���� �μ��� �������� ���� ����;
 
 select *
 from dept_h;
 
 SELECT dept_h.*, level, lpad(' ', (LEVEL-1)*4, ' ') || deptnm -- (LEVEL-1)*4 ������ 1�϶��� �鿩 ���� �� �ʿ䰡 �����ϱ� ������ 0���� �����. ������ 1�� ������ ������ �鿩���� 4��
 FROM dept_h
 START WITH deptcd = 'dept0'
 CONNECT BY PRIOR deptcd = p_deptcd; 
-- CONNECT BY  deptcd = PRIOR p_deptcd AND deptcd = PRIOR p_deptcd �̷��� PRIOR ������ ���� �ִ�.
 
-- ��� ���� ���� ���� (PIOR XXȸ�� - 3���� �� (�����κ�, ������ȹ��, �����ý��ۺ�))
-- PRIOR XXȸ��.deptcd = �����κ�.p_deptcd
-- PRIOR �����κ�.deptcd = ��������.p_deptcd

-- PRIOR XXȸ��.deptcd = ������ȹ��.p_deptcd
-- PRIOR ������ȹ��.deptcd = ��ȹ��.p_deptcd
-- ��ȹ��.p_deptcd = ��ȹ��Ʈ.p_deptcd

-- PRIOR XXȸ��.deptcd = �����ý��ۺ�.p.deptcd (����1��, ����2��)
-- PRIOR �����ý��ۺ�.deptcd = ����1��.p.deptcd
-- PRIOR ����1��.deptcd != ...
-- PRIOR �����ý��ۺ�.deptcd = ����2��.p.deptcd
-- PRIOR ����2��.deptcd != ...
