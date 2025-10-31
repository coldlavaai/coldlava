# Agent Testing Suite

Comprehensive testing tools for Cold Lava voice and chat agents built on VAPI.

## Overview

This testing suite allows you to:
- Test agents via text simulation (faster, cheaper than voice calls)
- Run comprehensive test suites with multiple categories
- Track conversation history and context
- Validate agent knowledge and responses
- Compare performance across iterations

## Tools

### vapi_agent_tester.py

Python CLI tool for testing VAPI agents via the chat API.

**Features:**
- Maintains conversation context across messages
- Color-coded output for readability
- Conversation history tracking
- Easy reset and clearing
- Quiet mode for scripting

**Usage:**
```bash
# Send a message
python3 vapi_agent_tester.py "Your message here"

# Reset conversation (keep history)
python3 vapi_agent_tester.py --reset

# View conversation history
python3 vapi_agent_tester.py --history

# Clear everything
python3 vapi_agent_tester.py --clear

# Run built-in test suite
python3 vapi_agent_tester.py --test
```

**Configuration:**
Edit the script to set your agent's credentials:
- `ASSISTANT_ID` - Your VAPI assistant ID
- `API_KEY` - Your VAPI API key

## Templates

### test_suite_template.sh

Template bash script for creating comprehensive test suites. Includes:
- Multiple test categories
- Proper spacing and rate limiting
- Clean output formatting
- Progress tracking

**Customise:**
1. Copy template to new file
2. Update assistant credentials in Python script
3. Replace test questions with your agent's scenarios
4. Run: `bash your_test.sh`

## Examples

### Sophie (Greenstar Solar)

Production example of complete agent testing:

**Files:**
- `examples/sophie_exhaustive_test.sh` - 40+ questions across 10 categories
- `examples/sophie_diagnostic_test.sh` - Deployment and environment validation

**Categories tested:**
1. Location & Coverage
2. Finance & Funding
3. Government Grants & Incentives
4. Technical Questions
5. Planning & Permissions
6. Installation Process
7. Warranties & Support
8. Property-Specific
9. Battery-Specific
10. Edge Cases & Tricky Questions

## Best Practices

### Creating Test Suites

1. **Cover all knowledge areas** - Test every topic your agent should handle
2. **Include edge cases** - Skepticism, objections, unusual scenarios
3. **Test context retention** - Multi-turn conversations
4. **Rate limit properly** - 3 second delays between messages
5. **Reset between categories** - Start fresh to avoid context bleed

### Interpreting Results

- **No response** - Check API credentials, rate limits
- **Generic answers** - Knowledge base may be incomplete
- **Context issues** - Check conversation ID tracking
- **Formatting problems** - Review system prompt instructions

### Before Production

- ✅ Run full exhaustive test suite
- ✅ Test at least 50+ realistic scenarios
- ✅ Validate all edge cases
- ✅ Check UK spelling/pronunciation (if applicable)
- ✅ Verify contact collection works
- ✅ Test objection handling

## Integration with Development

```bash
# Quick test after prompt changes
python3 vapi_agent_tester.py "Test your critical scenario"

# Full regression test
bash your_exhaustive_test.sh > test_results.txt

# Compare before/after
diff old_results.txt new_results.txt
```

## Troubleshooting

**"No response"**
- Check VAPI API key is valid
- Verify assistant ID is correct
- Check rate limits (max 60 req/min)

**"Conversation not continuing"**
- Delete `/tmp/vapi_chat_id.txt`
- Use `--reset` flag

**"Import errors"**
- Install: `pip3 install requests`

---

*For questions: oliver@otdm.net*
