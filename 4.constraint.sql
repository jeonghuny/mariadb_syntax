
-- not null 제약 조건 추가
alter table author modify column name varchar(255) not null;
-- not null 제약 조건 제거
alter table author modify column name varchar(255);
-- not null, unique 동시 추가
alter table author modify column email varchar(255) not null unique;

-- pk, fk, not null(덮어쓰기), unique 제거 방법 서로 다름

-- pk/fk 추가/제거
-- pk 제약조건 삭제
describe post;
select * from information_schema.key_column_usage where table_name='post';
alter table post drop primary key;

-- fk 제약조건 삭제
describe post;
select * from information_schema.key_column_usage where table_name='post';
alter table post drop foreign key fk명;

-- pk 제약조건 추가
alter table post add constraint post_pk primary key(id);
-- fk 제약조건 추가
alter table post add constraint post_fk foreign key(author_id) references author(id);
-> id가 반드시 Unique조건이나 primary key 이어야 함.

-- not null 추가 삭제 -> modify column
-- unique 추가 -> modify coulumn    // 삭제는 인덱스를 삭제해야됨.

-- on delete/on update 제약조건 변경 테스트
alter table post add constraint post_fk foreign key(author_id) references author(id) on delete set null on update cascade;

<실습>
1. 기존 fk 삭제
2. 새로운 fk 추가(on update/ on delete 변경)
3. 새로운 fk에 맞는 테스트
 3-1)삭제 테스트
 3-2)수정 테스트
 


 foreign key // ex) cascade(같이 수정,삭제 등)
 1) 기본 정의 : 부모테이블에 없는 데이터가 자식테이블에 insert 될수 없다.
 2) 옵션
  2-1)on delete : 기본값 - restrict, cascade, set null
  2-2)on update : 기본값 - restrict, cascade, set null

부모테이블에서 데이터가 삭제되는 경우(hard delete)
: 중요X -> 같이 삭제하자. cascade


-- default 옵션
-- 어떤 컬럼이든 default 지정이 가능하지만, 일반적으로 enum타입 및 현재시간에서 많이 사용
alter table author modify column name varchar(255) default 'anonymous';
-- auto_increment : 숫자값을 입력 안했을때, 마지막에 입력된 가장 큰값에 +1만큼 자동으로 증가된 숫자값 자동으로 적용
alter table author modify column id bigint(20) auto_increment;
alter table post modify column id bigint(20) auto_inrement;

     
-- uuid() 타입 : 함수 // 시스템 규모가 대규모일때 씀 (추후에 분산DB를 쓸거 같을 경우)
alter table post add column user_id char(36) default (uuid());
 함수 : 임의의 36짜리 숫자값으로 넣어줌

