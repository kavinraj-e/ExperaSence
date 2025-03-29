const cloudinary = require('../config/cloudinaryConfig');
const Product = require('../models/productModel');
const axios = require('axios');

exports.uploadImage = async (req, res) => {
  try {
    const fileStr = req.body.image;
    const uploadedResponse = await cloudinary.uploader.upload(fileStr, {
      folder: 'expiry_sense',
    });

    // Save the URL in the database
    const newProduct = new Product({
      cloudinaryUrl: uploadedResponse.secure_url,
    });

    await newProduct.save();

    res.json({
      success: true,
      url: uploadedResponse.secure_url,
    });
  } catch (error) {
    res.status(500).json({ error: 'Failed to upload image' });
  }
};
