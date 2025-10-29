# KTFS Mortgage Renewal Automation - Quick Summary
## One-Page Overview for Anthony

**From:** Oliver Tatler - Cold Lava
**Date:** 29 October 2025
**Project:** Automated SMS Mortgage Renewal System

---

## What We're Building

An automated system that sends timely SMS reminders to mortgage holders before their fixed-rate expires, allows them to book consultations via text message, and escalates non-responders to advisors for phone follow-up.

---

## How It Works

### Step 1: Automated SMS Reminders
- **6 months before expiry:** First friendly reminder
- **5 months before expiry:** Second reminder
- **4 months before expiry:** Final reminder
- All messages personalized with customer name and advisor name
- Sent automatically at 10am daily based on Salesforce data

### Step 2: Two-Way SMS Booking
- Customer replies "YES" or "BOOK"
- System responds with 3 available time slots
- Customer picks a slot (replies 1, 2, or 3)
- Appointment automatically created in Reapit calendar
- Confirmation sent to customer and advisor

### Step 3: Phone Call Escalation
- At **3.5 months** before expiry, if no response
- System creates high-priority task in Salesforce
- Assigned to the customer's advisor
- Advisor makes personal phone call

---

## What You Need to Provide

✅ **Salesforce Access** - API credentials or admin access for Oliver
✅ **Reapit Access** - API credentials to integrate with calendar
✅ **Twilio Access** - Credentials from your existing Twilio account
✅ **FCA Authorization Number** - For SMS message compliance
✅ **KTFS Phone Number** - Main contact number for SMS messages
✅ **Answers to Questions** - See separate questions document

---

## Timeline

**This Week (by Fri 1st Nov):**
- KTFS cleans Salesforce data
- KTFS provides API access and answers questions
- Oliver sets up development environment

**Next Week (4th-8th Nov):**
- **Monday-Thursday:** Oliver builds workflows
- **Friday:** Full testing with sample data
- **Decision:** Go/no-go for pilot launch

**Week of 11th Nov:**
- **Monday:** Pilot launch with 100 leads
- **Tuesday:** Review pilot results, adjust if needed
- **Wednesday:** Full launch to all 1,000 leads

---

## Investment

**Setup (one-time): £1,000**
- Complete system build
- Testing and documentation
- Launch support

**Monthly: £500**
- Active system monitoring and maintenance
- Monthly performance reports
- Ongoing optimizations and adjustments
- Priority support

**Running Costs: ~£120/month**
- Twilio SMS costs (£0.04 per message)
- ~3,000 messages per month

**Total Year 1: £8,440**

---

## Success Metrics

**Your Goals:**
- Reply from almost every customer (even if "no thanks")
- Zero mistakes or compliance issues
- Perfect execution over complexity

**Technical Goals:**
- >95% SMS delivery rate
- >10% booking rate
- Zero critical errors
- Advisor workload reduced (only speak to interested leads)

---

## Risk Mitigation

✅ **Pilot with 100 leads first** (test before full launch)
✅ **Manual review gates** (Oliver approves before scaling)
✅ **Error notifications** (immediate alerts if anything fails)
✅ **Data validation** (check phone numbers before sending)
✅ **FCA compliance review** (all messages reviewed for regulations)
✅ **Conservative approach** (simple and reliable over complex features)

---

## Why This Will Work

1. **Existing customers** - They know and trust KTFS
2. **Timely reminders** - Catches them before they go elsewhere
3. **Frictionless booking** - No need to call, can book via text
4. **Advisor-focused** - Escalation ensures no one slips through
5. **Automated logging** - Everything tracked in Salesforce
6. **Proven technology** - Oliver has built similar systems for solar leads

---

## Sample Message (for your approval)

**6-Month Reminder:**
> Hi John, this is Sarah Williams from KTFS. Your fixed-rate mortgage expires in 6 months. Let's discuss your renewal options. Reply YES to book a call. Reply STOP to opt out.

**When customer replies YES:**
> Great! I have availability on: 1) Tue 5th Nov at 2:00pm, 2) Wed 6th Nov at 10:00am, 3) Thu 7th Nov at 3:00pm. Reply with 1, 2, or 3 to confirm your appointment.

**Confirmation:**
> Perfect! Your appointment with Sarah Williams is confirmed for Tuesday 5th November at 2:00pm. You'll receive a reminder 24 hours before. Looking forward to speaking with you!

---

## What Happens Next

1. **You review this summary** and the detailed questions document
2. **We schedule a quick kickoff call** (30 mins on Monday 4th Nov)
3. **You provide API access** and answer questions
4. **Oliver builds the system** (Mon-Fri)
5. **We test together** (Friday afternoon)
6. **Pilot launch** (Monday 11th with 100 leads)
7. **Full launch** (Wednesday 13th with all 1,000 leads)

---

## Questions?

**Oliver Tatler**
📧 oliver@coldlava.ai
📱 +44 151 541 6933

**I'm available for a call anytime to discuss:**
- Technical details
- Compliance concerns
- Timeline adjustments
- Budget questions
- Anything else!

---

## Approval Checklist

Once you're happy with this plan:

- [ ] Approve SMS message templates (see separate document)
- [ ] Provide Salesforce API access
- [ ] Provide Reapit API access
- [ ] Provide Twilio credentials
- [ ] Confirm FCA authorization number
- [ ] Confirm KTFS main phone number
- [ ] Answer questions document
- [ ] Confirm budget (£1,000 setup + £500/month)
- [ ] Confirm timeline (launch week of 11th Nov)

**Send approvals and access details to:** oliver@coldlava.ai

---

## The Bottom Line

**Simple, reliable, automated mortgage renewal reminders that:**
- Free up advisor time (only call interested leads)
- Increase renewal rates (timely, personalized outreach)
- Perfect execution (piloted and tested before full launch)
- Family-friendly pricing (£1,000 setup)
- Launched in 2 weeks (ready for busy season)

**Let's help your customers stay on top of their mortgages and boost KTFS renewal rates!**

---

**Document Version:** 1.0
**Created:** 29 October 2025
