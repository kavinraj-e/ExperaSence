const axios = require('axios');

exports.getAfterEffects = async (req, res) => {
  const { medicine, expiryDate } = req.body;

  if (new Date(expiryDate) > new Date()) {
    return res.json({ message: 'No issue / Not expired' });
  }

  try {
    const response = await axios.post(
      'https://generativelanguage.googleapis.com/v1/models/gemini:generateText',
      {
        prompt: `What are the after-effects of consuming expired ${medicine}?`,
      },
      { headers: { Authorization: `Bearer ${process.env.GEMINI_API_KEY}` } }
    );

    const afterEffects = response.data.candidates[0].text;
    res.json({ afterEffects });
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch after-effects' });
  }
};
