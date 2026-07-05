const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

async function initDb() {
  await pool.query(`
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
  `);
  console.log('Database schema ready');
}

async function insertReading({ deviceId, voltage, temperature, humidity, relayOn }) {
  const result = await pool.query(
    `INSERT INTO sensor_readings (device_id, voltage, temperature, humidity, relay_on)
     VALUES ($1, $2, $3, $4, $5)
     RETURNING *`,
    [deviceId, voltage, temperature ?? null, humidity ?? null, relayOn ?? false]
  );
  return result.rows[0];
}

async function getLatestReading(deviceId) {
  const result = await pool.query(
    `SELECT * FROM sensor_readings
     WHERE ($1::text IS NULL OR device_id = $1)
     ORDER BY recorded_at DESC
     LIMIT 1`,
    [deviceId || null]
  );
  return result.rows[0] || null;
}

async function getHistory({ deviceId, limit = 100 }) {
  const result = await pool.query(
    `SELECT * FROM sensor_readings
     WHERE ($1::text IS NULL OR device_id = $1)
     ORDER BY recorded_at DESC
     LIMIT $2`,
    [deviceId || null, limit]
  );
  return result.rows;
}

module.exports = { pool, initDb, insertReading, getLatestReading, getHistory };
