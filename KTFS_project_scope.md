# KTFS Mortgage Renewal Automation System
## Project Scope & Requirements

**Client:** KTFS (Karl Taylor Financial Services)
**Client Contact:** Anthony (Head of KTFS)
**Prepared by:** Oliver Tatler - Cold Lava
**Date:** 29 October 2025
**Email:** oliver@coldlava.ai
**Phone:** +44 151 541 6933

---

## Executive Summary

KTFS requires an automated mortgage renewal engagement system to systematically contact ~1,000 mortgage holders at strategic intervals before their fixed-rate mortgages expire. The system will deliver multi-touch SMS campaigns, enable direct appointment booking via text, and escalate non-responsive leads to sales advisors for phone follow-up.

**Key Challenge:** Integration between Salesforce (CRM), Reapit (property management system with calendar), and communication channels (SMS + phone).

---

## Current Situation

### Data & Volume
- **Current database:** ~1,000 mortgages due to expire (rolling basis)
- **Data source:** Reapit (primary property management software)
- **CRM system:** Salesforce
- **Lead volume:** Rolling/ongoing (not one-time batch)

### Current Process
- Manual tracking or no systematic follow-up
- Missed opportunities due to timing
- No automated escalation path
- Manual calendar booking

---

## Project Requirements

### 1. Message Schedule & Cadence

**Touchpoint Timeline:**
- **6 months before expiry:** First SMS reminder
- **5 months before expiry:** Second SMS reminder
- **4 months before expiry:** Third SMS reminder
- **3.5 months before expiry:** If no response/booking → Trigger phone call task for sales advisor

**Message Content Requirements:**
- Customer name (personalized)
- Reminder that fixed-rate mortgage is due to expire
- Countdown in weeks (e.g., "expires in 26 weeks")
- Option to book appointment with specific mortgage advisor
- Clear opt-out mechanism (STOP)
- KTFS branding and FCA compliance

**Example SMS:**
> Hi [FirstName], this is [AdvisorName] from KTFS. Your fixed-rate mortgage expires in [X] weeks. Let's chat about renewal options - would you like to book a call? Reply YES or BOOK. Reply STOP to opt out.

### 2. SMS Booking Functionality

**Critical Requirement:** SMS recipients must be able to book appointments directly via text

**User Experience Flow:**
1. Customer receives SMS reminder
2. Customer replies "YES", "BOOK", or similar keyword
3. System sends back available time slots or booking link
4. Customer selects time
5. Appointment created in Reapit calendar
6. Confirmation sent to customer and advisor
7. Salesforce updated with appointment status

**Alternative Flow (Simpler):**
1. SMS includes unique booking link (e.g., Cal.com or Reapit booking page)
2. Customer clicks link and books directly
3. Webhook updates Salesforce and triggers confirmation SMS

### 3. Phone Call Escalation

**Trigger:** No response or booking by 3.5 months before expiry

**Action:**
- Create task in Salesforce for sales advisor
- Assign to specific mortgage advisor
- Include all lead context (previous SMS sent, dates, mortgage details)
- Priority flag for urgent follow-up
- Track completion in Salesforce

### 4. System Integration Requirements

#### Reapit Integration
- **Primary need:** Calendar/appointment booking
- **Data sync:** Mortgage expiry dates, customer details
- **API access:** Read appointments, write appointments, read customer data
- **Webhook support:** Real-time appointment notifications

#### Salesforce Integration
- **Lead management:** Track all touchpoints and responses
- **Task creation:** Phone call assignments for advisors
- **Status updates:** Booking confirmed, call completed, etc.
- **Reporting:** Campaign performance, conversion rates
- **API access:** Read/write leads, create tasks, update records

#### n8n Workflow Platform
- **Central orchestration:** All logic and scheduling
- **Date calculations:** Trigger messages at exact intervals
- **Conditional logic:** Response detection, escalation triggers
- **Error handling:** Failed messages, API timeouts
- **Logging:** Audit trail for compliance

#### SMS Platform (Twilio)
- **Outbound SMS:** Scheduled reminder messages
- **Inbound SMS:** Response detection (YES, BOOK, STOP)
- **Two-way conversation:** Interactive booking flow
- **Opt-out handling:** Immediate suppression list updates
- **Delivery tracking:** Read receipts, failed delivery alerts

---

## Technical Architecture

### Data Flow Diagram

```
┌─────────────────────┐
│      Reapit         │ ← Mortgage data, customer details, calendar
│ (Property Software) │ → Appointment booking, availability
└──────────┬──────────┘
           │
           ↓ (Daily sync)
┌─────────────────────┐
│    Salesforce       │ ← Lead tracking, task management
│       (CRM)         │ → Status updates, advisor assignment
└──────────┬──────────┘
           │
           ↓ (Read/write)
┌─────────────────────┐
│       n8n           │ ← Logic engine, date calculations
│   (Automation)      │ → Workflow orchestration, triggers
└──────────┬──────────┘
           │
           ↓ (Message delivery)
┌─────────────────────┐
│   Twilio SMS        │ ← Outbound reminders, booking responses
│  (Communication)    │ → Inbound replies, opt-outs
└──────────┬──────────┘
           │
           ↓
┌─────────────────────┐
│   Mortgage Holders  │ ← Timely reminders, easy booking
└─────────────────────┘
```

### Workflow Logic

**Daily Scheduled Job (runs 9am daily):**
1. Query Reapit for all mortgages with expiry dates
2. Calculate days until expiry for each mortgage
3. Identify leads needing messages:
   - 180 days out (6 months) → Send SMS #1
   - 150 days out (5 months) → Send SMS #2
   - 120 days out (4 months) → Send SMS #3
   - 105 days out (3.5 months) + no response → Create Salesforce task
4. Check Salesforce for leads already contacted (prevent duplicates)
5. Send messages via Twilio
6. Log all activity to Salesforce

**Inbound SMS Webhook (real-time):**
1. Receive incoming SMS from Twilio
2. Parse message content (STOP, YES, BOOK, etc.)
3. If STOP → Add to suppression list, update Salesforce
4. If YES/BOOK → Trigger booking flow
5. If other → Log response, notify advisor

**Booking Flow (interactive):**
1. Customer replies YES or BOOK
2. System checks Reapit for advisor availability (next 7 days)
3. Send SMS with available slots: "Great! I have Tuesday 2pm, Thursday 10am, or Friday 3pm. Reply with your preferred day/time."
4. Customer replies with selection
5. Create appointment in Reapit via API
6. Send confirmation SMS to customer
7. Update Salesforce with "Appointment Booked" status
8. Send notification to advisor

**Escalation Trigger:**
1. Check for leads at 105 days (3.5 months) with no response
2. Create high-priority task in Salesforce
3. Assign to designated advisor
4. Include context: "3 SMS sent, no response. Requires phone call."
5. Track task completion

---

## Integration Research Required

### 1. Reapit API Capabilities
- [ ] REST API documentation and authentication method
- [ ] Endpoints for reading mortgage/property data
- [ ] Endpoints for calendar/appointment booking
- [ ] Webhook support for real-time updates
- [ ] Rate limits and API quotas
- [ ] Data fields available (expiry date, customer details, advisor assignment)
- [ ] n8n node availability (official or community)

### 2. Reapit Calendar Integration
- [ ] How appointments are structured in Reapit
- [ ] Can we create appointments programmatically?
- [ ] How to assign appointments to specific advisors
- [ ] Availability checking logic
- [ ] Booking confirmation workflow
- [ ] Cancellation/rescheduling capabilities

### 3. Salesforce Integration Points
- [ ] Object structure for mortgage leads
- [ ] Custom fields needed (SMS sent dates, response status)
- [ ] Task creation for phone escalation
- [ ] Workflow rules or triggers in Salesforce
- [ ] API authentication (OAuth 2.0)
- [ ] n8n Salesforce node capabilities

### 4. SMS Booking Patterns
- [ ] Two-way SMS conversation flow in n8n
- [ ] Twilio webhook configuration
- [ ] Session management for multi-message conversations
- [ ] Natural language processing for time selection
- [ ] Fallback to human handoff if booking fails
- [ ] Link-based booking vs. conversational booking

---

## Compliance & Legal Requirements

### GDPR Compliance
- ✓ Lawful basis: Legitimate interest (existing mortgage client relationship)
- ✓ Transparent opt-out in every message
- ✓ Data minimization: Only process necessary fields
- ✓ Secure data transfer between systems (API encryption)
- ✓ Data Processing Agreement with KTFS
- ✓ Audit trail of all communications

### FCA Regulations
- ✓ KTFS must be FCA authorized (confirm registration number)
- ✓ All messages must be clear, fair, not misleading
- ✓ No guaranteed outcomes in messaging
- ✓ Professional tone and branding
- ✓ Record-keeping for regulatory audit

### PECR (Marketing Communications)
- ✓ Service reminder framing (not cold marketing)
- ✓ Immediate opt-out processing (STOP keyword)
- ✓ Sender identification (KTFS)
- ✓ Suppression list maintained across all campaigns

---

## Deliverables

### Phase 1: Discovery & Setup (Week 1-2)
- [ ] Reapit API access and authentication
- [ ] Reapit data structure documentation
- [ ] Salesforce API access and field mapping
- [ ] Twilio account setup and phone number
- [ ] n8n workflow environment configuration
- [ ] Data Processing Agreement signed

### Phase 2: Core Workflow Build (Week 3-4)
- [ ] Daily sync: Reapit → Salesforce (mortgage data)
- [ ] Date calculation logic (6mo, 5mo, 4mo, 3.5mo triggers)
- [ ] SMS sending workflow via Twilio
- [ ] Message template creation (3 versions)
- [ ] Opt-out handling (STOP keyword)
- [ ] Salesforce logging of all touchpoints

### Phase 3: Booking Integration (Week 5-6)
- [ ] Inbound SMS webhook configuration
- [ ] Response detection logic (YES, BOOK, etc.)
- [ ] Reapit calendar API integration
- [ ] Availability checking workflow
- [ ] Appointment creation in Reapit
- [ ] Confirmation SMS sending
- [ ] Salesforce status update on booking

### Phase 4: Escalation & Reporting (Week 7)
- [ ] 3.5-month escalation trigger
- [ ] Salesforce task creation for phone calls
- [ ] Advisor assignment logic
- [ ] Task completion tracking
- [ ] Performance dashboard in n8n
- [ ] Weekly reporting to Anthony

### Phase 5: Testing & Launch (Week 8)
- [ ] Test with 20-50 sample leads
- [ ] Verify all integration points
- [ ] Compliance review of message templates
- [ ] User acceptance testing with KTFS team
- [ ] Training session for advisors
- [ ] Soft launch with 100 leads
- [ ] Monitor and adjust for 1 week
- [ ] Full rollout to 1,000 leads

---

## Success Metrics

### Engagement Metrics
- SMS delivery rate (target: >95%)
- SMS response rate (target: >10%)
- Opt-out rate (target: <2%)
- Booking conversion rate (target: >5%)

### Business Metrics
- Appointments booked via SMS
- Phone call escalations completed
- Mortgages renewed through KTFS
- Revenue generated (£400-500 per mortgage)
- ROI on automation investment

### Technical Metrics
- System uptime (target: 99%+)
- API success rate (Reapit, Salesforce, Twilio)
- Message delivery time (target: <5 seconds)
- Booking completion time (target: <2 minutes)

---

## Risks & Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| **Reapit API limitations** | High | Research thoroughly before committing; have fallback to manual calendar |
| **SMS deliverability issues** | Medium | Use established provider (Twilio), monitor delivery rates |
| **GDPR non-compliance** | High | Legal review of messaging, proper DPA, opt-out handling |
| **Salesforce data quality** | Medium | Data validation step, cleansing during migration |
| **Booking flow complexity** | Medium | Start with link-based booking (simpler), add conversational later |
| **Advisor capacity overload** | Low | Rate limiting, appointment spacing logic |
| **API rate limits** | Medium | Batch processing, error handling, queue management |

---

## Open Questions for Anthony

### Business Questions
1. What is your FCA authorization number?
2. Do all 1,000 leads have existing relationships with KTFS?
3. Have they consented to communications?
4. How many mortgage advisors will be handling callbacks?
5. What are typical advisor working hours for appointment availability?
6. Do you have preferred message tone/branding guidelines?
7. What's your current renewal conversion rate (baseline)?
8. Budget and timeline expectations?

### Technical Questions
1. Do you have admin access to Reapit API?
2. Is Reapit the primary source of truth for mortgage expiry dates?
3. How is Salesforce currently being used? (data structure)
4. Do advisors have individual calendars in Reapit?
5. Is there an existing Twilio account or should we create new?
6. Who will handle inbound SMS during business hours vs. after hours?
7. Do you want real-time notifications or daily digest reports?

---

## Pricing Estimate (To Be Finalized)

### Setup & Implementation
- **Discovery & API integration:** £2,500
  - Reapit API research and setup
  - Salesforce integration
  - n8n workflow development
  - Testing and compliance review

### Monthly Management
- **Active monitoring (Months 1-3):** £1,000/month
  - Daily system monitoring
  - Message optimization
  - Booking flow refinement
  - Performance reporting

- **Ongoing support (Month 4+):** £600/month
  - System maintenance
  - Monthly performance reports
  - Template updates
  - Technical support

### Optional Add-ons
- **Conversational AI booking:** +£500 setup
  - Natural language processing for appointment selection
  - More sophisticated booking flow

- **Custom reporting dashboard:** +£300
  - Real-time performance metrics
  - Advisor-specific analytics

**Year 1 Total:** ~£12,500 (higher than initial estimate due to complexity)

---

## Next Steps

1. **Immediate (This Week):**
   - [ ] Confirm project scope with Anthony
   - [ ] Get Reapit API access and documentation
   - [ ] Get Salesforce API credentials
   - [ ] Confirm FCA authorization and compliance requirements

2. **Week 1:**
   - [ ] Deep dive into Reapit API capabilities
   - [ ] Map Salesforce data structure
   - [ ] Design detailed workflow diagrams
   - [ ] Finalize pricing and sign contract

3. **Week 2:**
   - [ ] Begin n8n workflow development
   - [ ] Set up Twilio account and phone number
   - [ ] Create test environment

---

## Contact

**Oliver Tatler**
Cold Lava - AI Automation & Business Intelligence
📧 oliver@coldlava.ai
📱 +44 151 541 6933
🌐 https://coldlavaai.github.io/home

---

**Project Status:** Discovery phase - pending API access and final approval
**Next Review:** [Date to be scheduled with Anthony]
