-- 테이블 삭제 순서
DROP 


-- member 테이블 데이터 조회

SELECT mem_id, mem_name
FROM member 
-- WHERE mem_id = 'a001';
ORDER BY mem_id ASC;


-- sql 컴파일 순서(처리순서)
-- 조회
-- Select > From(테이블) > Where(And,Or 포함) > Group By > Having(And,Or 포함) > 컬럼1,컬럼2.. > Order By
SELECT 컬럼1, 컬럼2....
FROM 테이블1, 테이블2...
WHERE 조건
	AND 조건
	OR 조건
GROUP BY 그룹컬럼1, 그룹컬럼2..
	HAVING 그룹조건들
	AND 그룹조건들
	OR 그룹조건들
ORDER BY 정렬컬럼1, 정렬컬럼2..;


-- 입력 처리순서
-- Insert(입력인지) > Into 테이블 > 입력할 컬럼 확인 > values > 저장할 값 확인
INSERT INTO 테이블 (입력할컬럼지장,..)
	VALUES (저장할 값, ..);

-- 수정 처리 순서 
-- Update(수정인지) > 테이블 확인 > Where 조건 확인 > Set 수정할 컬럼과 값 확인 후 처리
-- Where 절이 없으면 수정할 컬럼의 모든 행 수정
UPDATE 테이블
	SET 수정할컬럼명1=수정할값,
		 수정할컬럼명2=수정할값,
	WHERE 수정조건들..
	AND 조건들
	OR 조건들;
	
	
-- 삭제 처리 순서
-- Delete (삭제인지) > From 테이블 정보 확인 > Where(and,or 포함) > 조건처리 > 삭제 실행
-- Where절이 없으면 테이블의 모든행을 삭제
DELETE FROM 테이블명
WHERE 조건들
  AND 조건들
  OR 조건들;
  
  
  

-- 회원정보 전체 조회
SELECT *
FROM member;

-- 조건 조회하기
-- 회원중 이름이 김씨인 회원들만 조회 / 정렬은 이름중심 오름차순/조회 컬럼은 아이디와 이름
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '김%' -- % : 모든이라는 뜻 / _ : 문자열 하나
ORDER BY mem_name ASC;

-- 두개이상 조건 사용
-- 회원 아이디, 이름, 지역 조회 / 회원 이름이 김씨 / 사는 지역이 대전 / 정렬은 지역 기준
SELECT mem_id, mem_name, SUBSTR(mem_add1,1,2) AS mem_add  -- 해당 열의 문자열의 첫번째부터 두번째까지 뽑아라 / 마지막에 메모리에 선언 -> 조건에 못씀 
FROM member
WHERE mem_name LIKE '김%' AND SUBSTR(mem_add1,1,2) = '대전'
ORDER BY mem_add DESC ; -- orderby는 마지막 실행으로 별칭으로 가능


-- 조건 : 김씨 성이고 대전 또는 서울
SELECT mem_id, mem_name, SUBSTR(mem_add1,1,2) AS mem_add  
FROM member
WHERE mem_name LIKE '김%' AND (SUBSTR(mem_add1,1,2) = '대전' OR SUBSTR(mem_add1,1,2) = '서울')
ORDER BY mem_add DESC ;


-- 그룹 만들어서 조회
-- 그룹은 보통 _~~별로 조회하는 의미로  사용됨 / 그룹을 위해 사용되는 함수
-- count(), min(), max(), sum(), avg()
-- 회원정보 중 마일리지의 최대, 최소, 합, 평균을 조회 / 지역별로
-- 그룹함수와 일반컬럼(또는 일반함수)를 동시에 사용해서 조회하는경우 무조건 일반컴럼(또는 일반함수)는 Group by절 뒤에 제시
SELECT SUBSTR(mem_add1,1,2) AS mem_add, COUNT(mem_mileage) AS cnt_mileage, MIN(mem_mileage) AS min_mileage,
		 MAX(mem_mileage) AS max_mileage, SUM(mem_mileage) AS sum_mileage, ROUND(AVG(mem_mileage),3) AS avg_mileage
FROM member
-- WHERE 
GROUP BY SUBSTR(mem_add1,1,2);
-- HAVING COUNT(mem_mileage) ;



-- 위 코드에 마일리지 평균이 2500 이상인 값에대해 조회
SELECT SUBSTR(mem_add1,1,2) AS mem_add, COUNT(mem_mileage) AS cnt_mileage, MIN(mem_mileage) AS min_mileage,
		 MAX(mem_mileage) AS max_mileage, SUM(mem_mileage) AS sum_mileage, ROUND(AVG(mem_mileage),3) AS avg_mileage
FROM member
-- WHERE 
GROUP BY SUBSTR(mem_add1,1,2)
HAVING AVG(mem_mileage) >= 2500;




-- 위 조건에 마일리지의 최소값이 100이상/ 지역이 서울 또는 대전 또는 부산
SELECT SUBSTR(mem_add1,1,2) AS mem_add, COUNT(mem_mileage) AS cnt_mileage, MIN(mem_mileage) AS min_mileage,
		 MAX(mem_mileage) AS max_mileage, SUM(mem_mileage) AS sum_mileage, ROUND(AVG(mem_mileage),3) AS avg_mileage
FROM member
WHERE SUBSTR(mem_add1,1,2) IN ('서울', '대전', '부산') -- Not In 도 가능
-- WHERE SUBSTR(mem_add1,1,2) = '서울' OR SUBSTR(mem_add1,1,2) = '대전' OR SUBSTR(mem_add1,1,2) = '부산'
GROUP BY SUBSTR(mem_add1,1,2)
HAVING AVG(mem_mileage) >= 2500 
	AND MIN(mem_mileage) >= 100;


-- 회원 중 주문(장바구니)을 한번도 하지않은 회원 찾기
-- 서브쿼리 사용
SELECT *
FROM member
WHERE mem_id NOT IN (
		SELECT cart_member
		FROM cart);


SELECT COUNT(*) FROM member;

-- 주문내역이 있는 회원만 조회 / join 방식 / 위 코드에서 Not만 빼면되긴한다
-- 중복 행 제거 : Distinct
-- Inner Join(일반 조인 방식)
SELECT DISTINCT mem_id, mem_name, cart_member
FROM member, cart
-- 관계조건식(PK = FK)
WHERE mem_id = cart_member;

-- ANSI 표준방식 - 국제표준
SELECT DISTINCT mem_id, mem_name, cart_member
FROM member INNER Join cart
	ON (mem_id = cart_member);
-- 관계조건식(PK = FK)
-- WHERE mem_id = cart_member;



-- 통계처리하기
-- 회원전체에 대해 주문수량의 합을 조회
-- Join - 일반방식
SELECT mem_id, SUM(cart_qty) AS sum_qty
FROM member, cart 
WHERE mem_id = cart_member
GROUP BY mem_id;  -- 19건


-- 표준방식 사용해야함
SELECT mem_id, IFNULL(SUM(cart_qty),0) AS sum_qty
FROM member LEFT OUTER JOIN  cart 
	ON(mem_id = cart_member)
-- WHERE mem_id = cart_member
GROUP BY mem_id;



-- join방식 : Inner Join - PK = FK 관계조건 만족, 같은 것에 대해 조회
-- 			  Outer Join(Left Outer Join, Right Outer Join, Full Outer Join) - PK = FK 관계조건 만족, 
-- 											테이블의 위치에 따라 전체중 있으면 있는대로로, 없으면 NULL,
-- 											일반적으로 Left Outer Join을 사용, Full Outer Join은 오라클 DB에서 사용되지만, 사용되지 않음
--				  Cross Join - 관계조건 없음, 제시된 테이블의 모든 행을 교차 조회, 사용되지 않음










