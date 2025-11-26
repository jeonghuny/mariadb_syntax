-- pk, fk, unique제약조건 추가시에 해당컬럼에 대해 index페이지 자동생성
-- 별도의 컬럼에 대해 index 추가 생성 가능

board스키마
- author : id, name, email ...
=> pk, unique, fk -> 조회가 빈번하니까 인덱스 만든다
=> 원하면 얼마든지 추가

- post
=> 


-- index 조회
show index from author;

-- 기존 index 삭제
alter table author drop index 인덱스명;


-- 신규 index 생성
create index 인덱스명 on 테이블명(컬럼명);
create index name_index on author(name);


-- index는 1컬럼 뿐만 아니라, 2컬럼을 대상으로 1개의 index를 설정하는 것도 가능
-- 이 경우 두컬럼을 and조건으로 조회해야만 index를 사용
create index 인덱스명 on 테이블명(컬럼1, 컬럼2);

-- 카디널리티(데이터의 종류)
 => 극단적으로 높은것 -> index설정

 where 컬럼1=? and 컬럼2=?
1) 두 컬럼을 대상으로 인덱스 설정
2) 컬럼1에만 인덱스가 만들어져 있다면
3) 컬럼2에만 인덱스가 만들어져 있다면
4) 컬럼1, 컬럼2에 각각 인덱스가 있다면

pk -> 제약조건 + 인덱스 생성 -> 인덱스만 별도 삭제 O- -> 인덱스만 추가
fk-> 제약조건 + 인덱스 생성 -> 인덱스만 별도 삭제 O- -> 인덱스만 추가
unique -> 제약조건 + 인덱스 생성 -> 인덱스를 삭제하면 제약조건 같이 삭제하면
이외 칼럼 -> 인덱스 인위적 생성 -> 인덱스 따로 삭제

기본 index 삭제할일이 별로 없음
=> 그외 index추가/삭제

-- index성능테스트
-- 기존테이블 삭제 후 간단한 테이블로 index설정 or index미설정 테스트

create table author(id bigint auto_increment, email varchar(255), name varchar(255), primary key(id));
create table author(id bigint auto_increment, email varchar(255) unique, name varchar(255), primary key(id));


프로젝트 
기획 -> ERD설계(논리적 데이터 모델링)(ex. erd cloud)
-> 구축(ddl문) -> 테스트(dml문)

중간프로젝트(백엔드+프론트)

erd cloud

-- 부모 자식 헷갈릴때
1. 자식에 FK설정
2. 누가 부모고, 누가 자식테이블인가 // 삭제되면 누가 같이 삭제되는지 확인

author address

-- n : M 일때
ex) post 테이블의 글쓴이 : 1,2 / 1,3 / 2,3 으로 변경된다면
1. FK 지정 안됨
2. 값 변경 어려움
3. 


1. 회원가입
2. 글쓰기
3. 게시글 상세목록 조회
 select * from post p where id = 3 inner join author A
 on a.id = p.author
 