�ش� ����Ŭ ������ ��ϵ� �����(����) ��ȸ;
SELECT *
FROM dba_users;

account_status �� expired & locked �� ���� Ǯ��;
HR ������ ��й�ȣ�� JAVA�� �ʱ�ȭ; --> expired �� Ǯ��
ALTER user HR identified by java;
ALTER user HR account unlock; --> locked --> open���� Ǯ��