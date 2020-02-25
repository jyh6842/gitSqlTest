 SELECT *
 FROM v$SQL
 WHERE sql_text LIKE '%sql_test%';
 
 -- SQL_TEXT를 보면 대소문자 여러개이다.