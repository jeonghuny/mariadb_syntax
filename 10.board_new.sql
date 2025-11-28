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
insert into address(country, city, street, author_id) values('korea','incheon', 'bupyeong',
(select id from author order id by desc limit 1));
-- 글쓰기
-- 최초 생성자
insert into post(title, contents) values('hihihihi', 'hihihi..........');
insert into author_post_list (author_id, post_id), values(
  (select id from author where email = 'abac@naver.com'), 
  (select id  from post order by id desc limit 1))
-- 추후 참여자
update ..
insert into author_post_list values(1,2)


-- 글전체 목록 조회하기 : 제목, 내용, 글쓴이 이름이 조회가 되도록 select 쿼리 생성
select p.id, p.title, p.contents, a.name from post p 
inner join author_post_list ap on p.id = ap.post_id
inner join author a on a.id = ap.author_id
order by p.id;

 


정규화 -> 실습(요구사항, 설계, 구축) -> 

정규화의 직관적인 룰
1. 데이터의 원자성 보장
2. 성격의 차이
3. 데이터의 중복 방지
4. 데이터의 확장성

후보키 : PK가 

도메인분해(1차)
부분종속제거(2차)
이행종속제거(3차)
결정자이면서...(BCNF) => 후보키가 아닌데 결정자 ex)학부 -> 
다치종속제거(4차)
조인종속제거(5차)

역정규화 : 쪼개진 두테이블을 다시 합치는것
=> address
반정규화 : count값을 추가하는 것




주문시스템
1. 엑셀로 더미데이터 넣은 캡쳐본 제출
2. erd설계 -> 캡쳐 제출
3. erd 기반의 DB구축 및 테스트데이터 삽입 

회원가입 : role 로 구분, 회원테이블
상품등록 : 재고컬럼, 판매자가 not null member_id (fk)
주문하기 : 상품, 수량, 주문번호, 주문가격, 주문취소여부, 

1. 회원가입
insert
2. 상품등록
insert
3. 주문하기
insert : 주문넣기
update : 재고감소
4. 
5. 주문정보조회


-- 회원 추가
insert into user(name , seller_yn, email, phone, pwd) values(
'kim','y','aaa@naver.com','010-8621-7138','1234');

-- 물품 추가
insert into product(product_name, seller_id, stock, price) values(
'key', 1, 5, 10000);

-- 상품 주문
insert into orders(success_yn, user_id, order_date, order_price) 
values('y',3, '2025-10-20', 10000);
insert into orders(success_yn, user_id, order_date, order_price) 
values('y',3, '2025-10-20', 500000);
insert into product_orders_list(order_id, product_id, quantity) 
values(3,1,1);
insert into product_orders_list(order_id, product_id, quantity) 
values(4,3,1);

update product 
set stock = stock - (select quantity from product_orders_list where order_id = 3 and product_id = 1)
where id = 
(select product_id from product_orders_list where order_id = 3 and product_id = 1);

update product 
set stock = stock - (select quantity from product_orders_list where order_id = 4 and product_id = 3)
where id = 
(select product_id from product_orders_list where order_id = 4 and product_id = 3)

-- 주문정보 조회
select o.id, u.name, u.id, o.order_date, o.order_price, p.product_name, p.seller_id, o.success_yn
from orders o inner join product_orders_list po on o.id = po.order_id
inner join user u on u.id = o.user_id
inner join product p on p.id = po.product_id;

















create table user(id bigint auto_increment primary key, name varchar(200) not null,
seller_yn enum('y','n') not null, email varchar(200), phone varchar(200),
pwd varchar(200) not null);

create table product(id bigint auto_increment primary key, product_name varchar(200) not null,
seller_id bigint not null, stock int not null, price int not null);

create table orders(id bigint auto_increment primary key, success_yn enum('y','n') not null,
order_date date not null, order_price bigint not null, user_id bigint not null,
foreign key(user_id) references user(id));

create table product_orders_list(id bigint auto_increment primary key, quantity int not null,
product_id bigint not null, order_id bigint not null,
foreign key(product_id) references product(id), foreign key(order_id) references orders(id));

alter table product add constraint foreign key(seller_id) references user(id);