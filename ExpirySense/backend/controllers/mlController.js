const { exec } = require('child_process');
const { spawn } = require('child_process');

exports.processText = async (req, res) => {
  const { text, expiryDate } = req.body;

  // Identify medicine using Python
  exec(`python ml/medicine_classifier.py "${text}"`, (error, stdout, stderr) => {
    if (error) {
      console.error('Python Script Error:', error);
      console.error('stderr:', stderr);
      return res.status(500).json({ error: 'ML processing failed' });
    }

    console.log('Python Output:', stdout.trim());
    const medicineName = stdout.trim();
    const expiryStatus = new Date(expiryDate) < new Date() ? 'Expired' : 'Not Expired';

    if (expiryStatus === 'Expired') {
      // Predict spoilage risk using ML model
      const mlProcess = spawn('python', [
        'ml/predict_spoilage.py',
        medicineName,
        '25', // Example: Storage Temp
        '60', // Example: Humidity
        '180', // Expiry Days
      ]);
      

      mlProcess.stdout.on('data', (data) => {
        const risk = data.toString().trim();
        res.json({
          medicine: medicineName,
          status: expiryStatus,
          risk: risk,
        });
      });
    } else {
      res.json({
        medicine: medicineName,
        status: expiryStatus,
        risk: 'No issue / Not expired',
      });
    }
  });
};
