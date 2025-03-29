const express = require('express');
const bodyParser = require('body-parser');
const uploadRoutes = require('./routes/uploadRoutes');
const mlRoutes = require('./routes/mlRoutes');
require('dotenv').config();

const app = express();
app.use(bodyParser.json({ limit: '10mb' }));

app.use('/api', uploadRoutes);
app.use('/api', mlRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
