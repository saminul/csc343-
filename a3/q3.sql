--Query3

--find the number of people on a site for a given date and time
DROP VIEW IF EXISTS DateCapacity CASCADE;
CREATE VIEW DateCapacity AS
SELECT site_id, time, date, sum(num_divers) as CurrCapacity
FROM Bookings
GROUP BY site_id, time, date;

--find the total capacity for a site at any give time
DROP VIEW IF EXISTS TotalCapacities CASCADE;
CREATE VIEW TotalCapacities AS 
SELECT site_id, time, sum(capacity) as TotalCapacity
FROM SiteCapacities
GROUP BY site_id, time
ORDER BY site_id;

--find percentage of fullness at given dates at times
DROP VIEW IF EXISTS inter1 CASCADE;
CREATE VIEW inter1 AS 
SELECT DateCapacity.site_id, DateCapacity.time, DateCapacity.date, ((CurrCapacity*100)/TotalCapacity) as percentage
FROM TotalCapacities, DateCapacity
WHERE TotalCapacities.site_id = DateCapacity.site_id AND TotalCapacities.time = DateCapacity.time;

--find average fullness for sites
DROP VIEW IF EXISTS fullness CASCADE;
CREATE VIEW fullness AS 
SELECT site_id, avg(percentage) as avgFull
FROM inter1
GROUP BY site_id;

--calculate the site fee: number of divers* fee per diver
-- (num_divers - 1) as num divers includes a monitor
DROP VIEW IF EXISTS siteCharge CASCADE;
CREATE VIEW siteCharge AS 
SELECT book_id, (num_divers-1)*price_per_diver as SiteFee
FROM Bookings JOIN  DiveSites ON Bookings.site_id = DiveSites.site_id;

--calculate the monitor fee for a given date,time,divetype and site
DROP VIEW IF EXISTS MonitorCharge CASCADE;
CREATE VIEW MonitorCharge AS 
SELECT book_id,Bookings.site_id, price as MonitorFee
FROM Bookings JOIN  MonitorPrices 
ON Bookings.monitor_id = MonitorPrices.monitor_id AND Bookings.site_id = MonitorPrices.site_id 
AND Bookings.dive_type = MonitorPrices.dive_type AND Bookings.time  = MonitorPrices.time;

--calculate total charge
--total charge = siteCharge + MonitorCharge
--assumption: exclude additional equipment and service charges
-- from total fee charged
DROP VIEW IF EXISTS TotalCharge CASCADE;
CREATE VIEW TotalCharge AS 
SELECT siteCharge.book_id, site_id, (MonitorFee + SiteFee) as total
FROM siteCharge JOIN MonitorCharge 
ON siteCharge.book_id = MonitorCharge.book_id;

--get the average fee for sites
DROP VIEW IF EXISTS AvgFee CASCADE;
CREATE VIEW AvgFee AS 
SELECT site_id, avg(total) as avgCharge
FROM TotalCharge
GROUP BY site_id;

--combine with % fullness
DROP VIEW IF EXISTS combined CASCADE;
CREATE VIEW combined AS 
SELECT fullness.site_id, avgFull, avgCharge
FROM fullness JOIN AvgFee 
ON fullness.site_id = AvgFee.site_id;

--categorize them as less or more
--bases on if they are more or less than half full
DROP VIEW IF EXISTS categorized CASCADE;
CREATE VIEW categorized AS 
(SELECT fullness.site_id, avgFull, avgCharge,  'less' as category
FROM fullness JOIN AvgFee on fullness.site_id = AvgFee.site_id
WHERE avgFull <= 50)
UNION
(SELECT fullness.site_id, avgFull, avgCharge,  'more' as category
FROM fullness JOIN AvgFee on fullness.site_id = AvgFee.site_id
WHERE avgFull > 50)
;

--grroup by category and find average
DROP VIEW IF EXISTS q3 CASCADE;
CREATE VIEW q3 AS 
SELECT category, avg(avgcharge)  as AvgFee
FROM categorized
GROUP BY category;
