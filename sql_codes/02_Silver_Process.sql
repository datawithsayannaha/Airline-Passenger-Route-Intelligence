-- Silver Process

-- 1. silver_region

DROP TABLE IF EXISTS silver_region;

CREATE TABLE silver_region AS
SELECT DISTINCT
       region_id,
       TRIM(region_name) AS region_name
FROM raw_region
WHERE region_id IS NOT NULL;

-- 2. silver_country

DROP TABLE IF EXISTS silver_country;

CREATE TABLE silver_country AS
SELECT DISTINCT
       country_id,
       INITCAP(TRIM(country_name)) AS country_name,
       INITCAP(TRIM(continent)) AS continent
FROM raw_country
WHERE country_id IS NOT NULL;


-- 3. silver_state

DROP TABLE IF EXISTS silver_state;

CREATE TABLE silver_state AS
SELECT DISTINCT
       state_id,
       INITCAP(TRIM(state_name)) AS state_name,
       region_id,
       country_id
FROM raw_state
WHERE state_id IS NOT NULL;


-- 4. silver_city

DROP TABLE IF EXISTS silver_city;

CREATE TABLE silver_city AS
SELECT DISTINCT
       city_id,
       INITCAP(TRIM(city_name)) AS city_name,
       state_id,
       country_id
FROM raw_city
WHERE city_id IS NOT NULL;


-- 5. silver_airports

DROP TABLE IF EXISTS silver_airports;

CREATE TABLE silver_airports AS
SELECT DISTINCT
       airport_id,
       INITCAP(TRIM(airport_name)) AS airport_name,
       city_id,
       UPPER(TRIM(iata_code)) AS iata_code,
       airport_type,
       timezone,
       latitude,
       longitude
FROM raw_airports
WHERE airport_id IS NOT NULL;


-- 6. silver_airlines

DROP TABLE IF EXISTS silver_airlines;

CREATE TABLE silver_airlines AS
SELECT DISTINCT *
FROM raw_airlines
WHERE airline_id IS NOT NULL;

-- 7. silver_aircrafts

DROP TABLE IF EXISTS silver_aircrafts;

CREATE TABLE silver_aircrafts AS
SELECT DISTINCT *
FROM raw_aircrafts
WHERE aircraft_id IS NOT NULL;

-- 8. silver_routes

DROP TABLE IF EXISTS silver_routes;

CREATE TABLE silver_routes AS
SELECT DISTINCT *
FROM raw_routes
WHERE route_id IS NOT NULL
  AND source_airport_id <> destination_airport_id
  AND distance_km > 0;


-- 9. silver_weather

DROP TABLE IF EXISTS silver_weather;

CREATE TABLE silver_weather AS
SELECT DISTINCT *
FROM raw_weather
WHERE weather_id IS NOT NULL
  AND temperature_c BETWEEN -20 AND 60
  AND humidity_pct BETWEEN 0 AND 100;

-- 10. silver_delay_reason

DROP TABLE IF EXISTS silver_delay_reason;

CREATE TABLE silver_delay_reason AS
SELECT DISTINCT *
FROM raw_delay_reason;

-- 11. silver_passengers

DROP TABLE IF EXISTS silver_passengers;

CREATE TABLE silver_passengers AS
SELECT DISTINCT
       passenger_id,
       full_name,
       INITCAP(gender) AS gender,
       age,
       nationality,
       loyalty_tier
FROM raw_passengers
WHERE passenger_id IS NOT NULL
  AND age BETWEEN 18 AND 100;

-- 12. silver_ticket_class

DROP TABLE IF EXISTS silver_ticket_class;

CREATE TABLE silver_ticket_class AS
SELECT DISTINCT *
FROM raw_ticket_class;

-- 13. silver_channel

DROP TABLE IF EXISTS silver_channel;

CREATE TABLE silver_channel AS
SELECT DISTINCT *
FROM raw_channel;

-- 14. silver_flights 

DROP TABLE IF EXISTS silver_flights;

CREATE TABLE silver_flights AS
SELECT *,
       EXTRACT(EPOCH FROM
              (arrival_datetime - departure_datetime))/60
              AS flight_duration_minutes,

       CASE
           WHEN is_cancelled = 1 THEN 'Cancelled'
           ELSE 'Completed'
       END AS flight_status
FROM raw_flights
WHERE flight_id IS NOT NULL
  AND revenue > 0
  AND fuel_cost > 0;

-- 15. silver_bookings 

DROP TABLE IF EXISTS silver_bookings;

CREATE TABLE silver_bookings AS
SELECT *,
       (fare_amount - discount_amount)
       AS net_fare
FROM raw_bookings
WHERE booking_id IS NOT NULL
  AND fare_amount > 0;


