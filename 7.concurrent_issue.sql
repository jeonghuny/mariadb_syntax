-- read uncommitted : 커밋되지 않은 데이터 read 가능 -> dity read 문제 발생
ex) A가 재고 100있던거 0으로 만들고 커밋 안한 상태에서, B가 재고 조회하면 0개 임
-- 실습절차
-- 1)워크벤치에서 auto_commit해제. update실행. commit하지 않음(transaction1)
-- 2)터미널을 열어 select했을때 위 update변경사항이 읽히는지 확인(transactrion2)
-- 결론 : mariadb는 기본이 repeatable read 이므로 dirty read 발생 x


-- read committed : 커밋한 데이터만 read 가능 -> Phantom read 발생(또는 non-reapeatable)
ex) 실시간으로 select 되는 데이터가 다를 수 있음. (그사이 커밋이 발생되어서) : phantom read
-- 실습절차
-- 1)워크벤치에서 아래 코드 실행
start transaction;
select count(*) from author;
do sleep(15);
select count(*) from author;
commit;
-- 2)터미널을 열어 아래 코드 실행
insert into author(email) values('gggd@naver.com');

-- repeatable read : 읽기의 일관성 보장 -> lost update문제 발생 -> 배타lock(배타적 잠금)으로 해결
-- lost update 문제 발생하는 상황
DELIMITER //
create procedure concurrent_test1()
begin
    declare count int;
    start transaction;
    insert into post(title, author_id) values('hello world', 1);
    select post_count into count from author where id=1;
    do sleep(15);
    update author set post_count=count+1 where id=1;
    commit;
end //
DELIMITER ;
call concurrent_test1();
-- 터미널에서는 아래 코드 실행
select post_count from author where id = 1;

-- 배타락을 통해 lost update 문제를 해결한 상황
-- select for update를 하게 되면 트랜잭션이 실행되는 동안 lock걸리고, 트랜잭션이 종료된 후에 lock풀림
DELIMITER //
create procedure concurrent_test2()
begin
    declare count int;
    start transaction;
    insert into post(title, author_id) values('hello world', 1);
    select post_count into count from author where id=1 for update;
    do sleep(15);
    update author set post_count=count+1 where id=1;
    commit;
end //
DELIMITER ;
call concurrent_test2();
-- 터미널에서는 아래 코드 실행
select post_count from author where id = 1 for update;


-- Serializable : 모든 트랜잭션 순차적으로 실행 -> 동시성문제없음(성능저하)
