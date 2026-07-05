const { Router } = require('express');
const { insertReading } = require('../db');

const router = Router();

router.post('/ingest', async (req, res) => {
  const { deviceId, voltage, temperature, humidity, relayOn } = req.body;

  if (!deviceId || voltage === undefined) {
    return res.status(400).json({ error: 'deviceId and voltage are required' });
  }

  try {
    const row = await insertReading({
      deviceId,
      voltage: Number(voltage),
      temperature: temperature !== undefined ? Number(temperature) : null,
      humidity: humidity !== undefined ? Number(humidity) : null,
      relayOn: Boolean(relayOn),
    });
    res.status(201).json(row);
  } catch (err) {
    console.error('Ingest error:', err);
    res.status(500).json({ error: 'Failed to store reading' });
  }
});

module.exports = router;
