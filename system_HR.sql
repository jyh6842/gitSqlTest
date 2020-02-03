해당 오라클 서버에 등록된 사용자(계정) 조회;
SELECT *
FROM dba_users;

account_status 에 expired & locked 된 것을 풀자;
HR 계정의 비밀번호를 JAVA로 초기화; --> expired 만 풀림
ALTER user HR identified by java;
ALTER user HR account unlock; --> locked --> open으로 풀림