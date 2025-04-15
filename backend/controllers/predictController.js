const Medicine = require('../models/medicine');
const axios = require('axios');

exports.predictSideEffects = async (req, res) => {
    try {
        const { userId, name, ingredients, expiryDate } = req.body;
        const expiry = new Date(expiryDate);
        const today = new Date();
        const composition = ingredients.join("+");
        let status, sideEffects = [];
        console.log("ingredients", ingredients);
        if (expiry < today) {
            // Call the Flask API for expired medicines
            const response = await axios.post(process.env.FLASK_API, { composition });
            sideEffects = response.data.sideEffects;
            status = "expired";
        } else {
            status = "not expired";
        }
        const med = new Medicine({
            userId,
            name,
            ingredients,
            expiryDate: expiry,
            status,
            sideEffects
        });
        await med.save();
        console.log("Medicine saved successfully");
        console.log("Medicine data:", med);
        res.json({ status, sideEffects });

    } catch (err) {
        console.error(err);
        res.status(500).json({ message: "Server error" });
    }
};




// Get all medicine data
exports.getAllMedicines = async (req, res) => {
    try {
        const medicines = await Medicine.find();
        res.json(medicines);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: "Server error" });
    }
};