-- 사용자 목록조회
select * from mysql.user;

-- 사용자 생성
create user 'marketing'@'%' identified by 'test4321'; 
// 비번은 test4321
// localhost 를 붙이면 원격접속 안됨
'marketing' → 사용자명
'%' → 어떤 IP에서든 접속 허용(원격에서 접속이 가능한 계정)
'test4321' → 비밀번호

-- 사용자에게 권한 부여
grant select on board.author to 'marketing'@'%';
grant select , insert on board.* to 'marketing'@'%';
grant All privileges on board.* to 'marketing'@'%';

-- 사용자 권한회수
revoke insert on board.author from 'marketing'@'%';

-- 사용자 권한 조회
show grants for 'marketing'@'%';

-- 사용자 계정 삭제
drop user 'marketing'@'%';

// stored procedure  성능 좋아지고, 제어문 쓸수 있음 (프로젝트 할 때 쓴다)


-- View