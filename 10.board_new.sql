-- 회원 테이블 생성
-- id(pk), email(unique, not null), name(not null), password(not null)

-- 주소 테이블
-- id(pk), country(not null), city(not null), street(not null), author_id(fk, not null)



create table author(id bigint auto_increment primary key, email varchar(255) not null unique, 
name varchar(255), password varchar(255) not null);

create table address(id bigint auto_increment primary key, country varchar(255) not null, 
 city varchar(255) not null,  street varchar(255) not null, author_id bigint not null unique,
  foreign key(author_id) references author(id));

  -- post 테이블
  -- id, title(not null), contents
create table post(id bigint auto_increment primary key, title varchar(255),
contents varchar(3000), foreign key(author_id) references author(id))

-- 연결(junction) 테이블
create table author_post_list(id bigint auto_increment primary key, author_id bigint not null,
post_id bigint not null, foreign key(author_id) references author(id), foreign key(post_id) 
references post(id))

-- 복합키를 이용한 연결테이블 생성
create table author_post_list(author_id bigint not null, post_id bigint not null, 
primary key(author_id, post_id), foreign key(author_id) references author(id), foreign key(post_id) 
references post(id))

-- 회원가입 및 주소생성
insert into author(id, email, name , password) values(3, 'cc@naver.com', 'park', '1234');
insert into address(country, city, street, author_id) values('korea','incheon', 'bupyeong','3');
-- 글쓰기
insert into post(id, title, contents) values(3, 'hihihihi', 'hihihi..........');
insert into author_post_list values(3, 3)


-- 글전체 목록 조회하기 : 제목, 내용, 글쓴이 이름이 조회가 되도록 select 쿼리 생성
select p.*, a.name from post p 
inner join author_post_list apl on p.id = apl.post_id
inner join author a on a.id = apl.author_id
order by p.id;