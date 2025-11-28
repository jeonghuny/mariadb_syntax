// stored procedure  성능 좋아지고, 제어문 쓸수 있음 (프로젝트 할 때 쓴다)

-- view : 실제데이터를 참조만 하는 가상의 테이블. select만 가능
-- 사용목적 : 1)권한분리 2)복잡한 쿼리를 사전 생성
ex) 마켓팅팀에 회원의 이메일, 지역정보 정도만 필요한 경우
ex) 주문테이블에서 "월간 매출 집계" 를 자주 조회하는 팀이 있는 경우

-- view 생성
create view author_view as select name, email from author;
create view author_view2 as select p.title, a.name, a.email from post p inner join author a on p.author_id = a.id

-- view 조회 (테이블 조회와 동일)
select * from author_view;

-- view에 대한 권한 부여
grant select on board.author_view to 'marketing'@'%';

-- view삭제
drop view author_view;

// 뷰랑 프로시저 한글 지원함.
----------------
계정 추가 생성
계정마다 특정 테이블, view에 권한 부여

-- Procedure
SQL 문을 미리 컴파일하여 저장함으로써 데이터베이스 서버의 부하를 줄이고 성능을 향상

-- 프로시저 생성
delimiter //
create procedure hello_procedure()
begin 
    select "hello world";
end
// delimiter ;

-- 프로시저 호출
call hello_procedure();

-- 프로시저삭제
drop procedure hello_procedure;

-- 회원목록조회 프로시저생성 -> 한글명 프로시저 가능
delimiter //
create procedure 회원목록조회()
begin
    select * from author;
end
// delimiter ;

-- 회원상세조회 -> input(매개변수)값 여러개 사용 가능 -> 프로시저 호출시 순서에 맞게 매개변수 입력
delimiter //
create procedure 회원상세조회(in idInput bigint)
begin
    select * from author where id = idInput ;
end
// delimiter ;
(사용자가 ui 환경에서 입력하면 id값이 idInput로 들어가고 조건절의 ?자리로 들어가서 조회된다.)

-- 전체 회원수 조회 -> 변수사용
delimiter //
create procedure 전체회원수조회()
begin
    -- 변수선언
    declare authorCount bigint;
    -- into를 통해 변수에 값 할당
    select count(*) into authorCount from author ;
    -- 변수값 사용
    select authorCount;
end
// delimiter ;

-- 글쓰기
-- 사용자가 title, contents, 본인의 email 값을 입력
delimiter //
create procedure 글쓰기(in inputTitle varchar(255), inputContents varchar(255), inputEmail varchar(255))
begin
    -- begin밑에 declare를 통해 변수 선언
    declare a_id bigint;
    declare p_id bigint;
    -- email로 회원ID 찾기
    select id into a_id from author where email = inputEmail; 
    -- post 테이블에 insert
    insert into post(title, contents) values(inputTitle, inputContents);
    -- post 테이블에 insert된 id값 구하기
    select id into p_id from post where order by id desc limit 1;
    -- author_post_list테이블에 insert하기(author_id, post_id 필요)
    insert into author_post_list (author_id, post_id) value(a_id, p_id);
end
// delimiter ;

-- 롤백 있는 버전

-- 글쓰기
delimiter //
create procedure 글쓰기(in titleInput varchar(255), in contentsInput varchar(255), in emailInput varchar(255))
begin
    -- begin밑에 declare를 통해 변수 선언
    declare authorId bigint;
    declare postId bigint;
    -- 아래 declare는 변수선언과는 상관없는 예외관련 특수문법
    declare exit handler for SQLEXCEPTION
    begin
        rollback;
    end;
    start transaction;
        select id into authorId from author where email = emailInput;
        insert into post(title, contents) values(titleInput, contentsInput);
        select id into postId from post order by id desc limit 1;
        insert into author_post_list(author_id, post_id) values(100, postId);
    commit;
end
// delimiter ;

-- 글삭제 -> if else문
delimiter //
create procedure 글삭제(in postIdInput bigint, in authorIdInput bigint)
begin
    declare authorCount bigint;
    -- 참여자의 수를 조회
    select count(*) into authorCount from author_post_list where post_id = postIdInput;
    if authorCount=1 then
        delete from author_post_list where post_id=postIdInput and author_id=authorIdInput;
        delete from post where id=postIdInput;
    else
        delete from author_post_list where post_id=postIdInput and author_id=authorIdInput;
    end if;
end
// delimiter ;

-- 대량글쓰기 -> while문을 통한 반복문 
delimiter //
create procedure 글도배(in count bigint, in emailInput varchar(255))
begin
    declare authorId bigint;
    declare postId bigint;
    declare countValue bigint default 0;
    while countValue<count do
        select id into authorId from author where email = emailInput;
        insert into post(title) values("안녕하세요");
        select id into postId from post order by id desc limit 1;
        insert into author_post_list(author_id, post_id) values(100, postId);
        set countValue = countValue+1;
    end while;
end
// delimiter ;

[DB엔진 종류]
innoDB는 트랜잭션 지원, 조회성능은 느림 (대부분 이거 씀)

myisam은 트랙잭션 지원x, 조회성능 빠름

1. DB인코딩을 utf설정X했고 테이블을 이미 생성했다면
2. 테이블마다 utf 설정 해야됨


[DB 서버 구성]
1.클러스터링 : 여러 서버를 묶는다
2.레플리카 : 복제
3.샤딩 : 나눈다.

-- 클러스터링
: 두 개 이상의 DB 서버를 하나의 “묶음(cluster)”으로 구성
-> 한 서버가 죽어도 다른 서버가 자동으로 서비스 이어받도록 하는 구조

-- 레플리카
: Primary(주 서버)의 데이터를 1개 이상의 Replica 서버에 복제
: 데이터가 실시간으로 복제되어야 됨.
: 조회 트래픽이 훨씬 많은 서비스, DR센터운영

-- 샤딩
: DB 사이즈가 너무 커지거나 트래픽이 폭증했을 때 데이터를 수평 분할하는 구조.
: 부하분산

샤딩전략
1) Hash sharding -> 추가 하면 기존데이터 전부 재조정해야됨 (해쉬함수가 변경)
2) Dynamic sharding -> 범위가 지정되어있다. 한페이지 추가하면 단점 페이지
3) UUID


[HA전략]

고사용성 : 높은사용성 -> 장애가 없는 사용성
HA구성 == 서버의 다중화 구성을 의미
- 서버를 여러개 구성


-> 로드밸런서라고도 부르고, HAProxy, 리버스Proxy 라고도 함.

