/*
  Constraints successfully applied
  - Divers must be at least 16 years of age
  - Certificates held by divers must be one of 'NAUI', 'CMAS', 'PADI'
  - Each monitor can have privileges to more than one site
  - Ratings applied to site or monitors must be between 0 and 5
  - Each diver may rate a site or monitor more than once
  - Paid services provided by a site must be one of 'items' listed below
  - Free services provided by a site must be one of 'free_service' listed below
  - Prices charged by a moitor must be greater than 0
  - Lead divers can make only one booking at a given date and time

  Constraints we chose not to apply
  - No monitor is allowed to book more than 2 dives per 24 hour period
  - Number of divers for a booking must be less than capacity of monitor
  - Total number of divers at a site must be less than the site's capacity
*/

DROP SCHEMA IF EXISTS dive CASCADE;
CREATE SCHEMA dive;
SET SEARCH_PATH to dive, public;

create domain certificates as varchar(4)
    not null
    constraint valid_certification
    check (value in ('NAUI', 'CMAS', 'PADI'));

-- DIVERS TABLE
/*
  driver_id - primary key to distinguish divers
  firstname - Divers first name
  surname - Divers last name
  birthdate - Birthdate stored in date object. Age of diver must be greater than 16 years
  certification - certificate of diver, must be in domain certificates
*/
CREATE TABLE Divers (
  diver_id INT PRIMARY KEY,
  firstname VARCHAR(50) NOT NULL,
  surname VARCHAR(50) NOT NULL,
  birthdate date NOT NULL check(age(birthdate) >= '16 years'),
  certification certificates NOT NULL
);

create domain times as varchar(10)
    not null
    constraint valid_time
    check (value in ('morning', 'afternoon', 'night'));

--DIVESITES
/*
  site_id - primary key to distinguish sites
  name - name given to dive site
  location - location name of dive site
  price_per_diver - price charged for a dive (per booking) per diver
*/
CREATE TABLE DiveSites (
  site_id INT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  location VARCHAR(50) NOT NULL,
  price_per_diver INT NOT NULL
);

--MONITORS
/*
  monitor_id - primary key
  firstname - first name of monitor
  surname - last name of monitor
  email - email of monitor
*/
CREATE TABLE Monitors (
  monitor_id INT PRIMARY KEY,
  firstname VARCHAR(50) NOT NULL,
  surname VARCHAR(50) NOT NULL,
  email VARCHAR(50) NOT NULL
);

-- MONITOR CAPACITIES
/*
  monitor_id - foreign key constraint from Monitors table
  open_water_cap - monitor's capacity for open water diving
  cave_cap - monitor's capacity for cave diving
  deep_cap - monitor's capacity for deep cave diving
*/
CREATE TABLE MonitorCapacities (
  monitor_id INT PRIMARY KEY REFERENCES Monitors,
  open_water_cap INT NOT NULL,
  cave_cap INT NOT NULL,
  deep_cap INT NOT NULL
);

--PRIVELEGES
/*
  monitor_id - foreign key constraint from Monitors table
  site_id - foreign key constraint from DiveSites table
*/
CREATE TABLE Priveleges (
  monitor_id INT NOT NULL REFERENCES Monitors,
  site_id INT NOT NULL REFERENCES DiveSites,
  PRIMARY KEY (monitor_id, site_id)
);

--RATINGS
--Site ratings
/*
  diver_id - foreign key constraint from Divers table
  site_id - foreign key constraint from DiveSites table
  rating - rating assigned by diver to site
*/
CREATE TABLE SiteRatings (
  diver_id INT NOT NULL REFERENCES Divers,
  site_id INT NOT NULL REFERENCES DiveSites,
  rating INT NOT NULL check(rating >= 0 AND rating <= 5),
  PRIMARY KEY(diver_id,site_id,rating)
);

--Monitor ratings
/*
  diver_id - foreign key constraint from Divers table
  monitor_id - foreign key constraint from Monitors table
  rating - rating assigned by diver to monitor
*/
CREATE TABLE MonitorRatings (
  diver_id INT NOT NULL REFERENCES Divers,
  monitor_id INT NOT NULL REFERENCES Monitors,
  rating INT NOT NULL check(rating >= 0 AND rating <= 5),
  PRIMARY KEY(diver_id,monitor_id,rating)
);

--Additional Services
create domain items as varchar(10)
    not null
    constraint valid_item
    check (value in ('mask', 'regulator', 'fins', 'computer'));

--Paid Services
/*
  site_id - foreign key constraint from DiveSites table
  items - paid services provided by the site
  price - price of paid item at this particular site
*/
CREATE TABLE PaidServices (
  site_id INT NOT NULL REFERENCES Divesites,
  item items NOT NULL,
  price INT check (price > 0),
  PRIMARY KEY(site_id,item)
);

--Free services
create domain free_service as varchar(10)
    not null
    constraint valid_free_service
    check (value in ('dive_video', 'snacks', 'shower', 'towels'));

-- Free Services
/*
  site_id - foreign key constraint from DiveSites table
  service - free service provided at this site
*/
CREATE TABLE FreeServices (
  site_id INT NOT NULL REFERENCES DiveSites,
  service free_service NOT NULL,
  PRIMARY KEY(site_id,service)
);


--Monitor prices
create domain dive_types as varchar(10)
    not null
    constraint valid_free_service
    check (value in ('open', 'cave', 'deep'));

/*
  monitor_id - foreign key constraint from Monitors table
  site_id - foreign key constraint from DiveSites table
  dive_type - dive type for which price is going to be determined
  time - time of day at which dive is taking place
  price - price charged by the diver at this site, for the chosed dive type and time
*/
CREATE TABLE MonitorPrices (
  monitor_id INT NOT NULL REFERENCES Monitors,
  site_id INT NOT NULL REFERENCES DiveSites,
  dive_type dive_types NOT NULL,
  time times NOT NULL,
  price INT check (price > 0),
  PRIMARY KEY(monitor_id,site_id,dive_type,time)
); 

--DIVE SITE CAPACITIES
/*
  site_id - foreign key constraint from DiveSites table
  time - time of day at which dive is taking place
  dive_type - dive type for which capacity is going to be determined
  capacity - maximum capacity allowed for dive type, at this site at this time of day
*/
CREATE TABLE SiteCapacities (
  site_id INT NOT NULL REFERENCES DiveSites,
  time times NOT NULL,
  dive_type dive_types NOT NULL,
  capacity INT NOT NULL,
  PRIMARY KEY(site_id,time,dive_type)
);

--Credit card details
/*
  card_id - primary key
  diver_id - id of diver this card belongs to
  card_num - card number of diver
  ccv_num - security number at back of card
*/
CREATE TABLE Card (
  card_id INT PRIMARY KEY,
  diver_id INT NOT NULL REFERENCES Divers,
  card_num BIGINT NOT NULL,
  ccv_num INT NOT NULL
); 

--Bookings
/*
  book_id - primary key
  diver_id - id of lead_diver making the booking
  monitor_id - id of monitor booking was made with
  site_id - id of site at which booking was placed
  dive_type - type of dive booking was made for
  time - time at which dive is meant to take place
  date - date at which booking has been placed
  num_divers - total number of divers, includes a single monitor
  email - email of lead diver making the booking
  card-id - id of card used to place the booking, belongs to the lead diver
*/
CREATE TABLE Bookings (
  book_id INT PRIMARY KEY,
  diver_id INT NOT NULL REFERENCES Divers,
  monitor_id INT NOT NULL REFERENCES Monitors,
  site_id INT NOT NULL REFERENCES DiveSites,
  dive_type dive_types NOT NULL,
  time times NOT NULL,
  date date NOT NULL,
  num_divers INT check (num_divers > 1),
  email VARCHAR(50) NOT NULL,
  card_id INT NOT NULL REFERENCES Card,
  UNIQUE(diver_id, time, date)
); 

--Group
/*
  book_id - foregin key constraint from Bookings
  diver_id - id of diver participating in this booking
*/
CREATE TABLE GroupInfo (
  book_id INT NOT NULL REFERENCES Bookings,
  diver_id INT NOT NULL REFERENCES Divers,
  PRIMARY KEY (book_id,diver_id)
);

-- Keep track of number of type and number of items provided at a site
CREATE TABLE BookingPaidServices (
  book_id INT NOT NULL REFERENCES Bookings,
  item items NOT NULL,
  quantity INT NOT NULL
);

-- Keep track of free services provided at a site
CREATE TABLE BookingFreeServices (
  book_id INT NOT NULL REFERENCES Bookings,
  service free_service NOT NULL
);
