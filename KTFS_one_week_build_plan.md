# KTFS Mortgage Renewal System - 1 Week Build Plan
## Realistic Development Timeline

**Developer:** Oliver Tatler - Cold Lava
**Client:** KTFS (Karl Taylor Financial Services)
**Build Period:** Monday 4th Nov - Friday 8th Nov 2025
**Launch:** Monday 11th November 2025

---

## Project Scope Summary

**What we're building:**
- Automated SMS reminders at 6, 5, and 4 months before mortgage expiry
- Two-way SMS booking system (with fallback to booking link)
- Phone call escalation at 3.5 months if no response
- Reapit calendar integration for appointments
- Full Salesforce logging and tracking

**Core Principle:** Simple, reliable execution. Better to launch with 80% features working perfectly than 100% features with bugs.

---

## Pre-Build Requirements (This Week - By Fri 1st Nov)

### KTFS Actions:
- [ ] Clean Salesforce data (verify phone numbers, expiry dates, advisor assignments)
- [ ] Answer questions from questions document
- [ ] Provide API credentials (Salesforce, Reapit, Twilio)
- [ ] Provide FCA authorization number
- [ ] Approve SMS message templates

### Oliver Actions:
- [x] Research Reapit API capabilities
- [x] Document technical architecture
- [x] Create questions list for Anthony
- [ ] Draft SMS templates
- [ ] Set up n8n workspace
- [ ] Create test Salesforce sandbox (if needed)

---

## Day-by-Day Build Plan

### Monday 4th November - Foundation Day

**Morning (3 hours):**
- Set up n8n Cloud workspace
- Create Salesforce OAuth connection in n8n
- Test Salesforce query (fetch sample mortgage records)
- Create Reapit OAuth connection
- Test Reapit API (fetch sample appointments)
- Configure Twilio in n8n (existing account + new number)

**Afternoon (3 hours):**
- Create Salesforce custom fields if needed:
  - SMS_6_Month_Sent__c (DateTime)
  - SMS_5_Month_Sent__c (DateTime)
  - SMS_4_Month_Sent__c (DateTime)
  - SMS_Response__c (Picklist)
  - Conversation_State__c (Text)
  - Phone_Call_Task_Created__c (Checkbox)
  - Opt_Out__c (Checkbox)
- Build date calculation logic (JavaScript function)
- Test with sample data

**Deliverable:** All API connections working, custom fields created, date logic tested

---

### Tuesday 5th November - Outbound SMS System

**Morning (3 hours):**
- Build **Workflow 1: Daily Message Scheduler**
  - Schedule trigger: 10am daily
  - Query Salesforce for leads needing messages
  - Calculate days until expiry
  - Filter by message type (6mo, 5mo, 4mo)
  - Split into batches (prevent rate limiting)

**Afternoon (3 hours):**
- Add Twilio SMS sending node
- Add personalization (first name, advisor name, weeks until expiry)
- Add Salesforce logging (update SMS_X_Month_Sent__c)
- Add error handling and retry logic
- Test with 3 sample leads (6mo, 5mo, 4mo)

**Deliverable:** Outbound SMS system fully working, tested with real data

---

### Wednesday 6th November - Inbound SMS & Booking System

**Morning (4 hours):**
- Configure Twilio webhook in Twilio dashboard
- Build **Workflow 2: Inbound SMS Handler**
  - Webhook trigger for incoming SMS
  - Lookup customer in Salesforce by phone number
  - Parse message intent (YES, BOOK, STOP, complex question)
  - Route by intent (Switch node)

**Afternoon (4 hours):**
- Build **Booking Flow (Conversational)**:
  - Query Reapit for advisor's existing appointments
  - Calculate available slots (JavaScript function)
  - Format 3 options for SMS
  - Send options to customer
  - Update Salesforce conversation state
- Build **Time Selection Handler**:
  - Parse customer's slot selection (1, 2, 3)
  - Create appointment in Reapit
  - Send confirmation SMS
  - Update Salesforce (appointment ID, status = "Booked")

**Evening (1 hour):**
- Build **Opt-Out Handler**:
  - Update Salesforce Opt_Out__c = true
  - Send confirmation SMS
- Build **Complex Question Handler**:
  - Reply: "That's a great question! [Advisor] can discuss this. Would you like to book a call?"
  - Notify advisor via email/SMS

**Deliverable:** Full two-way SMS conversation working, bookings created in Reapit

---

### Thursday 7th November - Escalation & Polish

**Morning (3 hours):**
- Build **Workflow 3: Escalation Trigger**
  - Schedule trigger: 10am daily
  - Query Salesforce for 105-day leads with no response
  - Create high-priority Task in Salesforce
  - Assign to advisor
  - Update Phone_Call_Task_Created__c
  - Send advisor notification

**Afternoon (3 hours):**
- Build **Workflow 4: Reapit Webhook Receiver** (Optional - if time permits)
  - Receive appointment.cancelled events
  - Update Salesforce status
  - Notify customer via SMS
- Add comprehensive error handling to all workflows
- Add retry logic for failed API calls
- Create error notification workflow (email Oliver if critical failure)

**Deliverable:** Escalation system working, error handling robust

---

### Friday 8th November - Testing & Documentation

**Morning (3 hours):**
- **End-to-end testing:**
  - Test 1: Lead at 180 days → receives 6mo SMS
  - Test 2: Customer replies YES → receives time options
  - Test 3: Customer selects time → appointment created in Reapit
  - Test 4: Customer replies STOP → opted out
  - Test 5: Lead at 105 days with no response → task created
- Fix any bugs discovered
- Performance testing (send 50 SMS in batch)

**Afternoon (3 hours):**
- Create monitoring dashboard (n8n workflow that tracks metrics)
- Write user documentation for KTFS team
- Create troubleshooting guide
- Prepare demo for Anthony
- **Go/No-Go Decision:** Are we ready for pilot launch?

**Deliverable:** System fully tested, documented, ready for pilot

---

### Weekend 9th-10th November - Buffer Time

**Optional work if needed:**
- Fix any critical bugs found Friday
- Additional testing scenarios
- Prepare for Monday launch

**Or:** Rest and be ready to support launch on Monday

---

## Launch Week - Monday 11th November

### Pilot Launch (100 Leads)

**Morning:**
- Select 100 leads from Salesforce (mix of 6mo, 5mo, 4mo expiry dates)
- Mark them as pilot group (custom field)
- Run workflow manually for pilot batch
- Monitor real-time for any issues

**Throughout Day:**
- Monitor incoming SMS responses
- Check Salesforce logging
- Verify appointments being created in Reapit
- Track any errors or issues

**End of Day:**
- Review pilot metrics:
  - SMS delivery rate
  - Response rate
  - Bookings made
  - Opt-outs
  - Any errors

### Tuesday 12th November - Pilot Review

**Decisions:**
- Are message templates effective?
- Is booking flow working smoothly?
- Any technical issues?
- Ready to scale to full 1,000?

**Actions:**
- Adjust message wording if needed
- Fix any bugs discovered
- Optimize based on real data

### Wednesday 13th November - Full Launch

**Go-live:**
- Enable daily scheduler for all 1,000 leads
- Automated system now running
- Monitor closely for first 48 hours

---

## Simplified Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    DAILY SCHEDULER (10am)                    │
│                                                              │
│  1. Query Salesforce for mortgage expiry dates              │
│  2. Calculate days until expiry                              │
│  3. Filter: 180 days (6mo), 150 days (5mo), 120 days (4mo)  │
│  4. Send personalized SMS via Twilio                         │
│  5. Log to Salesforce (SMS sent timestamp)                   │
└─────────────────────────────────────────────────────────────┘
                            ↓
                   ┌────────────────┐
                   │  Customer gets │
                   │      SMS       │
                   └────────────────┘
                            ↓
                  Customer replies YES/BOOK
                            ↓
┌─────────────────────────────────────────────────────────────┐
│              INBOUND SMS HANDLER (Real-time webhook)         │
│                                                              │
│  1. Receive SMS from Twilio webhook                          │
│  2. Lookup customer in Salesforce by phone                   │
│  3. Parse intent (booking, opt-out, question)                │
│  4. If booking request:                                      │
│     a. Query Reapit for advisor's calendar                   │
│     b. Calculate 3 available slots                           │
│     c. Send options via SMS                                  │
│  5. Customer replies with slot selection (1, 2, or 3)        │
│  6. Create appointment in Reapit                             │
│  7. Update Salesforce (appointment booked)                   │
│  8. Send confirmation SMS                                    │
└─────────────────────────────────────────────────────────────┘
                            ↓
              ┌──────────────────────────┐
              │  Appointment created in  │
              │   Reapit advisor calendar│
              └──────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│           ESCALATION TRIGGER (Daily 10am check)              │
│                                                              │
│  1. Query Salesforce for 105-day leads with no response     │
│  2. Create high-priority Task in Salesforce                  │
│  3. Assign to advisor                                        │
│  4. Send notification to advisor                             │
└─────────────────────────────────────────────────────────────┘
```

---

## MVP Features (Must Have - Week 1)

✅ **Daily SMS reminders** (6mo, 5mo, 4mo)
✅ **Two-way SMS booking** (conversational flow)
✅ **Reapit appointment creation**
✅ **Salesforce logging** (all touchpoints tracked)
✅ **Opt-out handling** (STOP keyword)
✅ **Escalation at 3.5 months** (task creation for advisor)
✅ **Error handling** (retry failed API calls, notify on critical errors)

---

## Nice-to-Have Features (Post-Launch)

⏳ **Reapit webhook receiver** (sync appointment cancellations back to Salesforce)
⏳ **AI-powered question answering** (use OpenAI to answer simple questions)
⏳ **Booking link fallback** (if conversational booking fails, send Cal.com link)
⏳ **Reminder SMS 24hrs before appointment**
⏳ **Post-appointment follow-up SMS** ("How did your consultation go?")
⏳ **Performance dashboard** (real-time metrics for Anthony)

**Decision:** Launch with MVP first. Add nice-to-haves based on real usage.

---

## Risk Mitigation

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| **API credentials delayed** | Medium | High | Start with test/sandbox credentials, swap in production later |
| **Reapit API complexity** | Medium | Medium | Build booking link fallback first, add conversational flow if time permits |
| **Data quality issues in Salesforce** | High | Medium | Data audit Monday morning, clean before launch |
| **Twilio rate limiting** | Low | Medium | Add 1-second delay between SMS sends |
| **Timezone issues** | Low | Low | All dates in UTC, convert for display |
| **Missing advisor calendars in Reapit** | Medium | Medium | Fallback: Send generic booking link if calendar query fails |

---

## Success Criteria for Week 1

**Technical:**
- [ ] All 4 workflows deployed and tested
- [ ] Zero critical bugs in pilot
- [ ] <5% SMS delivery failure rate
- [ ] Appointments successfully created in Reapit

**Business:**
- [ ] Anthony approves SMS message templates
- [ ] KTFS team understands how to monitor system
- [ ] >10% response rate in pilot (10+ responses from 100 leads)
- [ ] At least 3 appointments booked in pilot

**Operational:**
- [ ] Clear escalation path if issues arise
- [ ] Oliver available for support during launch week
- [ ] Documentation complete for handover

---

## Daily Stand-Up Schedule (Optional)

**Quick 10-minute calls to stay aligned:**
- Monday 4th: 9am - Kickoff & API access check
- Wednesday 6th: 5pm - Progress review, demo inbound SMS
- Friday 8th: 4pm - Testing review, go/no-go decision
- Monday 11th: 9am - Launch day readiness check

**Format:** What's done, what's in progress, any blockers?

---

## Post-Launch Support

**Week 1 (11th-15th Nov):**
- Oliver monitors system daily
- Respond to any issues within 2 hours
- Daily summary report to Anthony

**Week 2-4:**
- Weekly check-in call
- Monthly summary report
- On-call for urgent issues

**Month 2+:**
- Monthly monitoring and optimization
- Quarterly feature additions (nice-to-haves)

---

## Budget Summary

**Setup (one-time): £1,000**
- 30-40 hours development time
- Testing and documentation
- Launch support

**Monthly ongoing: £500**
- Active system monitoring and maintenance
- Performance reporting and analytics
- Ongoing optimizations
- Priority support

**Running costs (pass-through):**
- Twilio SMS: ~£120/month
- n8n Cloud: £40/month (included in Oliver's subscription)

**Total Year 1: £1,000 + (£500 × 12) + (£120 × 12) = £8,440**

---

## What Could Go Wrong (And How We'll Handle It)

**Scenario 1: Reapit API doesn't work as expected**
- **Backup plan:** Use booking link (Cal.com or Calendly) instead
- **Timeline impact:** Minimal - can switch same day

**Scenario 2: SMS response volume overwhelms advisors**
- **Backup plan:** Pause outbound messages temporarily
- **Long-term fix:** Throttle daily send volume

**Scenario 3: Data in Salesforce is messy**
- **Backup plan:** Clean data before launch (Monday morning)
- **Prevention:** Run data quality check Friday

**Scenario 4: Customer asks question bot can't answer**
- **Backup plan:** Bot replies "Great question! Book a call to discuss"
- **Notification:** Alert advisor immediately

**Scenario 5: Oliver gets hit by a bus (hopefully not!)**
- **Backup plan:** All code documented in n8n (visual workflows)
- **Access:** Anthony gets admin access to n8n workspace
- **Support:** n8n has excellent documentation and community

---

## The "No Mistakes" Approach

**You said: "No faux pas, no mistakes. Basic and perfect is better than complicated with issues."**

**How we ensure this:**

1. **Start with pilot** (100 leads, not 1,000)
2. **Manual approval gates** (Oliver reviews before full launch)
3. **Comprehensive testing** (Friday full day dedicated to this)
4. **Error notifications** (Oliver alerted immediately if anything fails)
5. **Gradual rollout** (Pilot → 500 → 1,000 if needed)
6. **Conservative approach** (Use booking link if conversational flow is risky)
7. **Data validation** (Check phone numbers and expiry dates before sending)
8. **Compliance review** (All SMS templates reviewed for FCA compliance)

**Key principle:** If something feels rushed or risky, we don't launch. Family reputation is worth more than hitting a deadline.

---

## Next Steps

**By Friday 1st November:**
- [ ] Oliver sends SMS template drafts to you
- [ ] You send questions to Anthony
- [ ] Anthony provides API credentials and answers
- [ ] Oliver sets up n8n workspace

**Monday 4th November:**
- [ ] 9am kickoff call
- [ ] Begin build

**Friday 8th November:**
- [ ] 4pm review call
- [ ] Go/no-go decision for Monday launch

---

## Contact

**Oliver Tatler**
📧 oliver@coldlava.ai
📱 +44 151 541 6933

**Availability during build week:**
- Mon-Fri: 9am-6pm (focused work time)
- After hours: Available for urgent issues
- Weekend: On-call for critical bugs

---

**Let's build something reliable that makes your family proud!**

---

**Document Version:** 1.0
**Last Updated:** 29 October 2025
