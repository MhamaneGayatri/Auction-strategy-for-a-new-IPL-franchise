select * from ipl_ball limit 10;

select * from ipl_matches limit 10;

select batsman,count(ball),sum(batsman_runs)
from ipl_ball group by batsman having count(ball)>500 order by count(ball) desc;

--Task 1
select batsman,
		count(ball)as total_balls,sum(batsman_runs) as total_batsman_runs,
		(sum(batsman_runs)*100.0)/count(ball) as Strike_rate
from ipl_ball
where extras_type!='wides'
group by batsman 
having count(ball)>=500
order by strike_rate desc limit 10;
	
--Task 2

select distinct batsman,
		sum(batsman_runs) as total_runs,
		sum(is_wicket) as total_wickets,
		count(distinct(extract(year from match_date))) as seasons,
		sum(batsman_runs)*1.0/sum(is_wicket) as average
from deliveries_v03 
group by batsman having count(distinct(extract(year from match_date)))>2
order by average desc limit 10;

---Task 3
select  batsman,
		(sum(case when batsman_runs=4 then batsman_runs when batsman_runs=6 then batsman_runs else 0 end))as batsman_boundaries,
		sum(batsman_runs) as batsman_total_runs,
		sum(total_runs) as total_runs,
		count(distinct(extract(year from match_date))) as seasons,
		(sum(case when batsman_runs=4 then batsman_runs when batsman_runs=6 then batsman_runs else 0 end) * 1.0) / sum(total_runs) *100.0 as boundary_percentage
from deliveries_v03
group by batsman having  count(distinct(extract(year from match_date)))>2 
order by boundary_percentage desc limit 10;


--Bidding  On Bowlers
--Task 4

select 
	bowler,
	sum(total_runs) as total_runs,
	count(ball),
	sum(total_runs)/(count(ball)/6.0) as economy_rate
from deliveries_v03
group by bowler having count(ball)>500
order by economy_rate asc limit 10;


--Task 5

select bowler,
	count(ball),
	sum(is_wicket),
	(count(ball)*1.0/sum(is_wicket)) as strike_rate
from deliveries_v03
group by bowler having count(ball)>500
order by  strike_rate limit 10;

--Task 6
select a.*,b.* from
	(select 
 		batsman,count(ball)as total_balls,
    	sum(batsman_runs) as total_batsman_runs,
		(sum(batsman_runs)*100.0)/count(ball) as batting_Strike_rate 
	from deliveries_v03 
 	group by batsman having count(ball)>=500 
	order by batting_strike_rate desc )
as a Inner join 
	(select
		bowler,
		count(ball),
		sum(is_wicket),
		(count(ball)*1.0/sum(is_wicket)) as bowler_strike_rate 
    from deliveries_v03
	group by bowler having count(ball)>300
	order by  bowler_strike_rate)
as b
on a.batsman=b.bowler;		


--Additional questions
create table deliveries as select * from ipl_ball;
select * from deliveries;

create table matches as select * from ipl_matches;
select * from matches;

--Additional question q1
select count(distinct city) as No_of_cities from matches;

------Additional questions q2
create table deliveries_v02 as
select a.*,
	case
		when a.total_runs>=4 then 'boundary'
		when a.total_runs=0  then 'dot'
		else 'other'
	end as ball_result
from deliveries a;
select * from deliveries;
select total_runs,ball_result from deliveries_v02;
--additional q3
select 
	ball_result,
	count(ball_result)
from deliveries_v02 
group by ball_result having ball_result in ('boundary','dot');

select count(ball_result) from deliveries_v02 where ball_result='boundary';

--additional q4
select count(ball_result),batting_team from deliveries_v02 where ball_result='boundary' group by batting_team order by count(ball_result) desc;

--additional q5
select count(ball_result),batting_team from deliveries_v02 where ball_result='dot' group by batting_team order by count(ball_result) desc;

--additional q6
select count(dismissal_kind) from deliveries_v02 where dismissal_kind!='NA'

--additional q7
select bowler,sum(extra_runs) from deliveries group by bowler order by sum(extra_runs)desc limit 5;

---- additionl question q8
create table deliveries_v03 as
select a.*,b.venue as match_venue,b.dates as match_date
from deliveries_v02 as a 
left join matches as b 
on a.id=b.id;
	
select * from deliveries_v03;
	
--additional q9
select sum(total_runs),match_venue from deliveries_v03 group by match_venue order by sum(total_runs) desc;

--additional q10
select distinct extract (year from match_date) as yearWise,count(total_runs) from deliveries_v03 where match_venue='Eden Gardens' group by yearWise order by count (total_runs) desc;
---------------------------
create table deliveries_test as
select a.*,
	case
		when a.total_runs=4 then 'boundary' when a.total_runs=6 then 'boundary'
		when a.total_runs=0  then 'dot'
		else 'other'
	end as ball_result
from deliveries a;

select * from deliveries_test;

select ball_result,count(ball_result)from deliveries_test group by ball_result having ball_result in ('boundary','dot','other');

--Cognizant GenC---learning concept class

select car_id,car_name,car_type from cars where car_name like 'Maruti%' and car_type like 'S___n' order by car_id;

select owner_name||owner_id......
select rental_id,car_id,customer_id,km_driven,extract(date from pickup_date)from rentals where  extract(date from pickup_date)='8-2019;'

-----coalesce funtion:- used to handle missing values
select customer_id,customer_name,
		coalesce(address,coalesce(email_id,'NA'))
		
--
select a.hotel_id,a.hotel_name,a.hotel_type from hotel_details as a join orders as b
on a.hotel_id=b.hotel_id
where b.order_date!='2019-05';



SELECT
    batsman,
    total_balls,
    total_batsman_runs,
    (total_batsman_runs * 100.0) / total_balls AS Strike_rate
FROM (
    SELECT
        batsman,
        COUNT(ball) AS total_balls,
        SUM(batsman_runs) AS total_batsman_runs
    FROM
        ipl_ball
    WHERE
        extras_type != 'wides'
    GROUP BY
        batsman
) AS subquery
WHERE
    total_balls >= 500
ORDER BY
    Strike_rate DESC
LIMIT 10;
													