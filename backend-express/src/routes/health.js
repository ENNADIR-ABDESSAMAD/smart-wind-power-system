const { Router } = require('express');

const router = Router();

router.get('/', (_req, res) => {
  res.json({ status: 'ok', service: 'smart-wind-power-api' });
});

module.exports = router;
