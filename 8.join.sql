A inner join B 
 select * from post inner join author on post.author_id = author.id;
B inner join A 
 select * from author inner join post on author.id = post.author_id;
// 사실 출력되는 컬럼 순서만 다르다. 교집합이기 때문

A left (outer) join B == B right(outer) join A
B left join A == A right join B 

-- case1 : author inner join post
-- 글쓴적이 있는 글쓴이와 그 글쓴이가 쓴 글의 목록 출력
select * from author inner join post on author.id = post.author_id;
select * from author a inner join post p on a.id = p.author_id;
select a.*, p.* from author a inner join post p on a.id = p.author_id;

-- case2 : post inner join author
-- 글쓴이가 있는 글과 해당 글의 글쓴이를 조회
select * from post inner join author on post.author_id = author.id;
-- 글쓴이가 있는 글 전체 정보와 글쓴이의 이메일만 출력
select p.*, a.email from post p inner join author a on p.author_id = a.id;

-- case3 : author left join post
-- 글쓴이는 모두 조회하되, 만약 쓴글이 있다면 글도 함께 조회
select * from author a left join post p on a.id = p.author_id;

-- case4 : post left join author
-- 글을 모두 조회하되, 만약 글쓴이가 있다면 글쓴이도 함께 조회
// not null 이면 case2와 똑같이 될수도 있다.
select * from post p left join author a on a.id = p.author_id;

... 셀프조인왜글해요
-- 실습) 글쓴이가 있는 글 중에서 글의 제목과 저자의 email을 출력하되, 
-- 저자의 나이가 30세 이상인글만 출력
select a.email, p.title from post p inner join author a on p.author_id = a.id 
where age >= 30;


-- 실습) 글의 저자의 이름이 빈값(null)이 아닌 글 목록만을 출력.
select p.* from post p inner join author a on p.author_id = a.id where a.name is not null;

-- 조건에 맞는 도서와 저자 리스트 출력
-- 없어진 기록 찾기

-- union : 두 테이블의 select결과를 횡으로 결합
-- union시킬때 컬럼의 개수와 컬럼의 타입이 같아야함
select name, email from author union select title, contents from post;

-- union은 기본적으로 distinct가 적용. 중복허용하려면 union all 사용.
select name, email from author union all select title, contents from post;

-- 서브쿼리 : select문 안에 또다른 select문을 서브쿼리라함
-- where절 안에 서브쿼리
-- 한번이라도 글을 쓴 author의 목록 조회(중복 제거)
select distinct a.* from author a inner join post p on a.id = p.author_id
-- // null 값은 in조건절에서 자동으로 제외
select a.* from author a where id in (select author_id from post);

-- 컬럼 위치에 서브쿼리
-- 회원별로 본인의 쓴 글의 개수를 출력. ex)email, post_count
-- 글 안쓴사람도 0개로 카운트해서 출력.
select a.email, (select count(*) from post p where p.author_id = a.id) 
as post_count from author a;
// 조인보다 성능이 떨어짐

-- from절 위치에 서브쿼리
select a.* from (select * from author) as a;

-- group by 컬럼명 : 특정 컬럼으로 데이터를 그룹화 하여, 하나의 행(row)처럼 취급
select author_id from post group by author_id;
select author_id, count(*) from post group by author_id;
-- 회원별로 본인의 쓴 글의 개수를 출력. ex) email, post_count (left join으로 풀이)
select a.email, count(p.id) from author a left join post p
on p.author_id = a.id
group by a.email;

-- 집계함수
select count(*) from author;
select sum(age) from author;
select avg(age) from author;
-- 소수점 3번째 자리에서 반올림
select round(avg(age),3) from author;

-- group by와 집계함수
-- 회원의 이름별 회원수를 출력하고, 이름별 나이의 평균값을 출력하라.
select count(*) as count , avg(age) as avg from author group by name;
// count(*) 는 null 이어도 카운트 한다.

-- where와 group by 
-- 날짜값이 null인 데이터는 제외하고, 날짜별 post 글의 개수 출력.
select date_format(created_time, '%Y-%m-%d'), count(*) from post p 
where created_time is not null 
group by date_format(created_time, '%Y-%m-%d')
order by date_format(created_time, '%Y-%m-%d');

// (%H-%i-%s)
-- 자동차 종류 별 특정 옵션이 포함된 자동차 수 구하기
-- 입양 시각 구하기(1)

-- having : group by 된 결과의 집계함수에 대한 조건
-> author를 name으로 grouping -> 동명이인 3명이상인 데이터 필터링
having count(*) >= 3

-- group by와 having
-- having은 group by를 통해 나온 집계값에 대한 조건
-- 글을 2번 이상 쓴 사람 author_id찾기 
select author_id, count(*) from post group by author_id 
having count(*) >= 2;

-- 동명 동물 수 찾기
-- 카테고리 별 도서 판매량 집계하기
-- 조건에 맞는 사용자와 총 거래금액 조회하기