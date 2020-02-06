-- sub7 �ٽ� Ǯ���

select *
from cycle;

select *
from product;

select *
from customer;

select *
from product;

-- �ܹ��� ����
select sido, count(*)
from fastfood
where sido LIKE '%����%'
group by sido;

--����(KFC, ����ŷ, �Ƶ�����)
select sido, sigungu, count(*)
from fastfood
where sido = '����������'
and gb in ('KFC', '����ŷ', '�Ƶ�����')
group by sido, sigungu;

����������	�߱�	7
����������	����	4
����������	����	17
����������	������	4
����������	�����	2;

select a.sido, a.sigungu, ROUND(a.c1/b.c2) hambuger_score
from
    (select sido, sigungu, count(*) c1
     from fastfood
     where /*sido = '����������'
     and */gb in ('KFC', '����ŷ', '�Ƶ�����')
     group by sido, sigungu) a,
    
    (select sido, count(*) c2
     from fastfood
     where /*sido = '����������'
     and */gb in ('�Ե�����')
     group by sido, sigungu) b
     
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY hambuger_score;

-- fastfood ���̺��� �ѹ��� �д� ������� �ۼ��ϱ�
SELECT sido, sigungu, ROUND((kfc+burgerking+mac) / lot, 2) buger_score
FROM
   (SELECT sido, sigungu, 
        NVL(SUM(DECODE(gb, 'KFC', 1)),0) kfc, 
        NVL(SUM(DECODE(gb, '����ŷ', 1)),0) burgerking, 
        NVL(SUM(DECODE(gb, '�Ƶ�����', 1)),0) mac, 
        NVL(SUM(DECODE(gb, '�Ե�����', 1)),1) lot
    FROM fastfood
    where gb in ('KFC', '����ŷ', '�Ƶ�����', '�Ե�����')
    GROUP BY sido,sigungu
    ORDER BY sido,sigungu)
ORDER BY buger_score DESC;


-- �ٷμҵ��
SELECT *
FROM tax;

SELECT sido, sigungu, ROUND(sal/people) pri_sal
FROM tax
ORDER BY pri_sal DESC;


-- �ܹ��� ������ 1���� ���κ� �ٷμҵ� �ݾ� ������ ���� �õ����� (����)
-- ����, ���κ� �ٷμҵ� �ݾ����� ������ ROWNUM�� ���� ������ �ο� ���� ������ �ೢ�� ����
-- �ܹ������� �õ�, �ܹ������� �ñ���, �ܹ�������, ���� �õ�, ���� �ñ���, ���κ� �ٷμҵ��

SELECT *
FROM

    (SELECT rownum rowbugger, bugger.*
     FROM
        (SELECT  g1.sido, g1.sigungu, ROUND(g1_/g2_, 1)
        FROM (SELECT sido, sigungu, COUNT(gb) g1_
              FROM fastfood
              WHERE gb IN('KFC', '�Ƶ�����', '����ŷ') 
              GROUP BY sido, sigungu) g1,
             (SELECT sido, sigungu, COUNT(gb) g2_
              FROM fastfood
              WHERE gb IN('�Ե�����') 
              GROUP BY sido, sigungu) g2
        WHERE g1.sido = g2.sido AND g1.sigungu = g2.sigungu
        ORDER BY ROUND(g1_/g2_, 1 ) desc) bugger) bugger_2,

    (SELECT rownum rowsaltax, saltax.*
     FROM  
        (SELECT sido, sigungu, ROUND(sal/people) pri_sal
        FROM tax
        ORDER BY pri_sal DESC) saltax) saltax_2

WHERE bugger_2.rowbugger = saltax_2.rowsaltax;


