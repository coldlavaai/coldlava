#!/bin/bash

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║     COMPREHENSIVE SOPHIE AI DIAGNOSTIC TEST                   ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo

# Test 1: Check production deployment
echo "📦 TEST 1: Latest Production Deployment"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
latest=$(vercel ls --prod 2>&1 | grep "Ready" | head -1 | awk '{print $3}')
echo "Latest Ready: $latest"
echo "Age: $(vercel ls --prod 2>&1 | grep "Ready" | head -1 | awk '{print $1}')"
echo

# Test 2: Environment Variables
echo "🔐 TEST 2: Required Environment Variables (Production)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
for var in ANTHROPIC_API_KEY SANITY_API_READ_TOKEN NEXT_PUBLIC_SANITY_PROJECT_ID NEXT_PUBLIC_SANITY_DATASET; do
  if grep -q "^$var=" .env.production.local 2>/dev/null; then
    length=$(grep "^$var=" .env.production.local | cut -d= -f2- | wc -c | tr -d ' ')
    echo "✅ $var: SET ($length chars)"
  else
    echo "❌ $var: MISSING"
  fi
done
echo

# Test 3: Git Status
echo "📝 TEST 3: Git Commit Status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Latest commit: $(git log --oneline -1)"
echo "Working tree: $(git status --short | wc -l | tr -d ' ') uncommitted changes"
echo

# Test 4: Code Verification
echo "🔍 TEST 4: Critical Code Checks"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check Sanity client has token
if grep -q "token: process.env.SANITY_API_READ_TOKEN" app/api/ai-query/route.ts; then
  echo "✅ Sanity client has token configured"
else
  echo "❌ Sanity client MISSING token"
fi

# Check Sophie branding
if grep -q "Ask Sophie" components/SearchAndExport.tsx; then
  echo "✅ 'Ask Sophie' button found in UI"
else
  echo "❌ 'Ask Sophie' button NOT found"
fi

# Check system prompt
if grep -q "You are Sophie" app/api/ai-query/route.ts; then
  echo "✅ System prompt uses 'Sophie'"
else
  echo "❌ System prompt does NOT use 'Sophie'"
fi

echo
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║     DIAGNOSTIC COMPLETE                                       ║"
echo "╚══════════════════════════════════════════════════════════════╝"
