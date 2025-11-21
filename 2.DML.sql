-- insert : 테이블에 데이터 삽입
insert into 테이블명(컬럼1, 컬럼2, 컬럼3) values(데이터1, 데이터2, 데이터3);
-- 문자열은 일반적으로 작은따옴표 사용
insert into author(id, name, email) values(4, 'hongildong4','hongildong4@naver.com')

-- update : 테이블에 데이터를 변경
update author set name='홍길동', email='hong100@naver.com' where id=3;

-- delete : 삭제
delete from 테이블명 where 조건;
delete from author where id = 4;

-- select : 조회
select 컬럼1, 컬럼2 from 테이블명;
select name , email from author;

-- *은 모든 컬럼을 의미
select * from author;

-- select 조건절(where) 활용
select * from author where id = 1;
select * from author where name = '홍길동';
select * from author where id > 2 and name ='hongildong';
select * from author where id in(1,3,5);
-- 이름이 홍길동 인 글쓴이가 쓴 글 목록을 조회하시오
select * from post where author_id in (select id from author where name ='홍길동');

-- 중복제거 조회 : distinct
select name from author;
select distinct name from author;

-- 정렬 : order by + 컬럼명
-- asc : 오름차순 , desc : 내림차순, 안붙이면 오름차순(default)
-- 아무런 정렬조건 없이 조회할 경우에는 pk기준 오름차순 // order by id(pk)
select * from author order by name desc;

-- 멀티컬럼 order by : 여러컬럼으로 정렬시에, 먼저쓴컬럼 우선정렬하고, 중복시 그다음 컬럼으로 정렬적용.
select * from author order by name desc, email asc;

-- 결과값 개수 제한
-- 가장 최근에 가입한  회원 1명만 조회
select * from author order by id desc limit 1;

-- 별칭(alias)를 이용한 select
select name as '이름', email as '이메일' from author; 
select a.name, a.email from author as a;
select a.name, a.email from author a;

-- null을 조회조건으로 활용
select * from author where password is null;
select * from author where password is not null;

-- 프로그래머스 sql문제풀이

