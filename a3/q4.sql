--Query4

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

--find average for each site
DROP VIEW IF EXISTS AvgFee CASCADE;
CREATE VIEW AvgFee AS 
SELECT site_id, avg(total) as avgCharge
FROM TotalCharge
GROUP BY site_id;

--find max for each site
DROP VIEW IF EXISTS MaxFee CASCADE;
CREATE VIEW MaxFee AS 
SELECT site_id, max(total) as maxCharge
FROM TotalCharge
GROUP BY site_id;

--find min for each site
DROP VIEW IF EXISTS MinFee CASCADE;
CREATE VIEW MinFee AS 
SELECT site_id, min(total) as minCharge
FROM TotalCharge
GROUP BY site_id;

--combine min max and avg for each site
DROP VIEW IF EXISTS q4 CASCADE;
CREATE VIEW q4 AS
SELECT AvgFee.site_id, avgCharge, maxCharge, minCharge
FROM AvgFee JOIN MaxFee ON AvgFee.site_id = MaxFee.site_id JOIN MinFee 
ON AvgFee.site_id = MinFee.site_id; 

