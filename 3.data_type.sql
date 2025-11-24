 
정수(tityint, int, bigint) 
실수(decimal)
문자(char, varchar, text)
날짜(datatime), blob(잘안쓰임)
ENUM(중요)

-- tinyint : 1바이트 사용. -128~127까지의 정수표현 가능 (unsign시에 0~255)
alter table author add column age tinyint unsigned;

-- int : 4바이트 사용. 대략 40억 숫자범위 
-- bigint : 8바이트 사용.
-- author, post테이블의 id값을 bigint로 변경


-- 제약 조건 삭제(외래키명으로 삭제)
select * from information_schema.key_column_usage where table_name='post';
alter table post drop foreign key post_ibfk_1;
-- 제약조건 추가
alter table post add constraint post_fk foreign key(author_id) references author(id);

alter table author modify column id bigint;
alter table post modify column author_id bigint;
alter table post modify column id bigint;

-- decimal(총자리수, 소수부자리수) 고정소수점(decimal) vs 부동소수점
alter table author add column height decimal(4,1); // (전체자리수, 소수자리수)
-- 정상적으로 insert
insert into author (id, name, email, height) values(7,'홍길동3','sss@naver.com', 175.3)
-- 데이터가 잘리도록

char : 고정길이 -> ab
varchar : 가변길이, 최대길이지정, 메모리 저장 (조회성능 빠름), 빈번히 조회되는 짧은 길이의 데이터    //  메모리는 스토리지보다 비쌈
text : 가변길이, 최대길이지정 불가, 스토리지 저장, 빈번히 조회되지 않는 장문의 데이터
   -> 자소서, 소설, contents

길이가 딱 정해진 짧은 단어 : char 또는 varchar
장문의 데이터 : text or varchar
그외는 전부 varchar
1) 빈번히 조회가 되는 사항 -> 성능좋은 varchar
2) text는 indexing처리가 어려움.

-- 문자타입 : 고정길이(char), 가변길이(varchar, text)
alter table author add column id_number char(16);
alter table author add column self_introduction text;

-- blob(바이너리데이터) 실습
-- 일반적으로 blob으로 저장하기 보다는, 이미지를 별도로 저장하고, 이미지경로를 varchar로 저장.
alter table author add column profile_image longblob;
insert into author(id, name ,email,profile_image) values(9,'abc','abc@naver.com', LOAD_FILE('C:\\cat.png'))

-- enum : 삽입될 수 있는 데이터의 종류를 한정하는 데이터 타입
-- role컬럼 추가
alter table author add column role enum('admin','user') not null default 'user';
-- enum에서 지정된 role을 지정해서 insert
insert into author(id, name, email, role) values(11,'ddd','ddd@naver.com','admin');
-- enum에서 지정된 role을 지정하지 않고 insert
insert into author(id, name, email, role) values(12,'ddd','ddd@naver.com','super-admin'); -> 에러가
-- enum에서 지정되지 않은 role값을 insert 
insert into author(id, name, email) values(13,'ddd','ddd@naver.com');

-- date(연월일)와 datetime(연월일시분초)
-- 날짜타입의 입력, 수정, 조회시에는 문자열 형식을 사용
alter table author add column birthday date;
alter table post add column created_time datetime;
insert into post(id, title, contents, author_id, created_time) valuse(4,'hello','hello..',1, "2019-01-01 14:00:30");
-- datetime과 default 현재시간 입력은 많이 사용되는 패턴
alter table post modify column created_time datetime default current_timestamp();
insert into post(id, title, contents, author_id) values(5,'hello','hello..',1);

-- 비교연산자 (!=, <>)
select * from author where id>=2 and id<=4;
select * from author where id in(2,3,4);
select * from author where id between 2 and 4;

-- like : 특정 문자를 포함하는 데이터를 조회하기 위한 키워드
select * from post where title like "h%";
select * from post where title like "%h";
select * from post where title like "%h";

-- REGEXP : 정규표현식을 활용한 조회
자주사용되는 패턴 regularExpression(정규표현식)
select * from author where name regexp '[a-z]' --이름에 소문자알파벳이 포함된 경우
select * from author where name regexp '[가-힣]' --이름에 한글이 포함된 경우

-- 타입변환 - cast(유연함) vs dat_format
-- 문자 -> 숫자
select cast('12' as unsigned);
-- 숫자 -> 날짜
select cast(20251112 as date) -- 2025-11-21
-- 문자 -> 날짜
select cast('20251112' as date) -- 2025-11-21

-- 날짜타입변환 - date_format(Y, m, d, H, i, s)
select date_format(created_time, '%Y-%m-%d') from post;
select date_format(created_time, '%H-%i-%s') from post;
select * from post where date_format(created_time, '%Y') = "2025";
select * from post where date_format(created_time, '%m') = "11";
select * from post where cast(date_format(created_time, '%m') as unsigned) = 1;

-- 실습 : 2025년 11월에 등록된 게시글 조회
select * from post where date_format(created_time, '%Y-%m') = "2025-11";
select * from post where created_time like '2025-11%';

-- 실습 : 2025년 11월 1일부터 19일까지의 데이터를 조회
select * from post where created_time >= '2025-11-01' and created_time < '2025-11-20';
// 2025-11-20 00:00:00 

부모테이블에서 수정, 삭제 -> 자식테이블 영향

회원1번이 수정, 삭제하면 -> post테이블에 영향?!
1) 수정불가
2) 같이 수정
3) null로 세팅

1) 삭제불가(restrict)
2) 같이 삭제(cascading)
3) null로 세팅(set null)

