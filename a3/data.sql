INSERT INTO DiveSites VALUES 
(0, 'Bloody Bay Marine', 'Little Cayman', 10),
(1, 'Widow Maker’s Cave', 'Montego Bay', 20),
(2, 'Crystal Bay', 'Crystal Bay', 15),
(3, 'Batu Bolong', 'Batu Bolong', 15);

INSERT INTO SiteCapacities VALUES 
(0, 'morning', 'cave', 10),
(0, 'afternoon', 'cave', 10),
(0, 'night', 'cave', 10),
(1, 'morning', 'open', 15),
(1, 'morning', 'cave', 10),
(1, 'afternoon', 'open', 15),
(1, 'afternoon', 'cave', 10),
(1, 'night', 'open', 15),
(1, 'night', 'cave', 10),
(2, 'morning', 'open', 10),
(2, 'morning', 'cave', 10),
(2, 'afternoon', 'open', 10),
(2, 'afternoon', 'cave', 10),
(2, 'night', 'open', 10),
(2, 'night', 'cave', 10),
(3, 'morning', 'open', 10),
(3, 'morning', 'cave', 10),
(3, 'morning', 'deep', 10),
(3, 'afternoon', 'open', 10),
(3, 'afternoon', 'cave', 10),
(3, 'afternoon', 'deep', 10),
(3, 'night', 'open', 10),
(3, 'night', 'cave', 10),
(3, 'night', 'deep', 10);

INSERT INTO PaidServices VALUES 
(0, 'mask', 5),
(0, 'fins', 10),
(1, 'mask', 3),
(1, 'fins', 5),
(2, 'fins', 5),
(2, 'computer', 20),
(3, 'fins', 10),
(3, 'computer', 30);

INSERT INTO Monitors VALUES
(0, 'Maria', 'Scofield', 'maria@wetworld.inc'),
(1, 'John', 'Krasinsky', 'john@wetworld.inc'),
(2, 'Ben', 'Affleck', 'ben@wetworld.inc');

INSERT INTO MonitorCapacities VALUES
(0, 10, 5, 5),
(1, 15, 15, 15),
(2, 15, 5, 5);

INSERT INTO Priveleges VALUES
(0, 0),
(0, 1),
(0, 2),
(0, 3),
(1, 0),
(1, 2),
(2, 1);

INSERT INTO MonitorPrices VALUES
(0, 0, 'cave', 'night', 25),
(0, 1, 'open', 'morning', 10),
(0, 1, 'cave', 'morning', 20),
(0, 2, 'open', 'afternoon', 15),
(0, 3, 'cave', 'morning', 30),
(1, 0, 'cave', 'morning', 15),
(2, 1, 'cave', 'morning', 20);

INSERT INTO Divers VALUES
(0, 'Michael', 'Scott', '1967-03-15', 'PADI'),
(1, 'Andy', 'Bernard', '1973-10-10', 'PADI'),
(2, 'Dwight', 'Schrute', '1970-09-12', 'CMAS'),
(3, 'Jim', 'Halpert', '1970-10-10', 'CMAS'),
(4, 'Pam', 'Beesly', '1971-02-03', 'CMAS'),
(5, 'Phyllis', 'Vance', '1967-01-10', 'CMAS'),
(6, 'Oscar', 'Martinez', '1971-01-11', 'CMAS');

INSERT INTO Card VALUES
(0, 0, 12345678, 111),
(1, 1, 87654321, 222);

INSERT INTO Bookings VALUES
(0, 0, 0, 1, 'open', 'morning', '2019-07-20', 6, 'michael@dm.org', 0),
(1, 0, 0, 1, 'cave', 'morning', '2019-07-21', 4, 'michael@dm.org', 0),
(2, 0, 1, 0, 'cave', 'morning', '2019-07-22', 3, 'michael@dm.org', 0),
(3, 0, 0, 1, 'cave', 'night', '2019-07-22', 3, 'michael@dm.org', 0),
(4, 1, 0, 2, 'open', 'afternoon', '2019-07-22', 14, 'andy@dm.org', 1),
(5, 1, 2, 1, 'cave', 'morning', '2019-07-23', 3, 'andy@dm.org', 1),
(6, 1, 2, 1, 'cave', 'morning', '2019-07-24', 3, 'andy@dm.org', 1);

INSERT INTO GroupInfo VALUES
(0, 0),
(0, 1),
(0, 2),
(0, 3),
(0, 4),
(1, 0),
(1, 2),
(1, 3),
(2, 0),
(2, 3),
(3, 0),
(4, 0),
(4, 1),
(4, 2),
(4, 3),
(4, 4),
(4, 5),
(4, 6),
(5, 1),
(6, 1);

INSERT INTO SiteRatings VALUES
(3, 0, 3),
(0, 1, 2),
(0, 1, 0),
(2, 1, 0),
(4, 1, 1),
(3, 1, 2),
(1, 2, 4),
(4, 2, 5),
(0, 2, 2),
(6, 2, 3);

INSERT INTO MonitorRatings VALUES
(0, 1, 5),
(1, 0, 2),
(1, 2, 0),
(1, 2, 2);
