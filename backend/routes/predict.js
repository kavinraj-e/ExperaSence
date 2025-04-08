const express = require('express');
const router = express.Router();
const predictController = require('../controllers/predictController');

router.post('/', predictController.predictSideEffects);
router.get('/get', predictController.getAllMedicines);

module.exports = router;
