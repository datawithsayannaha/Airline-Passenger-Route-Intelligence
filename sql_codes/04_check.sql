SELECT COUNT(*) FROM raw_region;
SELECT COUNT(*) FROM raw_country;
SELECT COUNT(*) FROM raw_state;
SELECT COUNT(*) FROM raw_city;
SELECT COUNT(*) FROM raw_airports;
SELECT COUNT(*) FROM raw_airlines;
SELECT COUNT(*) FROM raw_aircrafts;
SELECT COUNT(*) FROM raw_routes;
SELECT COUNT(*) FROM raw_weather;
SELECT COUNT(*) FROM raw_delay_reason;
SELECT COUNT(*) FROM raw_passengers;
SELECT COUNT(*) FROM raw_ticket_class;
SELECT COUNT(*) FROM raw_channel;
SELECT COUNT(*) FROM raw_flights;
SELECT COUNT(*) FROM raw_bookings;

SELECT *
FROM raw_airlines
WHERE airline_id IS NULL;

SELECT *
FROM raw_flights
WHERE route_id IS NULL;

SELECT airline_id, COUNT(*)
FROM raw_airlines
GROUP BY airline_id
HAVING COUNT(*) > 1;

SELECT flight_id, COUNT(*)
FROM raw_flights
GROUP BY flight_id
HAVING COUNT(*) > 1;

SELECT * FROM raw_airlines LIMIT 5;

SELECT * FROM raw_airports LIMIT 5;

SELECT * FROM raw_routes LIMIT 5;

SELECT * FROM raw_flights LIMIT 5;

SELECT * FROM raw_bookings LIMIT 5;


SELECT COUNT(*) FROM silver_airlines;
SELECT COUNT(*) FROM silver_airports;
SELECT COUNT(*) FROM silver_flights;
SELECT COUNT(*) FROM silver_bookings;

SELECT * FROM silver_flights LIMIT 5;
SELECT * FROM silver_bookings LIMIT 5;

SELECT * FROM dim_region LIMIT 5;

SELECT * FROM dim_country LIMIT 5;

SELECT * FROM dim_state ;

SELECT * FROM dim_city LIMIT 5;

SELECT * FROM dim_airport LIMIT 5;

SELECT COUNT(*)
FROM dim_airport a
LEFT JOIN dim_city c
ON a.city_key = c.city_key
WHERE c.city_key IS NULL;

SELECT COUNT(*)
FROM dim_city c
LEFT JOIN dim_state s
ON c.state_key = s.state_key
WHERE s.state_key IS NULL;

SELECT COUNT(*)
FROM dim_state s
LEFT JOIN dim_region r
ON s.region_key = r.region_key
WHERE r.region_key IS NULL;

SELECT *
FROM silver_country;

SELECT DISTINCT country_id
FROM silver_state;
SELECT
    country_id,
    COUNT(*) AS state_count
FROM silver_state
GROUP BY country_id
ORDER BY country_id;

SELECT COUNT(*)
FROM dim_route
WHERE source_airport_key IS NULL;

SELECT COUNT(*) FROM dim_airline;
SELECT COUNT(*) FROM dim_aircraft;
SELECT COUNT(*) FROM dim_route;
SELECT COUNT(*) FROM dim_weather;
SELECT COUNT(*) FROM dim_delay_reason;

SELECT * FROM dim_airline;
SELECT * FROM dim_aircraft;
SELECT * FROM dim_route;
SELECT * FROM dim_weather;
SELECT * FROM dim_delay_reason;

SELECT COUNT(DISTINCT weather_key)
FROM dim_weather;

SELECT COUNT(*)
FROM dim_route
WHERE source_airport_key = destination_airport_key;

SELECT COUNT(*)
FROM dim_airport;

SELECT COUNT(*)
FROM dim_route
WHERE source_airport_key IS NULL
OR destination_airport_key IS NULL;

SELECT COUNT(*) FROM dim_passenger;
SELECT COUNT(*) FROM dim_ticket_class;
SELECT COUNT(*) FROM dim_channel;
SELECT COUNT(*) FROM dim_date;
SELECT COUNT(*) FROM dim_time;
SELECT COUNT(*) FROM dim_booking_date;

SELECT * FROM dim_passenger;
SELECT * FROM dim_ticket_class;
SELECT * FROM dim_channel;
SELECT * FROM dim_date;
SELECT * FROM dim_time;
SELECT * FROM dim_booking_date;

SELECT
COUNT(*) total_rows,
COUNT(DISTINCT time_key) unique_keys
FROM dim_time;


SELECT column_name
FROM information_schema.columns
WHERE table_name = 'silver_flights'
ORDER BY ordinal_position;

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'silver_bookings'
ORDER BY ordinal_position;

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'silver_passengers'
ORDER BY ordinal_position;

SELECT COUNT(*) FROM fact_flight_operations;
SELECT COUNT(*) FROM fact_booking;

SELECT COUNT(*) FROM silver_flights;

SELECT COUNT(*) FROM silver_bookings;

SELECT COUNT(*)
FROM silver_flights f
LEFT JOIN dim_route dr
ON f.route_id = dr.route_id
WHERE dr.route_id IS NULL;

SELECT COUNT(*)
FROM silver_flights f
LEFT JOIN dim_airline da
ON f.airline_id = da.airline_id
WHERE da.airline_id IS NULL;

SELECT COUNT(*)
FROM silver_flights f
LEFT JOIN dim_aircraft dac
ON f.aircraft_id = dac.aircraft_id
WHERE dac.aircraft_id IS NULL;

SELECT COUNT(*)
FROM silver_flights f
LEFT JOIN dim_weather dw
ON f.weather_id = dw.weather_key
WHERE dw.weather_key IS NULL;

SELECT COUNT(*)
FROM silver_flights f
LEFT JOIN dim_delay_reason ddr
ON f.delay_reason_id = ddr.delay_reason_id
WHERE ddr.delay_reason_id IS NULL;

SELECT * FROM fact_flight_operations;
SELECT * FROM fact_booking;

SELECT
MIN(delay_minutes),
MAX(delay_minutes),
AVG(delay_minutes)
FROM fact_flight_operations;

SELECT DISTINCT flight_status
FROM silver_flights;

SELECT
flight_status,
COUNT(*)
FROM silver_flights
GROUP BY flight_status;

SELECT *
FROM dim_delay_reason;

SELECT
delay_reason_key,
delay_minutes
FROM fact_flight_operations
LIMIT 20;
