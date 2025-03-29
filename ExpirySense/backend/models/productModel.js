const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
  name: String,
  expiryDate: Date,
  cloudinaryUrl: String,
  status: String,
  afterEffects: String,
});

module.exports = mongoose.model('Product', productSchema);
