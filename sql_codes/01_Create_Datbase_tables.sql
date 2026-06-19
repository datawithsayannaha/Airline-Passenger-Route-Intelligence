-- Create Datbase/tables
-- =====================================================
-- 1. raw_region
-- =====================================================
CREATE TABLE raw_region (
    region_id INT,
    region_name VARCHAR(100)
);

-- =====================================================
-- 2. raw_country
-- =====================================================
CREATE TABLE raw_country (
    country_id INT,
    country_name VARCHAR(100),
    continent VARCHAR(100)
);

-- =====================================================
-- 3. raw_state
-- =====================================================
CREATE TABLE raw_state (
    state_id INT,
    state_name VARCHAR(100),
    region_id INT,
    country_id INT
);

-- =====================================================
-- 4. raw_city
-- =====================================================
CREATE TABLE raw_city (
    city_id INT,
    city_name VARCHAR(100),
    state_id INT,
    country_id INT
);

-- =====================================================
-- 5. raw_airports
-- =====================================================
CREATE TABLE raw_airports (
    airport_id VARCHAR(20),
    airport_name VARCHAR(200),
    city_id INT,
    iata_code VARCHAR(10),
    airport_type VARCHAR(50),
    timezone VARCHAR(100),
    latitude NUMERIC(10,6),
    longitude NUMERIC(10,6)
);

-- =====================================================
-- 6. raw_airlines
-- =====================================================
CREATE TABLE raw_airlines (
    airline_id VARCHAR(20),
    airline_name VARCHAR(100),
    airline_type VARCHAR(50),
    alliance VARCHAR(100),
    headquarters VARCHAR(100),
    country VARCHAR(100),
    established_year INT,
    status VARCHAR(50)
);

-- =====================================================
-- 7. raw_aircrafts
-- =====================================================
CREATE TABLE raw_aircrafts (
    aircraft_id VARCHAR(20),
    aircraft_model VARCHAR(100),
    manufacturer VARCHAR(100),
    seating_capacity INT,
    fuel_efficiency NUMERIC(10,2),
    aircraft_type VARCHAR(100),
    engine_type VARCHAR(100)
);

-- =====================================================
-- 8. raw_routes
-- =====================================================
CREATE TABLE raw_routes (
    route_id VARCHAR(20),
    source_airport_id VARCHAR(20),
    destination_airport_id VARCHAR(20),
    distance_km INT,
    route_type VARCHAR(50)
);

-- =====================================================
-- 9. raw_weather
-- =====================================================
CREATE TABLE raw_weather (
    weather_id VARCHAR(20),
    airport_id VARCHAR(20),
    weather_date DATE,
    weather_type VARCHAR(50),
    temperature_c NUMERIC(5,2),
    visibility_km NUMERIC(5,2),
    wind_speed_kmh NUMERIC(5,2),
    humidity_pct INT,
    is_severe INT
);

-- =====================================================
-- 10. raw_delay_reason
-- =====================================================
CREATE TABLE raw_delay_reason (
    delay_reason_id INT,
    delay_reason VARCHAR(100),
    delay_category VARCHAR(100)
);

-- =====================================================
-- 11. raw_passengers
-- =====================================================
CREATE TABLE raw_passengers (
    passenger_id VARCHAR(20),
    full_name VARCHAR(200),
    gender VARCHAR(20),
    age INT,
    nationality VARCHAR(100),
    loyalty_tier VARCHAR(50)
);

-- =====================================================
-- 12. raw_ticket_class
-- =====================================================
CREATE TABLE raw_ticket_class (
    class_id INT,
    class_name VARCHAR(100),
    class_type VARCHAR(100)
);

-- =====================================================
-- 13. raw_channel
-- =====================================================
CREATE TABLE raw_channel (
    channel_id INT,
    channel_name VARCHAR(100),
    channel_type VARCHAR(100)
);

-- =====================================================
-- 14. raw_flights
-- =====================================================
CREATE TABLE raw_flights (
    flight_id VARCHAR(20),
    airline_id VARCHAR(20),
    aircraft_id VARCHAR(20),
    route_id VARCHAR(20),
    weather_id VARCHAR(20),
    delay_reason_id INT,
    departure_datetime TIMESTAMP,
    arrival_datetime TIMESTAMP,
    revenue NUMERIC(15,2),
    fuel_cost NUMERIC(15,2),
    passenger_count INT,
    occupancy_rate NUMERIC(5,2),
    is_cancelled INT
);

-- =====================================================
-- 15. raw_bookings
-- =====================================================
CREATE TABLE raw_bookings (
    booking_id VARCHAR(20),
    flight_id VARCHAR(20),
    passenger_id VARCHAR(20),
    class_id INT,
    channel_id INT,
    booking_datetime TIMESTAMP,
    fare_amount NUMERIC(15,2),
    discount_amount NUMERIC(15,2),
    tax_amount NUMERIC(15,2),
    total_amount NUMERIC(15,2),
    booking_status VARCHAR(50)
);