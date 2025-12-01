2005/12/01

-- 인메모리 데이터베이스

storage : 용량많다. 저렴. 성능느림. 영구기억장치
메모리(rem) : 용량적음. 비쌈 (임시기억장치). 성능빠름. 임시기억장치

ex) Varchar는 메모리에 캐싱해서 좀 더 빠르다

[redis의 단점 또는 주의할 점]
1) 대용량의 데이터를 저장할때 redis는 안된다.
2) 데이터를 redis에만 저장하는건 안된다.

[redis 시간복잡도]
데이터베이스에서 값을 찾을때에는 full scan -> 복잡도 O(n)
redis는 n -> 1

[해쉬테이블이란 개념]
메모리에 주소값을 잡음 

# redis 설치할때 주의점
redis와 Linux 묶어서 설치 - > 컨테이너

docker run --name redis-container -d -p 6379:6379 redis
 -d : 백그라운드 옵션

[redis의 자료구조]
1. 기본자료구조 
"hongildong" : "홍길동"
2. list자료구조
"class1" : ["h1","h2"]

ex) Sorted Sets  = > zset 이라고도 함 (말그대로 정렬된 set)

# DEQUE와 리스트 차이점 
리스트 같은 경우 중간에 데이터가 삽입 되면 인덱스가 달라져서 효율이 떨어진다.
DEQUE는 양 끝단 데이터 삽입 가능

# window에서는 redis가 직접설치가 안됨 -> 도커를 통한 redis 설치
docker run --name my-redis-container -d -p 6379:6379 redis

<일반적으로> -- 강사님이 외우라고 했다가 -> 외워도 되는건 아니라고 하심,,;;??
redis 포트 6379
mariaDB 포트 3306
nginx : 포트 80
spring : 포트 8080
vue : 포트 3000

# redis 접속 명령어
redis-cli (될려면 전제가 있어야함) 이 명령이 실행되려면 ...  // 윈도우에서 직접 실행 안됨.
 -> 도커에 있는 가상pc로 들어가서 명령을 실행해야됨.

 # docker에 설치된 redis 접속 명령어 및 접속 방법
 docker ps로 컨테이너ID 확인
 docker exec -it 컨테이너ID redis-cli

# redis 는 0~15번까지의 db로 구성(default 0번)
# db번호 선택
select db번호

# db내 모든 키값 조회
keys *

# redis의 자료구조
-- Strings, Lists, Sets, Sorted Sets, Hashes

!면접질문! 회원저장할때 rdb, redis중 어떤 곳에 저장할지?
!면접답! rdb 회원 -> 영구적인 데이터 보관하는데 적절하다. 1) 안정성 2) 대용량
!면접답! 데이터의 양이 적다면 redis를 쓰겠다 -> 그러면 키값은 ? 중복이 안되는 ex)id로 쓰겠다.

# String 자료구조
# sets 키:value 형식으로 값 세팅
set user:email:1 hong@naver.com -> 기본값이 문자열이랑 " " 안붙여도 됨
set user:email:2 hong2@naver.com -> user:email:1 로 키값 저장하면 덮어쓰게됨 
# 이미 존재하는 key를 set하면 덮어쓰기 된다
set user:email:1 hong2@naver.com
# key값이 이미 존재하면 pass시키고 없을때만 set하기 위해서는 nx옵션 사용
set user:email:1 hong3@naver.com nx -> (nil) : set되지 않음
# 만료시간(ttl) 설정은 ex옵션 사용(초단위)  // time to live
set user:email:2 hong2@naver.com ex 30

# get key를 통해 value값 구함 (조회하는 방법)
get user:email:1 
# 특정 key값 삭제
del 키값
# 현재 DB내 모든 key값 삭제
flushdb

# redis String 자료구조 실전활용
1)좋아요 2)재고관리 3)캐싱 4)로그인시 토큰저장 
# 사례1 : 좋아요기능구현 -> 동시성이슈 해결
set likes:posting:1 0 #redis는 기본적으로 모든 key:value가 문자열. 그래서 0으로 세팅해도 내부적으로 "0"으로 저장
incr likes:posting:1 #특정key값의 value를 1만큼 증가
decr likes:posting:1 #특정key값의 value를 1만큼 감소
# 사례2 : 재고관리 -> 동시성이슈 해결
set stock:product:1 100
incr stock:puoduct:1
decr stock:puoduct:1
# 사례 3 : 로그인 성공시 토큰 저장 -> 빠른 성능
set user:1:refresh_token abcdexxxxx ex 1800 -> 30분동안 토큰유효
# 사례 4 : 데이터 캐싱 -> 빠른 성능
set member:info:1 "{\"name\":\"hong\", \"email\":\"hong@daum.net\", \"age\":30}" ex 1000

hashes와 비슷해보이지만 String 형식
-> hashes는 데이터 수정하려면 name 불러와서 hong2로 수정하지만
   String은 데이터 수정하려면 전체를 불러와서 전체를 수정해야한다.

로그인에 대한 로직을 빈번한 조회를 하므로 redis 씀

# List 자료구조
# redis의 list는 deque와 같은 자료구조. 즉, double-ended-queue구조
lpush students kim1
lpush students lee1
rpush students park1

students:[lee1, kim1 , park1]
# List조회
lrange students 0 2 #0번째부터 2번째까지
lrange students 0 -1 #0부터 끝까지
lrange students 0 0 #0번째값만 조회
#list값 꺼내기(꺼내면서 삭제)
rpop students 
lpop students
# A리스트에서 rpop하여 B리스트에 lpush : 잘 안쓰임
rpoplpush A리스트 B리스트
rpoplpush students students
# list의 데이터 개수 조회
llen students
# expire, ttl 문법 모두 사용가능
# redis List 자료구조 실전활용
# 사례1 : 최근조회한상품목록
rpush user:1:recent:product apple
rpush user:1:recent:product banana
rpush user:1:recent:product orange
rpush user:1:recent:product melon
rpush user:1:recent:product mango
# 최근본 상품 목록 3개 조회
lrange user:1:recent:product -3 -1



# [set] 
# Set 자료구조 : 중복없음,  순서없음
sadd memberlist m1
sadd memberlist m2
sadd memberlist m3
sadd memberlist m3
# set맴버 조회
smembers memberlist 
# set의 맴버개수 조회  // card는 카디널어티
scard memberlist
# redis set 자료구조 실전활용
# 사례1 : 좋아요 구현
# 게시판상세보기에 들어가면
scard likes:posting:1 #좋아요 개수
sismember likes:posting:1 abc@naver.com #내가 좋아요를 눌렀는지 안눌렀는지 (특정값 존재여부)
sadd likes:posting:1 abc@naver.com # 좋아요를 누른 경우
srem likes:posting:1 abc@naver.com # 좋아요 취소

# [zset]
# zset 자료구조 : sorted set
# zset활용 사례1 : 최근본상품목록
# zset도 set이므로 같은 상품을 add할 경우에 중복이 제거되고, score(시간)값만 업데이트
zadd user:1:recent:product 151400 apple
zadd user:1:recent:product 151401 banana
zadd user:1:recent:product 151402 orange
zadd user:1:recent:product 151403 melon
zadd user:1:recent:product 151404 mango
zadd user:1:recent:product 151405 melon
# zset조회 : zrange(score 기준 오른차순 정렬), zrevrange(내림차순 정렬)
zrange user:1:recent:product -3 -1
zrevrange user:1:recent:product 0 2
zrevrange user:1:recent:product 0 2 withscores

# [hashes]
# hashes 자료구조 : value가 map형태의 자료구조 (key:value, key:value, ... 형태의 구조) 
# set member:info:1 "{\"name\":\"hong\", \"email\":\"hong@daum.net\", \"age\":30}" 과의 비교
hset member:info:1 name hong email hong@daum.net age 30

# 특정값 조회
hget member:info:1 name 
# 특정값 수정
hset member:info:1 name hong2
# 빈번하게 변경되는 객체값을 저장시에는 hashes가 성능 효율적

캐싱 -> String, hashes 중 하나로 캐싱함

실시간 채팅 서비스 같은 경우
-> 서버가 개인pc의 위치를 알고 있어야 한다.
 (서버컴퓨터의 메모리에 저장하고 있다)



redis(데이터저장소), kafka(메시지저장소)

redis
1) pub/sub : 메시지 저장 X && 전파 -> 성능빠름. 메시지 유실가능성

2) redis streams : 메세지 저장 && 전파 -> 메세지유실 가능성X, 성능느림

[SW공학]

1) 폭포수 모델 - top down 방식
계획-요구사항분석-설계-구현-시험-유지보수
:대규모 모놀리식 시스템 개발에 적합
2) 애자일 방법