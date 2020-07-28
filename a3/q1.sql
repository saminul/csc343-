--Query1

--  first find all the divesites and and the divetypes they provide
DROP VIEW IF EXISTS dtypes CASCADE;
CREATE VIEW dtypes AS
SELECT site_id,dive_type
FROM SiteCapacities
GROUP BY site_id,dive_type;

--find hte number of monitors that have priveleges for a certain site and and dive types they support
DROP VIEW IF EXISTS MonitorCount CASCADE;
CREATE VIEW MonitorCount AS
SELECT dtypes.site_id, dtypes.dive_type, count(*) as num
FROM dtypes LEFT JOIN Priveleges 
ON Priveleges.site_id = dtypes.site_id
GROUP BY dtypes.site_id, dtypes.dive_type;

--combined the 2 previous tables to find sites where more than 1 monitor and count the number of dive sites that support that divetype
DROP VIEW IF EXISTS q1 CASCADE;
CREATE VIEW q1 AS
SELECT dive_type, count(site_id)
FROM MonitorCount
WHERE num >= 1
GROUP BY dive_type;
