# Questions for Anthony (KTFS)
## Information Needed Before Build Starts

**Prepared by:** Oliver Tatler
**Date:** 29 October 2025
**Project:** KTFS Mortgage Renewal Automation

---

## Critical Information Needed

### 1. FCA Authorization Number
**Question:** What is KTFS's FCA authorization number?

**Why we need it:** This must be included in SMS messages for regulatory compliance. All financial services communications must identify the authorized firm.

**Format example:** "KTFS is authorized and regulated by the Financial Conduct Authority (FCA number: 123456)"

---

### 2. Appointment Duration
**Question:** How long are mortgage renewal consultation appointments?

**Options:**
- [ ] 15 minutes
- [ ] 30 minutes
- [ ] 45 minutes
- [ ] 60 minutes
- [ ] Other: _______

**Why we need it:** This determines how we calculate available time slots when customers book via SMS.

---

### 3. Current Conversion Rate (Baseline)
**Question:** Of the ~1,000 mortgage holders currently in the system, how many typically renew through KTFS?

**Context:** This helps us measure success. If you currently get 10% renewal rate and we increase it to 20%, that's a clear win.

**Answer:** Currently about ___% renew through KTFS (or ___ out of 1,000)

---

### 4. Twilio Phone Number Preference
**Question:** What type of phone number do you want for sending SMS messages?

**Options:**
- [ ] UK Mobile number (e.g., +44 7XXX XXXXXX) - **Recommended**
- [ ] UK Landline/Long code (e.g., +44 20 XXXX XXXX) - May have delivery issues
- [ ] Short code (e.g., 5-6 digits) - Expensive but high deliverability

**Why we need it:** Mobile numbers work best for two-way SMS conversations. Will purchase through existing Twilio account.

**Preference:** _________________

---

### 5. Advisor Name Usage in SMS
**Question:** Should SMS messages include the specific advisor's name, or just say "KTFS team"?

**Option A (Personalized):**
> "Hi John, this is Sarah Williams from KTFS. Your mortgage expires in 24 weeks..."

**Option B (Generic):**
> "Hi John, this is the KTFS mortgage team. Your mortgage expires in 24 weeks..."

**Preference:** [ ] Option A (advisor names)  [ ] Option B (generic)

**Why it matters:** Personalization typically increases response rates, but requires advisor names to be stored correctly in Salesforce.

---

### 6. Complex Question Handling
**Question:** If a customer asks a complex question via SMS (e.g., "What rates can you offer?"), should the bot:

**Option A:** Reply with "Great question! [Advisor Name] can discuss rates in detail. Would you like to book a call?"

**Option B:** Reply with "I can help book a call, but for rate details please call [phone number]"

**Option C:** Send immediate notification to advisor to call customer within 2 hours

**Preference:** _________________

**Follow-up:** Should we notify the advisor when someone asks a complex question?
[ ] Yes, send notification   [ ] No, just log it in Salesforce

---

### 7. Working Hours for Appointments
**Question:** What are the standard working hours for mortgage consultations?

**Advisor availability:**
- Monday to Friday: _____ am to _____ pm
- Saturday: [ ] Available _____ to _____  [ ] Not available
- Sunday: [ ] Available _____ to _____  [ ] Not available

**Why we need it:** This determines which time slots we offer customers when they book via SMS.

---

### 8. Message Sending Time
**Question:** What time of day should we send the SMS reminders?

**Options:**
- [ ] 9:00 AM (early, catches people before work)
- [ ] 10:00 AM (mid-morning, less intrusive)
- [ ] 12:00 PM (lunch time)
- [ ] 2:00 PM (afternoon)

**Recommendation:** 10am is typically best for business SMS - not too early, not during lunch.

**Preference:** _________________

---

### 9. Escalation Call Timing
**Question:** When a lead hasn't responded by 3.5 months and a phone call task is created, how urgent is this?

**Priority level:**
- [ ] Call same day
- [ ] Call within 48 hours
- [ ] Call within 1 week

**Preference:** _________________

---

### 10. Salesforce Data Quality Check
**Question:** Are you confident that all 1,000 leads in Salesforce have:
- [ ] Valid mobile phone numbers?
- [ ] Accurate mortgage expiry dates?
- [ ] Assigned advisor?
- [ ] Customer's first name (for personalization)?

**Action needed:** If you're not 100% sure, we should do a data quality audit before launching. I can help with this.

**Status:** [ ] Data is clean  [ ] Need to audit first

---

### 11. SMS Opt-Out Process
**Question:** If someone replies STOP (opts out of SMS), should we:

**Option A:** Remove them completely from the campaign, no further contact

**Option B:** Mark them as "SMS opt-out" but advisor should call them instead

**Option C:** Other: _________________

**Preference:** _________________

---

### 12. Success Metrics & Reporting
**Question:** How often would you like progress reports?

**Options:**
- [ ] Daily summary (total sent, responses, bookings)
- [ ] Weekly digest
- [ ] Monthly only
- [ ] Real-time dashboard access

**Preference:** _________________

**Reporting format:**
- [ ] Email report
- [ ] Salesforce dashboard
- [ ] Google Sheets (live updating)

**Preference:** _________________

---

### 13. Budget Confirmation
**Question:** Confirming budget expectations for the project:

**Setup (one-time):** £1,000
- Includes: Salesforce integration, n8n workflow build, Twilio setup, Reapit calendar integration, testing

**Monthly ongoing:** £500
- Includes: Active monitoring, performance reporting, ongoing optimizations, priority support

**Additional costs (pass-through):**
- Twilio SMS: ~£120/month (£0.04 per SMS × ~3,000 messages)
- Reapit API: (if applicable - confirm with your Reapit contract)

**Total Year 1:** £1,000 + (£500 × 12) + (£120 × 12) = £8,440

**Is this aligned with your expectations?** [ ] Yes  [ ] Need to discuss

---

### 14. Go-Live Date
**Question:** You mentioned launching this week/next week. Confirming timeline:

**This week (by 1st Nov):**
- [ ] KTFS to clean Salesforce data
- [ ] KTFS to provide API access and FCA number

**Next week (4th-8th Nov):**
- [ ] Oliver builds workflows (Mon-Fri)
- [ ] Testing with 10-20 sample leads (Fri)
- [ ] Pilot launch with 100 leads (following Mon)

**Full launch (11th Nov+):**
- [ ] All 1,000 leads in campaign

**Does this timeline work?** [ ] Yes  [ ] Need different dates

---

### 15. Pilot Program
**Question:** Would you like to test with a small group first?

**Recommendation:** Send to 50-100 leads first, monitor for 48 hours, then scale to full 1,000.

**Benefits:**
- Catch any issues before they affect everyone
- Test message effectiveness
- Ensure advisor capacity can handle response volume

**Preference:** [ ] Yes, pilot with 100 leads  [ ] No, go straight to 1,000

---

## Technical Access Checklist

Please confirm you can provide the following by Monday:

- [ ] **Salesforce:**
  - Connected App Client ID and Secret (for OAuth)
  - Or: Admin credentials for Oliver to create Connected App
  - Custom object/field names where mortgage expiry data is stored

- [ ] **Reapit:**
  - API Client ID and Secret
  - Customer ID
  - Confirm API endpoints available (appointments, contacts)

- [ ] **Twilio:**
  - Account SID and Auth Token (from existing account)
  - Confirm budget for new phone number purchase

- [ ] **Branding:**
  - KTFS logo (if needed for any confirmation emails)
  - Preferred signature/sign-off for SMS messages

---

## Next Steps

Once you answer these questions:

1. **Oliver will:**
   - Finalize SMS message templates
   - Create detailed workflow diagrams
   - Begin n8n workflow development
   - Set up test environment

2. **We'll schedule:**
   - Kickoff call (30 mins) - confirm all details
   - Mid-week check-in - review progress
   - Pre-launch review - test the system together
   - Launch day monitoring - be available for any issues

---

## Contact

**Oliver Tatler**
📧 oliver@coldlava.ai
📱 +44 151 541 6933

**Preferred response method:**
- Email answers to all questions above, OR
- Quick call to discuss (15-20 minutes)

**Response needed by:** Monday 4th November (to hit your timeline)

---

**Document Version:** 1.0
**Last Updated:** 29 October 2025
