require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { initDb } = require('./db');
const healthRoutes = require('./routes/health');
const iotRoutes = require('./routes/iot');
const sensorRoutes = require('./routes/sensors');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors({ origin: process.env.CORS_ORIGIN || '*' }));
app.use(express.json());

app.use('/api/health', healthRoutes);
app.use('/api/iot', iotRoutes);
app.use('/api/sensors', sensorRoutes);

async function start() {
  await initDb();
  app.listen(PORT, () => {
    console.log(`Smart Wind Power API listening on http://localhost:${PORT}`);
  });
}

start().catch((err) => {
  console.error('Failed to start server:', err);
  process.exit(1);
});
