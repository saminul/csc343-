--Query2

--Find average monitor rating 
DROP VIEW IF EXISTS AvgMonRating CASCADE;
CREATE VIEW AvgMonRating AS
SELECT  monitor_id, avg(rating) as avgMon
FROM MonitorRatings
GROUP BY monitor_id;

--Find average monitor prices 
DROP VIEW IF EXISTS AvgMonPrice CASCADE;
CREATE VIEW AvgMonPrice AS
SELECT  monitor_id, avg(price) as avgPrice
FROM MonitorPrices
GROUP BY monitor_id;

--Find average dive site rating 
DROP VIEW IF EXISTS AvgSiteRating CASCADE;
CREATE VIEW AvgSiteRating AS
SELECT  site_id, avg(rating) as avgSite
FROM SiteRatings
GROUP BY site_id;

--combining adding average monitor rating to priveleges table
DROP VIEW IF EXISTS Inter1 CASCADE;
CREATE VIEW Inter1 AS
SELECT Priveleges.monitor_id, site_id, avgMon
FROM AvgMonRating JOIN Priveleges 
ON Priveleges.monitor_id = AvgMonRating.monitor_id;

--combining adding average site rating to inter1 table
DROP VIEW IF EXISTS Inter2 CASCADE;
CREATE VIEW Inter2 AS
SELECT a1.monitor_id, a1.site_id, avgMon, avgSite
FROM Inter1 as a1 JOIN AvgSiteRating 
ON a1.site_id = AvgSiteRating.site_id;

--Find all monitors whose average rating is higher than those of all the sites they monitor
DROP VIEW IF EXISTS ValidMonitors CASCADE;
CREATE VIEW ValidMonitors AS
SELECT monitor_id
FROM Inter2 as a1
WHERE a1.avgMon > ALL (select avgSite from Inter2 as a2 where a1.monitor_id = a2.monitor_id)
GROUP BY monitor_id;

--find the corresponding acerage monitor price and email
DROP VIEW IF EXISTS q2 CASCADE;
CREATE VIEW q2 AS
SELECT ValidMonitors.monitor_id, avgPrice, email
FROM ValidMonitors, AvgMonPrice, Monitors
WHERE ValidMonitors.monitor_id = AvgMonPrice.monitor_id AND AvgMonPrice.monitor_id = Monitors.monitor_id;


