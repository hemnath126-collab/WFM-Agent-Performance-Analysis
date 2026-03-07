use WFM_PROJECT;


SET SQL_SAFE_UPDATES = 0;

select * 
from agent_performance
where attendance_status != "Holiday"
limit 50;

alter table 
	agent_performance
	modify 
		shift_start_time Time,
	modify 
		shift_end_time Time,
	modify 
		login_time Time,
	modify 
		logout_time Time,
	modify 
		talk_time Time,
	modify 
		hold_time Time,
	modify 
		after_call_work Time,
	modify 
		tea_break_time Time,
	modify 
		lunch_break_time Time,
	modify 
		bio_break_time Time,
	modify 
		training_time Time;


/*4.Find the  shirinkage percent by team*/
WITH Team_shrinkage_percent AS (
    SELECT 
        team,
        ROUND(
            SUM(CASE 
                    WHEN attendance_status IN ('Present') THEN 1
                    WHEN attendance_status IN ('Half day') THEN 0.5
                    ELSE 0
                END)/
            NULLIF(
                SUM(CASE 
                        WHEN attendance_status NOT IN ('Week off','Holiday','Leave') THEN 1
                        ELSE 0
                    END),
            0),
        2) * 100 AS shrinkage_percent
    FROM agent_performance 
    GROUP BY team
)

SELECT 
    team,
    shrinkage_percent 
FROM Team_shrinkage_percent;


/*Find the  shirinkage percent by gender*/
WITH gender_shrinkage_percent AS (
    SELECT 
        gender,
        ROUND(
            SUM(CASE 
                    WHEN attendance_status IN ('Present') THEN 1
                    WHEN attendance_status IN ('Half day') THEN 0.5
                    ELSE 0
                END)/
            NULLIF(
                SUM(CASE 
                        WHEN attendance_status NOT IN ('Week off','Holiday','Leave') THEN 1
                        ELSE 0
                    END),
            0),
        2) * 100 AS shrinkage_percent
    FROM agent_performance 
    GROUP BY gender
)

SELECT 
    gender,
    shrinkage_percent 
FROM gender_shrinkage_percent;

WITH Month_shrinkage_percent AS (
    SELECT 
        Month(date) As Month,
        ROUND(
            SUM(CASE 
                    WHEN attendance_status IN ('Present') THEN 1
                    WHEN attendance_status IN ('Half day') THEN 0.5
                    ELSE 0
                END)/
            NULLIF(
                SUM(CASE 
                        WHEN attendance_status NOT IN ('Week off','Holiday','Leave') THEN 1
                        ELSE 0
                    END),
            0),
        2) * 100 AS shrinkage_percent
    FROM agent_performance 
    GROUP BY Month
)

select 
	Month,
    shrinkage_percent
From Month_shrinkage_percent;

/*Find the  Team_Absenteeism_Rate*/

with Absenteeism_Rate as(
	select team, round(
				sum(case when attendance_status in ("Leave" ,"Uninformed Leave") then 1 
						  when attendance_status = "Half day" then 0.5
						  else 0
					end)/
				sum(case when attendance_status != "Holiday" then  1 
						 else 0
					End),2)*100 as Absenteeism_Rate
	from agent_performance
    group by team
) 

select 
	team,
    Absenteeism_Rate
 from Absenteeism_Rate;
 
 /*Find the  Month Wise Absenteeism_Rate*/
 
 with Month_Absenteeism_Rate as(
	select 
		Month(date) as Month, 
        round(
				sum(case when attendance_status in ("Leave" ,"Uninformed Leave") then 1 
						  when attendance_status = "Half day" then 0.5
						  else 0
					end)/
				sum(case when attendance_status != "Holiday" then  1 
						 else 0
					End),2)*100 as Absenteeism_Rate
	from agent_performance
    group by Month
) 

select 
	Month,
    Absenteeism_Rate
 from Month_Absenteeism_Rate;
 
/*Add Total login Hrs*/
Alter table
	agent_performance
    add
    total_login Time;
    
Update agent_performance
set total_login = 
		SEC_TO_TIME( 
			GREATEST( 
				TIME_TO_SEC(COALESCE(logout_time,'00:00:00')) 
                - TIME_TO_SEC(COALESCE(login_time,'00:00:00')) 
					,0));


/*Creat a Metrics View*/

CREATE VIEW v_agent_metrics AS
SELECT
    agent_id,
    team,
    gender,
    age,
    date,
    calls_handled,
    attendance_status,
    shift_start_time,
    shift_end_time,
	total_login,

    /* Total Handle Time */
    SEC_TO_TIME(
        TIME_TO_SEC(avg_talk_time) * calls_handled +
        TIME_TO_SEC(avg_hold_time) * calls_handled +
        TIME_TO_SEC(avg_after_call_work) * calls_handled
    ) AS total_handle_time,

    /* Average Handle Time */
    ROUND(
        (
            TIME_TO_SEC(avg_talk_time) +
            TIME_TO_SEC(avg_hold_time) +
            TIME_TO_SEC(avg_after_call_work)
        ),2
    ) AS avg_handle_time,

    /* Total Break Time */
    SEC_TO_TIME(
        TIME_TO_SEC(COALESCE(tea_break_time,'00:00:00')) +
        TIME_TO_SEC(COALESCE(lunch_break_time,'00:00:00')) +
        TIME_TO_SEC(COALESCE(bio_break_time,'00:00:00'))
    ) AS total_break_time,

    /* Effective Work Hours */
    SEC_TO_TIME(
        GREATEST(
            TIME_TO_SEC(total_login)
            - (
                TIME_TO_SEC(COALESCE(tea_break_time,'00:00:00')) +
                TIME_TO_SEC(COALESCE(lunch_break_time,'00:00:00')) +
                TIME_TO_SEC(COALESCE(bio_break_time,'00:00:00')) +
                TIME_TO_SEC(COALESCE(training_time,'00:00:00'))
            ),
        0)
    ) AS effective_work_hours

FROM agent_performance;

select * from v_agent_metrics;

/*Create agent productivity view*/

CREATE VIEW v_agent_productivity AS
SELECT
    agent_id,
    team,
    gender,
    date,
    calls_handled,

    total_login,
    total_handle_time,
    avg_handle_time,
    effective_work_hours,

    /* Occupancy */
    LEAST(
        ROUND(
            TIME_TO_SEC(total_handle_time)
            /
            NULLIF(TIME_TO_SEC(effective_work_hours),0)
            * 100,
        2),
    100) AS occupancy,

    /* Utilization */
    LEAST(
        ROUND(
            TIME_TO_SEC(effective_work_hours)
            /
            NULLIF(TIME_TO_SEC(total_login),0)
            * 100,
        2),
    100) AS utilization,

    /* Age Category */
    CASE
        WHEN age BETWEEN 21 AND 27 THEN '21 TO 27'
        WHEN age BETWEEN 28 AND 34 THEN '28 TO 34'
        WHEN age BETWEEN 35 AND 41 THEN '35 TO 41'
        ELSE 'Others'
    END AS age_category,

    /* Shift Category */
    CASE
        WHEN shift_start_time = '08:00:00' THEN '8AM - 5PM'
        WHEN shift_start_time = '09:00:00' THEN '9AM - 6PM'
        WHEN shift_start_time = '11:00:00' THEN '11AM - 8PM'
        WHEN shift_start_time = '14:00:00' THEN '2PM - 11PM'
    END AS shift_timings

FROM v_agent_metrics
WHERE attendance_status NOT IN
('Week off','Leave','Uninformed Leave','Holiday','Absent');

select * from v_agent_productivity;

/*Find the Team Wise Performance data*/
SELECT 
	Team,
    Sum(calls_handled) as Total_call_handled,
    Sec_to_time(Round(avg(time_to_sec(total_Handle_time)))) as Avg_call_Handle_hours,
    Round(avg(avg_handle_time),2) as avg_handle_time,
    Sec_to_time(Round(avg(time_to_sec(total_login)))) as Avg_login,
    SEC_TO_TIME(ROUND(AVG(TIME_TO_SEC(effective_work_hours)))) AS Avg_effective_work_hours,
    Round(avg(occupancy),2) as Avg_occupancy,
    Round(avg(utilization),2) as Avg_utilization
from v_agent_productivity  
group by Team;

/*Find the Gender Wise Performance data*/
SELECT
    gender,
    SUM(calls_handled) Total_Calls_handled,
	Round(avg(avg_handle_time),2) as avg_handle_time,
    Round(avg(occupancy),2) as Avg_occupancy,
    Round(avg(utilization),2) as Avg_utilization
FROM v_agent_productivity
GROUP BY gender;

/*Find the Month Wise Performance data*/
SELECT
    MONTH(date) AS month,
    SUM(calls_handled) Total_Calls_handled,
	Round(avg(avg_handle_time),2) as avg_handle_time,
    Round(avg(occupancy),2) as Avg_occupancy,
    Round(avg(utilization),2) as Avg_utilization
FROM v_agent_productivity
GROUP BY month;

/*Find the Age_category Wise Performance data*/
SELECT
    age_category,
    SUM(calls_handled) Total_Calls_handled,
	Round(avg(avg_handle_time),2) as avg_handle_time,
    Round(avg(occupancy),2) as Avg_occupancy,
    Round(avg(utilization),2) as Avg_utilization
FROM v_agent_productivity
GROUP BY age_category;


/*Find the shift_timing Wise Performance data*/
SELECT
    shift_timings,
    SUM(calls_handled) Total_Calls_handled,
	Round(avg(avg_handle_time),2) as avg_handle_time,
    Round(avg(occupancy),2) as Avg_occupancy,
    Round(avg(utilization),2) as Avg_utilization
FROM v_agent_productivity
GROUP BY shift_timings;

/*Creat a view to find the prodectivity_Score*/
Create View 
v_agent_productivity_score As
	select
		Team,
		agent_id,
		case
			when avg_handle_time <= 280 Then 100
			when avg_handle_time <= 310 Then 90
			when avg_handle_time <= 340 Then 80
			else 70
			End  As Aht_score,
		 occupancy,
		 utilization
	From v_agent_productivity;

select * from v_agent_productivity_score;


/*Find the Top 5 agent_prodectivity_Score by team*/
Select * 
From(
	select 
		Team,
		agent_id,
		((Aht_score * 0.4) +
		 (occupancy * 0.3)+
		 (utilization * 0.3)
		)AS prodectivity_Score,
		
		row_number() over(
			partition by Team 
			Order by (
				(Aht_score * 0.4) + 
				(occupancy * 0.3) + 
				(utilization * 0.3)) 
				DESC
		)AS Score_rank
	From v_agent_productivity_score
    ) ranked_agents
Where score_rank  <= 5
order by Team,prodectivity_Score Desc;


