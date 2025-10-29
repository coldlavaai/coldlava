# KTFS Mortgage Renewal System - Visual Workflow
## Complete System Architecture & User Flows

---

## 🏗️ System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     KTFS MORTGAGE RENEWAL SYSTEM                         │
│                    Automated SMS & Booking Platform                      │
└─────────────────────────────────────────────────────────────────────────┘

                            ┌──────────────┐
                            │  Salesforce  │
                            │     CRM      │
                            │              │
                            │ • 1,000 leads│
                            │ • Expiry data│
                            │ • Advisor IDs│
                            └──────┬───────┘
                                   │
                                   │ Daily Query (10am)
                                   │ Read: Leads, Dates, Contacts
                                   ↓
                    ┌──────────────────────────────┐
                    │          n8n Platform        │
                    │    (Automation Engine)       │
                    │                              │
                    │  • Date calculations         │
                    │  • Message scheduling        │
                    │  • Booking logic             │
                    │  • Escalation triggers       │
                    └──────────────────────────────┘
                            ↓           ↓
                    ┌───────┴───┐   ┌──┴────────┐
                    │  Twilio   │   │  Reapit   │
                    │    SMS    │   │ Calendar  │
                    │           │   │           │
                    │ • Send    │   │ • Create  │
                    │ • Receive │   │   appts   │
                    └─────┬─────┘   └─────┬─────┘
                          │               │
                          ↓               ↓
                    ┌──────────────────────────┐
                    │   Mortgage Holders       │
                    │   (1,000 customers)      │
                    └──────────────────────────┘
```

---

## 📅 Daily Scheduler Workflow

**Runs every day at 10:00 AM**

```
START (10:00 AM Daily)
    ↓
┌─────────────────────────────────────┐
│ 1. Query Salesforce                 │
│    Get all mortgage records         │
│    WHERE Opt_Out = FALSE            │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│ 2. Calculate Days Until Expiry      │
│    For each record:                 │
│    daysLeft = expiryDate - today    │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│ 3. Filter by Timeframe              │
│    180 days → 6-month message       │
│    150 days → 5-month message       │
│    120 days → 4-month message       │
│    105 days → Phone escalation      │
└─────────────────────────────────────┘
    ↓
         ┌──────────┬──────────┬──────────┐
         ↓          ↓          ↓          ↓
   ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐
   │ 6-month │ │ 5-month │ │ 4-month │ │  3.5mo  │
   │ message │ │ message │ │ message │ │escalate │
   └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘
        │           │           │           │
        └───────────┴───────────┴───────────┘
                     ↓
         ┌────────────────────────┐
         │ 4. Send SMS via Twilio │
         │    Personalized with:  │
         │    - Customer name     │
         │    - Advisor name      │
         │    - Weeks until expiry│
         └────────────────────────┘
                     ↓
         ┌────────────────────────┐
         │ 5. Log to Salesforce   │
         │    Update fields:      │
         │    - SMS_X_Month_Sent  │
         │    - Last_Contact_Date │
         │    - Status            │
         └────────────────────────┘
                     ↓
                   END
```

---

## 💬 Customer SMS Journey

**From First Message to Booked Appointment**

```
┌──────────────────────────────────────────────────────────────────────┐
│ CUSTOMER JOURNEY - SMS CONVERSATION FLOW                             │
└──────────────────────────────────────────────────────────────────────┘

DAY 1 (6 months before expiry)
    ↓
┌─────────────────────────────────────────────────────────────────────┐
│ 📱 SMS SENT                                                         │
│ "Hi John, this is Sarah Williams from KTFS. Your fixed-rate       │
│  mortgage expires in 24 weeks. Let's discuss your renewal options. │
│  Reply YES to book a call. Reply STOP to opt out."                 │
└─────────────────────────────────────────────────────────────────────┘
    ↓
    Customer receives SMS
    ↓
┌─────────────────┬─────────────────┬─────────────────┬──────────────┐
│  Replies YES    │  Replies STOP   │  Asks question  │  No reply    │
└────────┬────────┴────────┬────────┴────────┬────────┴──────┬───────┘
         ↓                 ↓                 ↓               ↓
    ┌────────────┐   ┌────────────┐   ┌────────────┐   ┌────────────┐
    │   BOOKING  │   │  OPT-OUT   │   │  QUESTION  │   │   WAIT     │
    │    FLOW    │   │  HANDLER   │   │  HANDLER   │   │            │
    └────────────┘   └────────────┘   └────────────┘   └────────────┘
         │                 │                 │               │
         ↓                 ↓                 ↓               ↓
    (See below)      Update SF        Offer to book     Try again
                     Opt_Out=true     + notify advisor  in 1 month
```

---

## 📅 Booking Flow (When Customer Replies YES)

```
Customer replies: "YES" or "BOOK"
    ↓
┌─────────────────────────────────────────────────────────────────────┐
│ 1. Lookup Customer in Salesforce                                   │
│    Match phone number → Get customer record                         │
│    Retrieve: Name, Advisor ID, Mortgage details                    │
└─────────────────────────────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────────────────────────────┐
│ 2. Query Reapit for Advisor's Calendar                             │
│    GET /appointments?negotiatorId=ADV001&start=today&end=+7days    │
│    Find existing bookings                                           │
└─────────────────────────────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────────────────────────────┐
│ 3. Calculate Available Slots                                        │
│    Working hours: 9am-5pm Mon-Fri                                   │
│    Slot duration: 30 minutes (confirm with Anthony)                │
│    Exclude existing appointments                                    │
│    Select top 3 available slots                                     │
└─────────────────────────────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────────────────────────────┐
│ 4. Send Available Times via SMS                                     │
│ "Great! I have availability on:                                     │
│  1) Tue 5th Nov at 2:00pm                                           │
│  2) Wed 6th Nov at 10:00am                                          │
│  3) Thu 7th Nov at 3:00pm                                           │
│  Reply with 1, 2, or 3 to confirm your appointment."               │
└─────────────────────────────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────────────────────────────┐
│ 5. Customer Selects Time                                            │
│    Replies: "2" or "Wed 10am" or "2nd option"                      │
└─────────────────────────────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────────────────────────────┐
│ 6. Create Appointment in Reapit                                     │
│    POST /appointments                                               │
│    {                                                                │
│      "start": "2025-11-06T10:00:00Z",                              │
│      "end": "2025-11-06T10:30:00Z",                                │
│      "typeId": "MO",                                                │
│      "description": "Mortgage renewal - SMS booking",               │
│      "negotiatorIds": ["ADV001"],                                   │
│      "attendee": { "id": "CONT123", "type": "contact" }            │
│    }                                                                │
└─────────────────────────────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────────────────────────────┐
│ 7. Update Salesforce                                                │
│    - Appointment_ID: APT789456                                      │
│    - Appointment_Date: 2025-11-06 10:00                            │
│    - Status: "Booked"                                               │
│    - SMS_Response: "Interested"                                     │
└─────────────────────────────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────────────────────────────┐
│ 8. Send Confirmation SMS                                            │
│ "Perfect! Your appointment with Sarah Williams is confirmed for     │
│  Wednesday 6th November at 10:00am. You'll receive a reminder 24   │
│  hours before. Looking forward to speaking with you!"               │
└─────────────────────────────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────────────────────────────┐
│ 9. Notify Advisor (Email/SMS)                                       │
│ "New appointment booked via SMS:                                    │
│  Customer: John Smith                                               │
│  Date: Wed 6th Nov at 10:00am                                       │
│  Reason: Mortgage expiry consultation"                              │
└─────────────────────────────────────────────────────────────────────┘
    ↓
  ✅ BOOKING COMPLETE
```

---

## 📞 Phone Call Escalation (3.5 Months)

**When customer hasn't responded after 3 SMS messages**

```
DAY 1 (6 months): SMS sent ✅
    ↓
    No response
    ↓
DAY 30 (5 months): SMS sent ✅
    ↓
    No response
    ↓
DAY 60 (4 months): SMS sent ✅
    ↓
    No response
    ↓
DAY 75 (3.5 months): ESCALATION TRIGGERED ⚠️
    ↓
┌─────────────────────────────────────────────────────────────────────┐
│ Escalation Workflow (Runs Daily at 10am)                           │
└─────────────────────────────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────────────────────────────┐
│ 1. Query Salesforce                                                 │
│    Find leads WHERE:                                                │
│    - Days until expiry = 105 (3.5 months)                          │
│    - SMS_Response = "None"                                          │
│    - Appointment_ID = null                                          │
│    - Phone_Call_Task_Created = false                                │
│    - Opt_Out = false                                                │
└─────────────────────────────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────────────────────────────┐
│ 2. Create High-Priority Task in Salesforce                          │
│    Task Details:                                                    │
│    - Subject: "URGENT: Phone Call - Mortgage Expiry Follow-up"     │
│    - Priority: High                                                 │
│    - Status: Not Started                                            │
│    - Due Date: Today                                                │
│    - Assigned To: [Advisor from lead record]                        │
│    - Description:                                                   │
│      "Customer: John Smith                                          │
│       Phone: +44 7XXX XXXXXX                                        │
│       Mortgage expires: 15 Feb 2025 (105 days)                     │
│       3 SMS messages sent - no response                             │
│       Please call to discuss renewal options."                      │
└─────────────────────────────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────────────────────────────┐
│ 3. Update Mortgage Record                                           │
│    - Phone_Call_Task_Created: true                                  │
│    - Status: "Escalated to Advisor"                                 │
└─────────────────────────────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────────────────────────────┐
│ 4. Send Notification to Advisor                                     │
│    Email/SMS to advisor:                                            │
│    "You have a high-priority follow-up call for John Smith.        │
│     Mortgage expires in 15 weeks. 3 SMS sent with no response.     │
│     View task in Salesforce."                                       │
└─────────────────────────────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────────────────────────────┐
│ Advisor sees task in Salesforce dashboard                           │
│ → Makes personal phone call                                         │
│ → Updates task status when complete                                 │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 🔄 Complete Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                      DATA FLOW ARCHITECTURE                          │
└─────────────────────────────────────────────────────────────────────┘

    [Salesforce] ←────────────────┐
         │                         │
         │ 1. Daily query          │ 5. Update status
         │    (Read leads)         │    (Write logs)
         ↓                         │
    [n8n Workflow 1]              │
    Date Calculator  ──────────────┘
         │
         │ 2. Filtered leads
         │    (180/150/120 days)
         ↓
    [n8n Workflow 2]
    SMS Sender
         │
         │ 3. Send SMS
         ↓
    [Twilio] ──→ [Customer]
         ↑            │
         │            │ 4. Reply
         │            ↓
    [Twilio Webhook] → [n8n Workflow 3]
                       Inbound Handler
                            │
            ┌───────────────┼───────────────┐
            ↓               ↓               ↓
       [Parse Intent]  [Opt-Out]    [Booking Request]
            │               │               │
            │               │               ↓
            │               │        [Query Reapit]
            │               │        Get availability
            │               │               │
            │               │               ↓
            │               │        [Send time options]
            │               │               │
            │               │               ↓
            │               │        [Customer selects]
            │               │               │
            │               │               ↓
            │               │        [POST to Reapit]
            │               │        Create appointment
            │               │               │
            └───────────────┴───────────────┘
                            ↓
                    [Update Salesforce]
                    Log all activity
```

---

## 🎯 Message Timeline Visualization

```
CUSTOMER: John Smith
MORTGAGE EXPIRY: 15 February 2026
ADVISOR: Sarah Williams

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

     6 MONTHS OUT                    TODAY
          ↓                            ↓
━━━━━━━━━●━━━━━━━━━━━━━━━━━━━━━━━━━━━━●━━━━━━━━━━━━━━━━━━━━━━━━→
        Aug                          Feb                         Aug
        2025                         2026                        2026

Timeline of automated touchpoints:

📅 15 Aug 2025 (180 days / 6 months)
   📱 SMS #1: "Your mortgage expires in 6 months..."
   ⏰ Sent at 10:00 AM
   📊 Logged in Salesforce

📅 15 Sep 2025 (150 days / 5 months)
   📱 SMS #2: "Your mortgage expires in 5 months..."
   ⏰ Sent at 10:00 AM
   📊 Logged in Salesforce

📅 15 Oct 2025 (120 days / 4 months)
   📱 SMS #3: "Your mortgage expires in 4 months..."
   ⏰ Sent at 10:00 AM
   📊 Logged in Salesforce

📅 30 Oct 2025 (105 days / 3.5 months)
   📞 ESCALATION: High-priority phone call task created
   👤 Assigned to Sarah Williams
   ⚠️  "Customer not responding to SMS"

📅 15 Feb 2026 (Day 0)
   ⚠️  MORTGAGE EXPIRES
   🎯 Goal: Customer has renewed with KTFS before this date

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 📊 Response Handling Matrix

```
┌─────────────────────────────────────────────────────────────────────┐
│                    CUSTOMER RESPONSE MATRIX                          │
└─────────────────────────────────────────────────────────────────────┘

Customer Reply          │ System Action              │ Salesforce Update
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"YES" / "BOOK"         │ → Start booking flow       │ Status: "Interested"
"INTERESTED"           │ → Send available times     │ Conversation_State:
                       │                            │   "AWAITING_TIME"
─────────────────────────────────────────────────────────────────────────
"1" / "2" / "3"        │ → Create appointment       │ Status: "Booked"
(after time options)   │ → Send confirmation        │ Appointment_ID: XXX
                       │ → Notify advisor           │ Appointment_Date: XXX
─────────────────────────────────────────────────────────────────────────
"STOP"                 │ → Add to suppression list  │ Opt_Out: true
"UNSUBSCRIBE"          │ → Send confirmation        │ Status: "Opted Out"
"OPT OUT"              │ → No more messages         │
─────────────────────────────────────────────────────────────────────────
Complex question       │ → Reply: "Great question!  │ Status: "Question Asked"
(e.g., "What rates?")  │    [Advisor] can discuss.  │ + Create notification
                       │    Book a call?"           │   task for advisor
─────────────────────────────────────────────────────────────────────────
"NO" / "NOT           │ → Reply: "No problem!      │ Status: "Not Interested"
INTERESTED"            │    Feel free to reach out  │ No further messages
                       │    if you change your mind"│
─────────────────────────────────────────────────────────────────────────
Unrecognized reply     │ → Reply: "Sorry, didn't    │ Log response
                       │    understand. Reply YES   │ Conversation_State:
                       │    to book or STOP to opt  │   "UNCLEAR"
                       │    out."                   │
─────────────────────────────────────────────────────────────────────────
No response            │ → Wait for next scheduled  │ SMS_Response: "None"
(after 7 days)         │    message (1 month later) │ Next_Contact: +30 days
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 🔒 Error Handling & Failsafes

```
┌─────────────────────────────────────────────────────────────────────┐
│                   ERROR HANDLING WORKFLOW                            │
└─────────────────────────────────────────────────────────────────────┘

Potential Error                   │ System Response
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Salesforce API timeout           │ → Retry 3 times with backoff
                                 │ → Log error
                                 │ → Email alert to Oliver
─────────────────────────────────────────────────────────────────────
Reapit calendar unavailable      │ → Fall back to booking link
                                 │ → Send SMS with Cal.com URL
                                 │ → Log issue for review
─────────────────────────────────────────────────────────────────────
Twilio SMS delivery failed       │ → Mark in Salesforce
                                 │ → Retry next day
                                 │ → Alert if >5% failure rate
─────────────────────────────────────────────────────────────────────
Invalid phone number             │ → Skip send
                                 │ → Flag in Salesforce
                                 │ → Create task for data cleanup
─────────────────────────────────────────────────────────────────────
Double booking attempt           │ → Check for existing appointment
(customer replies twice)         │ → Reply: "You're already booked"
                                 │ → No duplicate created
─────────────────────────────────────────────────────────────────────
Customer already opted out       │ → Skip all messages
                                 │ → Log attempted send (but don't send)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

All errors logged to Salesforce and n8n execution logs
Critical errors trigger immediate email alert to Oliver
```

---

## 📈 Success Metrics Dashboard

```
┌─────────────────────────────────────────────────────────────────────┐
│               WEEKLY PERFORMANCE SNAPSHOT                            │
└─────────────────────────────────────────────────────────────────────┘

ENGAGEMENT METRICS                    TARGET    ACTUAL
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SMS Sent                              150       152 ✅
SMS Delivered                         >95%      97% ✅
SMS Response Rate                     >10%      14% ✅
Appointments Booked                   >5%       8%  ✅
Opt-Out Rate                          <2%       1%  ✅

TECHNICAL METRICS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Workflow Success Rate                 >95%      99% ✅
API Error Rate                        <5%       1%  ✅
Average Response Time                 <2sec     0.8s ✅

BUSINESS OUTCOMES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Consultations Booked This Week        -         12
Phone Escalations Created             -         8
Customers Retained (vs. lost)         -         TBD

Updated: Daily at 6:00 PM
Available in Salesforce dashboard
```

---

## 🎬 Example End-to-End Journey

```
┌─────────────────────────────────────────────────────────────────────┐
│        REAL CUSTOMER EXAMPLE: JOHN SMITH                            │
└─────────────────────────────────────────────────────────────────────┘

Customer Details:
• Name: John Smith
• Phone: +44 7700 900123
• Mortgage Expiry: 15 February 2026
• Current Rate: 2.5% fixed (expiring)
• Assigned Advisor: Sarah Williams
• Property: 123 High Street, London

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DAY 1 - 15 August 2025 (6 months out)
─────────────────────────────────────
10:00 AM - System Action:
  • n8n queries Salesforce
  • Finds John's record (180 days until expiry)
  • Sends personalized SMS via Twilio

10:00 AM - John receives:
  📱 "Hi John, this is Sarah Williams from KTFS. Your fixed-rate
     mortgage expires in 24 weeks. Let's discuss your renewal options.
     Reply YES to book a call. Reply STOP to opt out."

10:15 AM - John replies:
  📱 "YES"

10:15 AM - System responds:
  📱 "Great! I have availability on: 1) Tue 20th Aug at 2:00pm,
     2) Wed 21st Aug at 10:00am, 3) Thu 22nd Aug at 3:00pm.
     Reply with 1, 2, or 3 to confirm your appointment."

10:17 AM - John replies:
  📱 "2"

10:17 AM - System actions:
  • Creates appointment in Reapit:
    - Date: Wed 21st Aug 2025
    - Time: 10:00 AM - 10:30 AM
    - Advisor: Sarah Williams
    - Contact: John Smith
  • Updates Salesforce:
    - Status: "Booked"
    - Appointment_ID: APT123456
    - SMS_Response: "Interested"
  • Sends confirmation to John
  • Notifies Sarah Williams

10:17 AM - John receives:
  📱 "Perfect! Your appointment with Sarah Williams is confirmed for
     Wednesday 21st August at 10:00am. You'll receive a reminder 24
     hours before. Looking forward to speaking with you!"

10:18 AM - Sarah receives email:
  📧 "New SMS Booking: John Smith - Wed 21 Aug 10:00am
     Topic: Mortgage renewal (expires Feb 2026)"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Result:
✅ Customer engaged within 15 minutes
✅ Appointment booked with zero advisor effort
✅ All data logged in Salesforce
✅ Advisor prepared with context
✅ Customer has clear confirmation

Total Time: 17 minutes from first message to booked appointment
Advisor Time Required: 0 minutes (fully automated)
```

---

**This visual guide shows every touchpoint, decision point, and data flow in the KTFS system.**

**Document Version:** 1.0
**Created:** 29 October 2025
**For:** Anthony - KTFS Leadership Review
