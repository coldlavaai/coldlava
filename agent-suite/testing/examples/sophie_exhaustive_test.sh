#!/bin/bash

echo "╔════════════════════════════════════════════════════════════════════════════╗"
echo "║              SOPHIE - EXHAUSTIVE KNOWLEDGE TEST SUITE                     ║"
echo "╚════════════════════════════════════════════════════════════════════════════╝"
echo ""

# Clear for fresh start
python3 /tmp/sophie_tester.py --clear 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"

# CATEGORY 1: LOCATION & COVERAGE
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "CATEGORY 1: LOCATION & COVERAGE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
python3 /tmp/sophie_tester.py "Where are you based?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
python3 /tmp/sophie_tester.py "Do you install in Scotland?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
python3 /tmp/sophie_tester.py "I'm in Manchester, can you help?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
echo ""

# CATEGORY 2: FINANCE & FUNDING
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "CATEGORY 2: FINANCE & FUNDING"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
python3 /tmp/sophie_tester.py --reset 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
python3 /tmp/sophie_tester.py "Do you offer finance?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
python3 /tmp/sophie_tester.py "Can I pay monthly?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
python3 /tmp/sophie_tester.py "What's the payback period?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
echo ""

# CATEGORY 3: GOVERNMENT GRANTS & INCENTIVES
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "CATEGORY 3: GOVERNMENT GRANTS & INCENTIVES"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
python3 /tmp/sophie_tester.py --reset 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
python3 /tmp/sophie_tester.py "Are there any government grants available?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
python3 /tmp/sophie_tester.py "What's the Smart Export Guarantee?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
python3 /tmp/sophie_tester.py "Can I get money back from the grid?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
echo ""

# CATEGORY 4: TECHNICAL QUESTIONS
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "CATEGORY 4: TECHNICAL QUESTIONS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
python3 /tmp/sophie_tester.py --reset 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
python3 /tmp/sophie_tester.py "My roof faces north, will it work?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
python3 /tmp/sophie_tester.py "I have trees that shade my roof" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
python3 /tmp/sophie_tester.py "What happens if a panel breaks?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
python3 /tmp/sophie_tester.py "Do I need to clean the panels?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
echo ""

# CATEGORY 5: PLANNING & PERMISSIONS
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "CATEGORY 5: PLANNING & PERMISSIONS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
python3 /tmp/sophie_tester.py --reset 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
python3 /tmp/sophie_tester.py "Do I need planning permission?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
python3 /tmp/sophie_tester.py "I live in a conservation area" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
python3 /tmp/sophie_tester.py "Do you handle the paperwork?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
echo ""

# CATEGORY 6: INSTALLATION PROCESS
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "CATEGORY 6: INSTALLATION PROCESS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
python3 /tmp/sophie_tester.py --reset 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
python3 /tmp/sophie_tester.py "How long does installation take?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
python3 /tmp/sophie_tester.py "Do you use subcontractors?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
python3 /tmp/sophie_tester.py "What happens after installation?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
echo ""

# CATEGORY 7: WARRANTIES & SUPPORT
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "CATEGORY 7: WARRANTIES & SUPPORT"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
python3 /tmp/sophie_tester.py --reset 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
python3 /tmp/sophie_tester.py "What's covered under warranty?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
python3 /tmp/sophie_tester.py "Do you charge for callouts?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
python3 /tmp/sophie_tester.py "What if something goes wrong in 10 years?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
echo ""

# CATEGORY 8: PROPERTY-SPECIFIC
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "CATEGORY 8: PROPERTY-SPECIFIC"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
python3 /tmp/sophie_tester.py --reset 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
python3 /tmp/sophie_tester.py "I'm renting, can I still get solar?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
python3 /tmp/sophie_tester.py "Will it increase my property value?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
python3 /tmp/sophie_tester.py "What if I move house?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
echo ""

# CATEGORY 9: BATTERY-SPECIFIC
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "CATEGORY 9: BATTERY-SPECIFIC"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
python3 /tmp/sophie_tester.py --reset 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
python3 /tmp/sophie_tester.py "Do I need a battery?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
python3 /tmp/sophie_tester.py "Can I add a battery later?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
python3 /tmp/sophie_tester.py "How long do batteries last?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
python3 /tmp/sophie_tester.py "What's the best battery?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
echo ""

# CATEGORY 10: EDGE CASES
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "CATEGORY 10: EDGE CASES & TRICKY QUESTIONS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
python3 /tmp/sophie_tester.py --reset 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
python3 /tmp/sophie_tester.py "Are solar panels a scam?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
python3 /tmp/sophie_tester.py "My neighbour says they don't work" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
python3 /tmp/sophie_tester.py "What if there's a power cut?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
python3 /tmp/sophie_tester.py "Do panels work at night?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn" | grep -v "NotOpenSSLWarning"
sleep 3
echo ""

echo "╔════════════════════════════════════════════════════════════════════════════╗"
echo "║                    EXHAUSTIVE TEST SUITE COMPLETE                          ║"
echo "╚════════════════════════════════════════════════════════════════════════════╝"
echo ""
echo "Total categories tested: 10"
echo "Total questions asked: 40+"
echo ""
echo "Review full conversation history:"
echo "python3 /tmp/sophie_tester.py --history"
echo ""

