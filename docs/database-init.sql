-- Shared schema for Smart Wind Power System
-- Express creates this automatically on startup; use this script for manual setup.

CREATE DATABASE smart_wind_power;

\c smart_wind_power;

CREATE TABLE IF NOT EXISTS sensor_readings (
    id SERIAL PRIMARY KEY,
    device_id VARCHAR(64) NOT NULL,
    voltage DOUBLE PRECISION NOT NULL,
    temperature DOUBLE PRECISION,
    humidity DOUBLE PRECISION,
    relay_on BOOLEAN DEFAULT FALSE,
    recorded_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_sensor_readings_device_time
    ON sensor_readings (device_id, recorded_at DESC);
