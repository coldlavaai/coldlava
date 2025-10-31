#!/bin/bash
#
# Template: Agent Test Suite
#
# INSTRUCTIONS:
# 1. Copy this file: cp test_suite_template.sh your_agent_test.sh
# 2. Update the agent credentials in your Python tester
# 3. Customize the test categories and questions below
# 4. Run: bash your_agent_test.sh
#

echo "╔════════════════════════════════════════════════════════════════════════════╗"
echo "║                    YOUR AGENT NAME - TEST SUITE                            ║"
echo "╚════════════════════════════════════════════════════════════════════════════╝"
echo ""

# Path to your configured tester (update this)
TESTER="python3 /path/to/your_agent_tester.py"

# Clear for fresh start
$TESTER --clear 2>&1 | grep -v "urllib3" | grep -v "warnings.warn"

# ══════════════════════════════════════════════════════════════════════════════
# CATEGORY 1: [YOUR CATEGORY NAME]
# ══════════════════════════════════════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "CATEGORY 1: [YOUR CATEGORY]"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

$TESTER "Your first test question?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn"
sleep 3

$TESTER "Your second test question?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn"
sleep 3

$TESTER "Your third test question?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn"
sleep 3

echo ""

# ══════════════════════════════════════════════════════════════════════════════
# CATEGORY 2: [YOUR CATEGORY NAME]
# ══════════════════════════════════════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "CATEGORY 2: [YOUR CATEGORY]"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Reset conversation for new category (optional)
$TESTER --reset 2>&1 | grep -v "urllib3" | grep -v "warnings.warn"

$TESTER "Category 2 question 1?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn"
sleep 3

$TESTER "Category 2 question 2?" 2>&1 | grep -v "urllib3" | grep -v "warnings.warn"
sleep 3

echo ""

# ══════════════════════════════════════════════════════════════════════════════
# Add more categories as needed...
# ══════════════════════════════════════════════════════════════════════════════

echo "╔════════════════════════════════════════════════════════════════════════════╗"
echo "║                         TEST SUITE COMPLETE                                 ║"
echo "╚════════════════════════════════════════════════════════════════════════════╝"
echo ""
echo "Total categories tested: X"
echo "Total questions asked: Y"
echo ""
echo "Review full conversation history:"
echo "$TESTER --history"
echo ""
