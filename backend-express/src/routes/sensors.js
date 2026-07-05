const { Router } = require('express');
const { getLatestReading, getHistory } = require('../db');

const router = Router();

router.get('/latest', async (req, res) => {
  try {
    const reading = await getLatestReading(req.query.deviceId);
    if (!reading) return res.status(404).json({ error: 'No readings found' });
    res.json(reading);
  } catch (err) {
    console.error('Latest error:', err);
    res.status(500).json({ error: 'Failed to fetch latest reading' });
  }
});

router.get('/history', async (req, res) => {
  const limit = Math.min(parseInt(req.query.limit, 10) || 100, 500);
  try {
    const rows = await getHistory({ deviceId: req.query.deviceId, limit });
    res.json(rows);
  } catch (err) {
    console.error('History error:', err);
    res.status(500).json({ error: 'Failed to fetch history' });
  }
});

module.exports = router;
