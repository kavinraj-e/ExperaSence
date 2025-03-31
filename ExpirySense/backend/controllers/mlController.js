// const { exec } = require('child_process');
// const { spawn } = require('child_process');

// exports.processText = async (req, res) => {
//   const { text, expiryDate } = req.body;

//   // Identify medicine using Python
//   exec(`python ml/medicine_classifier.py "${text}"`, (error, stdout, stderr) => {
//     if (error) {
//       console.error('Python Script Error:', error);
//       console.error('stderr:', stderr);
//       return res.status(500).json({ error: 'ML processing failed' });
//     }

//     console.log('Python Output:', stdout.trim());
//     const medicineName = stdout.trim();
//     const expiryStatus = new Date(expiryDate) < new Date() ? 'Expired' : 'Not Expired';

//     if (expiryStatus === 'Expired') {
//       // Predict spoilage risk using ML model
//       const mlProcess = spawn('python', [
//         'ml/predict_spoilage.py',
//         medicineName,
//         '25', // Example: Storage Temp
//         '60', // Example: Humidity
//         '180', // Expiry Days
//       ]);
      

//       mlProcess.stdout.on('data', (data) => {
//         const risk = data.toString().trim();
//         res.json({
//           medicine: medicineName,
//           status: expiryStatus,
//           risk: risk,
//         });
//       });
//     } else {
//       res.json({
//         medicine: medicineName,
//         status: expiryStatus,
//         risk: 'No issue / Not expired',
//       });
//     }
//   });
// };


const axios = require('axios');
const { exec } = require('child_process');
const { spawn } = require('child_process');


const GOOGLE_API_KEY = "AIzaSyC6oNJvLR_iMrIL6deTU4t_SlEwbT7gZEw";

exports.processText = async (req, res) => {
  const { text, expiryDate } = req.body;


  exec(`python ml/medicine_classifier.py "${text}"`, async (error, stdout, stderr) => {
    if (error) {
      console.error('Python Script Error:', error);
      console.error('stderr:', stderr);
      return res.status(500).json({ error: 'ML processing failed' });
    }

    console.log('Python Output:', stdout.trim());
    const medicineName = stdout.trim();
    const expiryStatus = new Date(expiryDate) < new Date() ? 'Expired' : 'Not Expired';

    if (medicineName === "Unknown") {
      return res.json({
        medicine: medicineName,
        status: expiryStatus,
        risk: 'Unable to classify medicine',
        sideEffects: 'N/A',
      });
    }

    let risk = 'No issue / Not expired';
    if (expiryStatus === 'Expired') {
      const mlProcess = spawn('python', [
        'ml/predict_spoilage.py',
        medicineName,
        '25', // Example: Storage Temp
        '60', // Example: Humidity
        '180', // Expiry Days
      ]);

      mlProcess.stdout.on('data', async (data) => {
        risk = data.toString().trim();

       
        try {
          const response = await axios.post(
            `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${GOOGLE_API_KEY}`,
            {
              contents: [
                {
                  parts: [
                    {
                      text: `side effects of ${medicineName} in one line?`
                    }
                  ]
                }
              ]
            }
          );

         
          const fullText =
            response?.data?.candidates?.[0]?.content?.parts?.[0]?.text ||
            'No side effects information available';

          
          const sideEffects = fullText.split('. ')[0].trim() + '.'; 

          res.json({
            medicine: medicineName,
            status: expiryStatus,
            risk: risk,
            sideEffects: sideEffects, 
          });
        } catch (error) {
          console.error(
            'Failed to fetch side effects:',
            error.response ? error.response.data : error.message
          );
          res.status(500).json({
            medicine: medicineName,
            status: expiryStatus,
            risk: risk,
            sideEffects: 'Failed to fetch side effects',
          });
        }
      });
    } else {

      try {
        const response = await axios.post(
          `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${GOOGLE_API_KEY}`,
          {
            contents: [
              {
                parts: [
                  {
                    text: `What are the common side effects of ${medicineName}?`
                  }
                ]
              }
            ]
          }
        );

        const fullText =
          response?.data?.candidates?.[0]?.content?.parts?.[0]?.text ||
          'No side effects information available';
        const sideEffects = fullText.split('. ')[0].trim() + '.'; 

        res.json({
          medicine: medicineName,
          status: expiryStatus,
          risk: risk,
          sideEffects: sideEffects, 
        });
      } catch (error) {
        console.error(
          'Failed to fetch side effects:',
          error.response ? error.response.data : error.message
        );
        res.status(500).json({
          medicine: medicineName,
          status: expiryStatus,
          risk: risk,
          sideEffects: 'Failed to fetch side effects',
        });
      }
    }
  });
};
