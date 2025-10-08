// Serverless function to proxy Retell API requests
// This handles authentication so your API key stays secret

export default async function handler(req, res) {
  // Enable CORS
  res.setHeader('Access-Control-Allow-Credentials', true);
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET,POST,OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  const RETELL_API_KEY = process.env.RETELL_API_KEY; // Set this in your deployment environment
  const AGENT_ID = 'agent_81da82d9b3ff61a0d0918ae0f2';

  if (req.method === 'POST') {
    const { action, message, chatId } = req.body;

    try {
      if (action === 'create') {
        // Create a new chat session
        const response = await fetch('https://api.retellai.com/create-chat', {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${RETELL_API_KEY}`,
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            agent_id: AGENT_ID
          })
        });

        const data = await response.json();
        res.status(200).json(data);
      }
      else if (action === 'message') {
        // Send a message to existing chat
        const response = await fetch(`https://api.retellai.com/chat/${chatId}/message`, {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${RETELL_API_KEY}`,
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            message: message
          })
        });

        const data = await response.json();
        res.status(200).json(data);
      }
      else {
        res.status(400).json({ error: 'Invalid action' });
      }
    } catch (error) {
      console.error('Retell API error:', error);
      res.status(500).json({ error: 'Failed to communicate with Retell' });
    }
  } else {
    res.status(405).json({ error: 'Method not allowed' });
  }
}
