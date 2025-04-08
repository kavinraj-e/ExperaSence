const mongoose = require('mongoose');

const MedicineSchema = new mongoose.Schema({
    userId: { type: String, required: true },
    name: { type: String, required: true },
    ingredients: { type: [String], required: true },
    expiryDate: { type: Date, required: true },
    status: { type: String, required: true },
    sideEffects: { type: [String] }
});

module.exports = mongoose.model('Medicine', MedicineSchema);
