
##Step One Calculation##
SELECT hack_license, surchage, (FLOAT(total_amount)-FLOAT(tolls_amount)) AS decile
FROM [833682135931:nyctaxi.trip_fare];
####deciles
SELECT percentile_cont(0.1) OVER ( ORDER BY decile) AS one,
       percentile_cont(0.2) OVER ( ORDER BY decile) AS two,
	   percentile_cont(0.3) OVER ( ORDER BY decile) AS three,
	   percentile_cont(0.4) OVER ( ORDER BY decile) AS four,
	   percentile_cont(0.5) OVER ( ORDER BY decile) AS five,
	   percentile_cont(0.6) OVER ( ORDER BY decile) AS six,
	   percentile_cont(0.7) OVER ( ORDER BY decile) AS seven,
	   percentile_cont(0.8) OVER ( ORDER BY decile) AS eight,
	   percentile_cont(0.9) OVER ( ORDER BY decile) AS nine,
FROM [taxi.decile]

SELECT percentile_cont(0.1) OVER ( ORDER BY decile) AS tenpercentile
FROM [taxi.decile]

SELECT percentile_cont(0.1) OVER ( ORDER BY decile) AS tenpercentile
FROM [taxi.decile]

SELECT percentile_cont(0.1) OVER ( ORDER BY decile) AS tenpercentile
FROM [taxi.decile]

SELECT percentile_cont(0.1) OVER ( ORDER BY decile) AS tenpercentile
FROM [taxi.decile]

SELECT percentile_cont(0.1) OVER ( ORDER BY decile) AS tenpercentile
FROM [taxi.decile]
##Step two triptime##
SELECT hack_license, trip_time_in_secs
FROM [833682135931:nyctaxi.trip_data];

##Step three merge table##
SELECT t1.hack_license, t1.surcharge, t1.decile, t2.trip_time_in_secs
FROM [taxi.decile2] AS t1
JOIN EACH
[taxi.triptime] AS t2
ON t1.hack_license = t2.hack_license;

##Step Four Random Sampling##
SELECT  * FROM [taxi.mergebig] 
WHERE RAND()<16393638/1057934841265;
