-- Create Dim And Fact Tables
-- ==========================================
-- DROP OLD VIEWS (DEPENDENCY SAFE)
-- ==========================================

DROP VIEW IF EXISTS dim_airport;
DROP VIEW IF EXISTS dim_city;
DROP VIEW IF EXISTS dim_state;
DROP VIEW IF EXISTS dim_country;
DROP VIEW IF EXISTS dim_region;


-- ==========================================
-- 1. DIM_REGION
-- ==========================================

CREATE VIEW dim_region AS
SELECT
    region_id AS region_key,
    region_name
FROM silver_region;


-- ==========================================
-- 2. DIM_COUNTRY
-- ==========================================

CREATE VIEW dim_country AS
SELECT
    country_id AS country_key,
    country_name,
    continent
FROM silver_country;


-- ==========================================
-- 3. DIM_STATE
-- ==========================================

CREATE VIEW dim_state AS
SELECT
    state_id AS state_key,
    state_name,
    region_id AS region_key,
    country_id AS country_key
FROM silver_state;


-- ==========================================
-- 4. DIM_CITY
-- ==========================================

CREATE VIEW dim_city AS
SELECT
    city_id AS city_key,
    city_name,
    state_id AS state_key,
    country_id AS country_key
FROM silver_city;


-- ==========================================
-- 5. DIM_AIRPORT
-- ==========================================

CREATE VIEW dim_airport AS
SELECT
    ROW_NUMBER() OVER(ORDER BY airport_id) AS airport_key,
    airport_id,
    airport_name,
    city_id AS city_key,
    iata_code,
    airport_type,
    timezone,
    latitude,
    longitude
FROM silver_airports;


-------------------------------------------------------------------------------

-- ==========================================
-- DROP VIEWS
-- ==========================================

DROP VIEW IF EXISTS dim_route;
DROP VIEW IF EXISTS dim_weather;
DROP VIEW IF EXISTS dim_delay_reason;
DROP VIEW IF EXISTS dim_aircraft;
DROP VIEW IF EXISTS dim_airline;

-- ==========================================
-- 1. DIM_AIRLINE
-- ==========================================

CREATE VIEW dim_airline AS
SELECT
    airline_id AS airline_key,
    airline_id,
    airline_name,
    airline_type,
    alliance,
    headquarters,
    country,
    established_year,
    status
FROM silver_airlines;


-- ==========================================
-- 2. DIM_AIRCRAFT
-- ==========================================

CREATE VIEW dim_aircraft AS
SELECT
    aircraft_id AS aircraft_key,
    aircraft_id,
    aircraft_model,
    manufacturer,
    seating_capacity,
    fuel_efficiency,
    aircraft_type,
    engine_type
FROM silver_aircrafts;


-- ==========================================
-- 3. DIM_DELAY_REASON
-- ==========================================

CREATE VIEW dim_delay_reason AS
SELECT
    delay_reason_id AS delay_reason_key,
    delay_reason_id,
    delay_reason,
    delay_category
FROM silver_delay_reason;


-- ==========================================
-- 4. DIM_WEATHER
-- ==========================================

CREATE VIEW dim_weather AS
SELECT
    weather_id AS weather_key,
    weather_type,
    temperature_c,
    visibility_km,
    wind_speed_kmh,
    humidity_pct,
    is_severe
FROM silver_weather;


-- ==========================================
-- 5. DIM_ROUTE
-- ==========================================

CREATE VIEW dim_route AS
SELECT
    r.route_id AS route_key,
    r.route_id,

    sa.airport_key AS source_airport_key,

    da.airport_key AS destination_airport_key,

    r.distance_km,

    r.route_type

FROM silver_routes r

JOIN dim_airport sa
    ON r.source_airport_id = sa.airport_id

JOIN dim_airport da
    ON r.destination_airport_id = da.airport_id;

-----------------------------------------------------------------


-- ==========================================
-- DROP VIEWS
-- ==========================================

DROP VIEW IF EXISTS dim_booking_date;
DROP VIEW IF EXISTS dim_time;
DROP VIEW IF EXISTS dim_date;
DROP VIEW IF EXISTS dim_channel;
DROP VIEW IF EXISTS dim_ticket_class;
DROP VIEW IF EXISTS dim_passenger;


-- ==========================================
-- 1. DIM_PASSENGER
-- ==========================================

CREATE VIEW dim_passenger AS
SELECT
    passenger_id AS passenger_key,
    passenger_id,

    age,

    CASE
        WHEN age < 18 THEN 'Under 18'
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 45 THEN '31-45'
        WHEN age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '60+'
    END AS age_group,

    gender,
    nationality,
    loyalty_tier

FROM silver_passengers;


-- ==========================================
-- 2. DIM_TICKET_CLASS
-- ==========================================

CREATE VIEW dim_ticket_class AS
SELECT
    class_id AS class_key,
    class_id,
    class_name,
    class_type
FROM silver_ticket_class;


-- ==========================================
-- 3. DIM_CHANNEL
-- ==========================================

CREATE VIEW dim_channel AS
SELECT
    channel_id AS channel_key,
    channel_id,
    channel_name,
    channel_type
FROM silver_channel;


-- ==========================================
-- 4. DIM_DATE
-- ==========================================

CREATE VIEW dim_date AS
SELECT DISTINCT

    CAST(
        TO_CHAR(departure_datetime,'YYYYMMDD')
        AS INTEGER
    ) AS date_key,

    DATE(departure_datetime) AS full_date,

    EXTRACT(DAY FROM departure_datetime) AS day,

    TO_CHAR(departure_datetime,'Day') AS day_name,

    EXTRACT(WEEK FROM departure_datetime) AS week,

    EXTRACT(MONTH FROM departure_datetime) AS month,

    TO_CHAR(departure_datetime,'Month') AS month_name,

    EXTRACT(QUARTER FROM departure_datetime) AS quarter,

    EXTRACT(YEAR FROM departure_datetime) AS year,

    CASE
        WHEN EXTRACT(ISODOW FROM departure_datetime) IN (6,7)
        THEN 'Y'
        ELSE 'N'
    END AS is_weekend,

    'N' AS is_holiday

FROM silver_flights;


-- ==========================================
-- 5. DIM_TIME
-- ==========================================

DROP VIEW IF EXISTS dim_time;

CREATE VIEW dim_time AS

SELECT DISTINCT

    EXTRACT(HOUR FROM departure_datetime)*10000
    +
    EXTRACT(MINUTE FROM departure_datetime)*100
    +
    EXTRACT(SECOND FROM departure_datetime)
    AS time_key,

    departure_datetime::time AS time,

    EXTRACT(HOUR FROM departure_datetime) AS hour,

    EXTRACT(MINUTE FROM departure_datetime) AS minute,

    CASE
        WHEN EXTRACT(HOUR FROM departure_datetime)
             BETWEEN 5 AND 11
        THEN 'Morning'

        WHEN EXTRACT(HOUR FROM departure_datetime)
             BETWEEN 12 AND 16
        THEN 'Afternoon'

        WHEN EXTRACT(HOUR FROM departure_datetime)
             BETWEEN 17 AND 21
        THEN 'Evening'

        ELSE 'Night'
    END AS time_period

FROM silver_flights;

-- ==========================================
-- 6. DIM_BOOKING_DATE
-- ==========================================

CREATE VIEW dim_booking_date AS
SELECT DISTINCT

    CAST(
        TO_CHAR(booking_datetime,'YYYYMMDD')
        AS INTEGER
    ) AS booking_date_key,

    DATE(booking_datetime) AS full_date,

    EXTRACT(DAY FROM booking_datetime) AS day,

    EXTRACT(MONTH FROM booking_datetime) AS month,

    EXTRACT(QUARTER FROM booking_datetime) AS quarter,

    EXTRACT(YEAR FROM booking_datetime) AS year,

    EXTRACT(WEEK FROM booking_datetime) AS week,

    CASE
        WHEN EXTRACT(ISODOW FROM booking_datetime)
             IN (6,7)
        THEN 'Y'
        ELSE 'N'
    END AS is_weekend

FROM silver_bookings;

------------------------------------------------------------------------------'

-- =====================================================
-- DROP FACT VIEWS
-- =====================================================

DROP VIEW IF EXISTS fact_booking;
DROP VIEW IF EXISTS fact_flight_operations;


-- =====================================================
-- FACT_FLIGHT_OPERATIONS
-- =====================================================

DROP VIEW IF EXISTS fact_flight_operations;

CREATE VIEW fact_flight_operations AS

SELECT

    ROW_NUMBER() OVER() AS flight_key,

    f.flight_id,

    f.airline_id AS airline_key,
    f.aircraft_id AS aircraft_key,
    f.route_id AS route_key,

    TO_CHAR(f.departure_datetime,'YYYYMMDD')::INT AS date_key,

    f.weather_id AS weather_key,
    f.delay_reason_id AS delay_reason_key,

    f.departure_datetime::TIME AS schedule_departure_time,
    f.departure_datetime::TIME AS actual_departure_time,

    f.arrival_datetime::TIME AS schedule_arrival_time,
    f.arrival_datetime::TIME AS actual_arrival_time,

    CASE
        WHEN f.is_cancelled = 1 THEN 0

        WHEN f.delay_reason_id = 2
            THEN FLOOR(RANDOM()*120)+60

        WHEN f.delay_reason_id IN (3,8)
            THEN FLOOR(RANDOM()*90)+30

        WHEN f.delay_reason_id IN (4,9)
            THEN FLOOR(RANDOM()*150)+45

        ELSE FLOOR(RANDOM()*60)+15
    END AS delay_minutes,

    r.distance_km,

    f.passenger_count,

    f.revenue,

    f.fuel_cost,

    ROUND((f.fuel_cost * 1.35)::numeric,2) AS operating_cost,

    f.occupancy_rate,

    f.is_cancelled

FROM silver_flights f

LEFT JOIN dim_route r
       ON f.route_id = r.route_id;


-- =====================================================
-- FACT_BOOKING
-- =====================================================

CREATE VIEW fact_booking AS

SELECT

    ROW_NUMBER() OVER(ORDER BY b.booking_id) AS booking_key,

    b.booking_id,

    ffo.flight_key,

    dp.passenger_key,

    dtc.class_key,

    dc.channel_key,

    dbd.booking_date_key,

    b.fare_amount,

    b.discount_amount,

    b.tax_amount,

    b.total_amount,

    b.booking_status

FROM silver_bookings b

JOIN fact_flight_operations ffo
    ON b.flight_id = ffo.flight_id

JOIN dim_passenger dp
    ON b.passenger_id = dp.passenger_id

JOIN dim_ticket_class dtc
    ON b.class_id = dtc.class_id

JOIN dim_channel dc
    ON b.channel_id = dc.channel_id

JOIN dim_booking_date dbd
    ON DATE(b.booking_datetime) = dbd.full_date;