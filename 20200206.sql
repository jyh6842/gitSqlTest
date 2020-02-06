-- sub7 다시 풀어보기

select *
from cycle;

select *
from product;

select *
from customer;

select *
from product;

-- 햄버거 지수
select sido, count(*)
from fastfood
where sido LIKE '%대전%'
group by sido;

--분자(KFC, 버거킹, 맥도날드)
select sido, sigungu, count(*)
from fastfood
where sido = '대전광역시'
and gb in ('KFC', '버거킹', '맥도날드')
group by sido, sigungu;

대전광역시	중구	7
대전광역시	동구	4
대전광역시	서구	17
대전광역시	유성구	4
대전광역시	대덕구	2;

select a.sido, a.sigungu, ROUND(a.c1/b.c2) hambuger_score
from
    (select sido, sigungu, count(*) c1
     from fastfood
     where /*sido = '대전광역시'
     and */gb in ('KFC', '버거킹', '맥도날드')
     group by sido, sigungu) a,
    
    (select sido, count(*) c2
     from fastfood
     where /*sido = '대전광역시'
     and */gb in ('롯데리아')
     group by sido, sigungu) b
     
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY hambuger_score;

-- fastfood 테이블을 한번만 읽는 방식으로 작성하기
SELECT sido, sigungu, ROUND((kfc+burgerking+mac) / lot, 2) buger_score
FROM
   (SELECT sido, sigungu, 
        NVL(SUM(DECODE(gb, 'KFC', 1)),0) kfc, 
        NVL(SUM(DECODE(gb, '버거킹', 1)),0) burgerking, 
        NVL(SUM(DECODE(gb, '맥도날드', 1)),0) mac, 
        NVL(SUM(DECODE(gb, '롯데리아', 1)),1) lot
    FROM fastfood
    where gb in ('KFC', '버거킹', '맥도날드', '롯데리아')
    GROUP BY sido,sigungu
    ORDER BY sido,sigungu)
ORDER BY buger_score DESC;


-- 근로소득액
SELECT *
FROM tax;

SELECT sido, sigungu, ROUND(sal/people) pri_sal
FROM tax
ORDER BY pri_sal DESC;


-- 햄버거 지수의 1위와 개인별 근로소득 금액 순위가 같은 시도별로 (조인)
-- 지수, 개인별 근로소득 금액으로 정렬후 ROWNUM을 통해 순위를 부여 같은 순위의 행끼리 조인
-- 햄버거지수 시도, 햄버거지수 시군구, 햄버거지수, 세금 시도, 세금 시군구, 개인별 근로소득액

SELECT *
FROM

    (SELECT rownum rowbugger, bugger.*
     FROM
        (SELECT  g1.sido, g1.sigungu, ROUND(g1_/g2_, 1)
        FROM (SELECT sido, sigungu, COUNT(gb) g1_
              FROM fastfood
              WHERE gb IN('KFC', '맥도날드', '버거킹') 
              GROUP BY sido, sigungu) g1,
             (SELECT sido, sigungu, COUNT(gb) g2_
              FROM fastfood
              WHERE gb IN('롯데리아') 
              GROUP BY sido, sigungu) g2
        WHERE g1.sido = g2.sido AND g1.sigungu = g2.sigungu
        ORDER BY ROUND(g1_/g2_, 1 ) desc) bugger) bugger_2,

    (SELECT rownum rowsaltax, saltax.*
     FROM  
        (SELECT sido, sigungu, ROUND(sal/people) pri_sal
        FROM tax
        ORDER BY pri_sal DESC) saltax) saltax_2

WHERE bugger_2.rowbugger = saltax_2.rowsaltax;


