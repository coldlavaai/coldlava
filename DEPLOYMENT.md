# Cold Lava Chat Widget - Deployment Guide

## Overview
This is a completely custom chat widget with Cold Lava branding that uses Retell AI's backend through a secure proxy.

## Architecture
- **Frontend**: 100% custom UI (no Retell widget)
- **Backend**: Serverless function that proxies Retell API calls
- **No Retell UI**: Zero visual elements from Retell, pure Cold Lava design

## Deployment Steps

### 1. Deploy to Vercel (Recommended)

1. Install Vercel CLI:
   ```bash
   npm i -g vercel
   ```

2. Login to Vercel:
   ```bash
   vercel login
   ```

3. Deploy from the `/Users/oliver/home` directory:
   ```bash
   cd /Users/oliver/home
   vercel
   ```

4. Set environment variable:
   - Go to your Vercel project dashboard
   - Settings → Environment Variables
   - Add: `RETELL_API_KEY` = your Retell API key

5. Redeploy:
   ```bash
   vercel --prod
   ```

### 2. Get Your Retell API Key

1. Go to https://dashboard.retellai.com
2. Navigate to API Keys section
3. Copy your API key (NOT the public key)
4. Add it to Vercel environment variables

### 3. Update API Endpoint (if needed)

If deploying to a different platform or custom domain, update line in `index.html`:
```javascript
const API_ENDPOINT = '/api/chat'; // Change this to your backend URL
```

## Files Created

- `api/chat.js` - Backend proxy for Retell API
- `vercel.json` - Vercel configuration
- `.env.example` - Environment variable template
- Updated `index.html` - Custom widget frontend

## Testing Locally

1. Install Vercel CLI
2. Create `.env` file with your `RETELL_API_KEY`
3. Run: `vercel dev`
4. Open: http://localhost:3000

## Features

✅ 100% Custom Cold Lava branding
✅ No Retell UI elements
✅ Secure API key (server-side only)
✅ Dark blue gradient button
✅ Beautiful glassmorphic chat panel
✅ "Powered by Cold Lava" footer
✅ Mobile responsive

## Troubleshooting

**Chat not connecting?**
- Check API_ENDPOINT is correct
- Verify RETELL_API_KEY is set in Vercel
- Check browser console for errors

**Button not showing?**
- Clear browser cache
- Check CSS isn't being overridden

Need help? Check Vercel logs or Retell dashboard for errors.
