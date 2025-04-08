const express = require('express');
const mongoose = require('./config/db');
const predictRoutes = require('./routes/predict');
const cors = require('cors');
const authRoutes = require('./routes/auth');
const dotenv = require('dotenv');
dotenv.config();


const app = express();
app.use(express.json());
app.use(cors());

// Routes
app.use('/api/predict', predictRoutes);
app.use('/api/auth', authRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
