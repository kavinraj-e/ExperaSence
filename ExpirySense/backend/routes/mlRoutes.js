const express = require('express');
const router = express.Router();
const { processText } = require('../controllers/mlController');
const { getAfterEffects } = require('../controllers/geminiController');

router.post('/process', processText);
router.post('/after-effects', getAfterEffects);

module.exports = router;
