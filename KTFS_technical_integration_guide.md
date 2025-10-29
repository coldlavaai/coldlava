# KTFS Mortgage Renewal System - Technical Integration Guide
## n8n + Reapit + Salesforce + Twilio Architecture

**Prepared by:** Oliver Tatler - Cold Lava
**Date:** 29 October 2025
**Client:** KTFS (Karl Taylor Financial Services)
**Email:** oliver@coldlava.ai

---

## Executive Summary

This document provides a comprehensive technical blueprint for integrating Reapit (property management), Salesforce (CRM), Twilio (SMS), and n8n (automation orchestration) to create an automated mortgage renewal engagement system.

**Key Finding:** All required integrations are technically feasible. Reapit provides robust REST API and webhook support, n8n has native Salesforce nodes, and Twilio two-way SMS is well-documented. No major technical blockers identified.

---

## System Architecture Overview

```
┌──────────────────────────────────────────────────────────────────┐
│                         KTFS MORTGAGE RENEWAL SYSTEM              │
└──────────────────────────────────────────────────────────────────┘

┌─────────────────────┐
│      Reapit         │
│  (Property System)  │
│                     │
│  • Mortgage data    │
│  • Customer details │
│  • Calendar/appts   │
│  • Advisor schedules│
└──────────┬──────────┘
           │
           │ REST API (Read: mortgages, contacts)
           │ REST API (Write: create appointments)
           │ Webhooks (appointment.created, appointment.modified)
           │
           ↓
┌─────────────────────┐
│    Salesforce       │
│       (CRM)         │
│                     │
│  • Lead tracking    │
│  • SMS log          │
│  • Task management  │
│  • Advisor routing  │
└──────────┬──────────┘
           │
           │ n8n Salesforce Node (OAuth 2.0)
           │ Read/Write: Leads, Tasks, Custom Objects
           │
           ↓
┌─────────────────────────────────────────────────────────────────┐
│                          n8n ORCHESTRATION                       │
│                                                                  │
│  Workflow 1: Daily Sync & Message Scheduler                     │
│  Workflow 2: Inbound SMS Handler & Booking Bot                  │
│  Workflow 3: Escalation Trigger (3.5mo phone call)              │
│  Workflow 4: Webhook Receiver (Reapit appointment events)       │
│                                                                  │
└─────────────────────┬───────────────────────────────────────────┘
                      │
                      │ Twilio Node (SMS Send)
                      │ Webhook (SMS Receive)
                      │
                      ↓
           ┌─────────────────────┐
           │   Twilio SMS        │
           │  (Communication)    │
           │                     │
           │  • Outbound msgs    │
           │  • Inbound replies  │
           │  • Opt-out handling │
           └──────────┬──────────┘
                      │
                      ↓
           ┌─────────────────────┐
           │  Mortgage Holders   │
           │    (End Users)      │
           └─────────────────────┘
```

---

## Integration 1: Reapit Foundations API

### Authentication

**Method:** OAuth 2.0 Client Credentials Flow (machine-to-machine)

**Token Endpoint:** `https://connect.reapit.cloud/token`

**Request Example:**
```http
POST https://connect.reapit.cloud/token
Authorization: Basic base64(clientId:clientSecret)
Content-Type: application/x-www-form-urlencoded

grant_type=client_credentials
```

**Response:**
```json
{
  "access_token": "eyJhbGciOiJSUzI1NiIs...",
  "token_type": "Bearer",
  "expires_in": 3600
}
```

**n8n Implementation:**
- Use HTTP Request node with OAuth2 authentication
- Store credentials in n8n credential store
- Token refresh handled automatically by n8n

### API Base Configuration

- **Base URL:** `https://platform.reapit.cloud`
- **API Version Header:** `api-version: 2020-01-31`
- **Customer Header:** `reapit-customer: [CUSTOMER_ID]` (or 'SBOX' for sandbox)
- **Rate Limits:**
  - 20 requests/second
  - 5 concurrent requests max
  - 250,000 requests/day max

### Key Endpoints for KTFS

#### 1. Get Mortgage/Property Data

**Endpoint:** `GET /properties`

**Query Parameters:**
- `pageSize`: 100 (max)
- `pageNumber`: 1, 2, 3...
- `embed`: negotiator, offices (to get advisor details)
- Custom filters via metadata if available

**Response Structure:**
```json
{
  "_embedded": [
    {
      "id": "OXF123456",
      "address": {...},
      "selling": {
        "instructed": "2023-01-15",
        "price": 450000
      },
      "lettings": {...},
      "negotiatorId": "NEG001",
      "metadata": {
        "mortgageExpiryDate": "2025-06-15",
        "mortgageAdvisor": "ADV001"
      }
    }
  ],
  "pageNumber": 1,
  "pageSize": 100,
  "pageCount": 10,
  "totalPageCount": 10
}
```

**Note:** Mortgage expiry data may be stored in:
- Custom metadata fields
- Linked applicant/contact records
- External system (need to confirm with KTFS)

#### 2. Get Contact/Applicant Data

**Endpoint:** `GET /contacts/{id}` or `GET /applicants/{id}`

**Purpose:** Retrieve customer name, phone, email

**Response:**
```json
{
  "id": "OXF999",
  "title": "Mr",
  "forename": "John",
  "surname": "Smith",
  "mobilePhone": "+447700900000",
  "email": "john.smith@example.com",
  "marketingConsent": "email,sms"
}
```

#### 3. Create Appointment

**Endpoint:** `POST /appointments`

**Request Body:**
```json
{
  "start": "2025-11-05T14:00:00Z",
  "end": "2025-11-05T14:30:00Z",
  "typeId": "MO",
  "description": "Mortgage renewal consultation - SMS booking",
  "organiserId": "NEG001",
  "negotiatorIds": ["NEG001"],
  "propertyId": "OXF123456",
  "accompanied": true,
  "virtual": false,
  "attendee": {
    "id": "OXF999",
    "type": "contact"
  }
}
```

**Response:**
```json
{
  "id": "APT789456",
  "created": "2025-10-29T10:30:00Z",
  "start": "2025-11-05T14:00:00Z",
  "end": "2025-11-05T14:30:00Z",
  "_links": {
    "self": { "href": "/appointments/APT789456" }
  }
}
```

**n8n Implementation:**
- HTTP Request node: POST
- Dynamic data from Twilio webhook response
- Error handling for double-bookings
- Confirmation message back to customer

#### 4. Get Negotiator/Advisor Availability

**Endpoint:** `GET /appointments`

**Query Parameters:**
- `negotiatorId`: ADV001
- `start`: 2025-11-01
- `end`: 2025-11-07

**Purpose:** Check available time slots before offering them to customer

**Logic:**
- Define working hours (e.g., 9am-5pm Mon-Fri)
- Query existing appointments
- Calculate free slots
- Offer 3-4 options to customer

### Reapit Webhooks

**Subscription Setup:**
- Register via Reapit Developer Portal
- Provide n8n webhook URL: `https://[your-n8n-instance].app.n8n.cloud/webhook/reapit-appointments`

**Relevant Topics:**
- `appointments.created` - Appointment booked
- `appointments.modified` - Appointment changed/rescheduled
- `appointments.confirmed` - All parties confirmed
- `appointments.cancelled` - Appointment cancelled

**Webhook Payload Example:**
```json
{
  "eventId": "abc-123-def",
  "entityId": "APT789456",
  "customerId": "KTFS",
  "eventTime": "2025-10-29T10:30:00Z",
  "topicId": "appointments.created",
  "new": {
    "id": "APT789456",
    "start": "2025-11-05T14:00:00Z",
    "negotiatorIds": ["NEG001"],
    "attendee": {
      "id": "OXF999",
      "type": "contact"
    }
  },
  "old": null,
  "diff": null
}
```

**n8n Webhook Node Configuration:**
- Path: `/webhook/reapit-appointments`
- Method: POST
- Authentication: Signature verification (Ed25519)
- Response: 200 OK

**Use Case:** Update Salesforce when appointment is confirmed/cancelled

---

## Integration 2: Salesforce CRM

### Authentication

**Method:** OAuth 2.0 Authorization Code Flow

**n8n Configuration:**
- Use built-in Salesforce credential type
- Requires Salesforce Connected App setup
- Client ID and Secret from Salesforce
- Automatic token refresh

**Salesforce Setup Steps:**
1. Create Connected App in Salesforce Setup
2. Enable OAuth Settings
3. Add Callback URL: `https://[n8n-instance]/rest/oauth2-credential/callback`
4. Select scopes: `api`, `refresh_token`, `full`
5. Copy Consumer Key (Client ID) and Secret

### n8n Salesforce Node

**Available Operations:**
- Account: create, delete, get, getAll, update, upsert
- Attachment: create, delete, get, getAll, update
- Case: create, delete, get, getAll, update
- Contact: create, delete, get, getAll, update
- Lead: create, delete, get, getAll, update, getSummary
- Task: create, delete, get, getAll, update
- Custom Object: create, delete, get, getAll, update, upsert
- Flow: invoke
- Search: query via SOQL

### Data Model for KTFS

#### Custom Object: Mortgage_Renewal__c

```
Fields:
- Name (Auto-number: MR-0001)
- Contact__c (Lookup to Contact)
- Property_ID__c (Text - Reapit property ID)
- Mortgage_Expiry_Date__c (Date)
- Assigned_Advisor__c (Lookup to User)
- SMS_6_Month_Sent__c (DateTime)
- SMS_5_Month_Sent__c (DateTime)
- SMS_4_Month_Sent__c (DateTime)
- SMS_Response__c (Picklist: None, Interested, Not Interested, Booked)
- Appointment_ID__c (Text - Reapit appointment ID)
- Appointment_Date__c (DateTime)
- Status__c (Picklist: New, Contacted, Booked, Completed, Opted Out)
- Phone_Call_Task_Created__c (Checkbox)
- Opt_Out__c (Checkbox)
```

#### Lead Object (Alternative)

If using standard Lead object instead:
- Store mortgage expiry in custom field
- Track SMS history in Activity History
- Use Lead Status for tracking

#### Task Object (Phone Call Escalation)

```
Fields:
- WhoId: Contact ID
- WhatId: Mortgage_Renewal__c ID
- Subject: "Phone Call - Mortgage Expiry Follow-up"
- Priority: High
- Status: Not Started
- ActivityDate: Today
- OwnerId: Assigned Advisor
- Description: "3 SMS messages sent with no response. Mortgage expires in X weeks."
```

### n8n Operations

#### 1. Create/Update Mortgage Renewal Record

**Node:** Salesforce (Upsert operation)

**Upsert Logic:**
- External ID: `Property_ID__c` (Reapit property ID)
- If exists: Update
- If not: Create

**Data Mapping:**
```javascript
{
  "Property_ID__c": "{{$json.reapitPropertyId}}",
  "Contact__c": "{{$json.salesforceContactId}}",
  "Mortgage_Expiry_Date__c": "{{$json.mortgageExpiryDate}}",
  "Assigned_Advisor__c": "{{$json.advisorId}}",
  "Status__c": "New"
}
```

#### 2. Log SMS Activity

**Node:** Salesforce (Create Task)

**Data:**
```javascript
{
  "Subject": "SMS Sent - 6 Month Reminder",
  "WhoId": "{{$json.contactId}}",
  "WhatId": "{{$json.mortgageRenewalId}}",
  "Status": "Completed",
  "ActivityDate": "{{$today}}",
  "Description": "SMS sent via Twilio: {{$json.messageBody}}"
}
```

#### 3. Create Phone Call Task (3.5mo Escalation)

**Node:** Salesforce (Create Task)

**Trigger Condition:**
- 105 days before expiry
- No SMS response
- No appointment booked

**Data:**
```javascript
{
  "Subject": "URGENT: Phone Call - Mortgage Expiry Follow-up",
  "WhoId": "{{$json.contactId}}",
  "WhatId": "{{$json.mortgageRenewalId}}",
  "Priority": "High",
  "Status": "Not Started",
  "ActivityDate": "{{$today}}",
  "OwnerId": "{{$json.advisorId}}",
  "Description": "Customer has not responded to 3 SMS messages. Mortgage expires in {{$json.daysUntilExpiry}} days. Please call to discuss renewal options."
}
```

#### 4. Query Records Needing Messages

**Node:** Salesforce (Search - SOQL)

**Query (6-month message):**
```sql
SELECT Id, Contact__c, Contact__r.FirstName, Contact__r.MobilePhone,
       Mortgage_Expiry_Date__c, Assigned_Advisor__r.Name
FROM Mortgage_Renewal__c
WHERE Mortgage_Expiry_Date__c = NEXT_N_DAYS:180
AND SMS_6_Month_Sent__c = null
AND Opt_Out__c = false
LIMIT 100
```

**Similar queries for 5-month (150 days) and 4-month (120 days)**

---

## Integration 3: Twilio SMS

### Setup Requirements

**Twilio Account:**
- Sign up at twilio.com
- Purchase UK phone number (+44)
- Note Account SID and Auth Token
- Configure webhook URL for incoming messages

**n8n Twilio Node:**
- Built-in node available
- Credential type: Twilio API
- Operations: Send SMS, Make Call, etc.

### Outbound SMS (Reminders)

**Node:** Twilio (Send SMS)

**Configuration:**
```javascript
{
  "from": "+44XXXXXXXXXX", // Your Twilio number
  "to": "{{$json.customerPhone}}",
  "message": "Hi {{$json.firstName}}, this is {{$json.advisorName}} from KTFS. Your fixed-rate mortgage expires in {{$json.weeksUntilExpiry}} weeks. Let's chat about renewal options - would you like to book a call? Reply YES or BOOK. Reply STOP to opt out."
}
```

**Message Length:** Keep under 160 characters for single SMS, or accept multi-part

**Personalization Variables:**
- `{{firstName}}` - Contact.FirstName from Salesforce
- `{{advisorName}}` - Assigned advisor name
- `{{weeksUntilExpiry}}` - Calculated from expiry date
- `{{companyName}}` - KTFS

**Opt-out Handling:**
- Twilio automatically handles STOP/START/HELP keywords
- Additionally parse in n8n for Salesforce logging

### Inbound SMS (Responses & Booking)

**Twilio Webhook Configuration:**
- URL: `https://[n8n-instance].app.n8n.cloud/webhook/twilio-sms`
- Method: POST
- Twilio will send SMS details when customer replies

**Webhook Payload:**
```json
{
  "MessageSid": "SM1234567890",
  "From": "+447700900000",
  "To": "+44XXXXXXXXXX",
  "Body": "YES",
  "FromCity": "London",
  "FromCountry": "GB"
}
```

**n8n Webhook Node:**
- Path: `/webhook/twilio-sms`
- Method: POST
- Authentication: None (Twilio signature validation optional)

### Two-Way SMS Conversation Flow

#### Step 1: Customer Replies with Intent

**Triggers:** "YES", "BOOK", "INTERESTED", "CALL ME"

**n8n Logic:**
1. Receive webhook from Twilio
2. Parse message body (lowercase, trim)
3. Lookup customer in Salesforce by phone number
4. Check if they have pending mortgage renewal

**Response:**
```javascript
{
  "message": "Great! I have availability on: 1) Tue 5th Nov 2pm, 2) Wed 6th Nov 10am, 3) Thu 7th Nov 3pm. Reply 1, 2, or 3 to book."
}
```

#### Step 2: Get Available Slots from Reapit

**n8n HTTP Request:**
- GET Reapit appointments for advisor
- Calculate free slots
- Format for SMS display

**Alternative (Simpler):**
Send booking link instead of conversational flow:
```
"Great! Book your consultation here: https://ktfs.cal.com/[advisor-slug]?prefill_name={{firstName}}"
```

#### Step 3: Customer Selects Time

**Trigger:** "1", "2", "3" (or specific time)

**n8n Logic:**
1. Parse selection
2. Map to actual datetime
3. Create appointment in Reapit via POST
4. Update Salesforce (appointment booked)
5. Send confirmation SMS

**Confirmation Message:**
```
"Confirmed! You're booked with {{advisorName}} on {{date}} at {{time}}. You'll receive a reminder 24hrs before. See you then!"
```

#### Step 4: Opt-out Handling

**Triggers:** "STOP", "UNSUBSCRIBE", "OPTOUT"

**n8n Logic:**
1. Update Salesforce: Opt_Out__c = true
2. Add to Twilio suppression list (if using Twilio managed opt-outs)
3. No further messages sent

**Response:**
```
"You've been unsubscribed from KTFS mortgage reminders. Reply START to re-subscribe."
```

### Session Management

**Challenge:** SMS is stateless - how to track conversation context?

**Solution Options:**

**Option 1: Simple State Machine**
- Store conversation state in Salesforce custom field
- `Conversation_State__c`: "AWAITING_BOOKING", "AWAITING_TIME_SELECTION", etc.
- Check state on each inbound message

**Option 2: Time-based Context**
- If last outbound message was <5 minutes ago, assume reply is related
- Use `Last_SMS_Sent__c` timestamp field

**Option 3: Session Token**
- Include unique code in SMS: "Reply with code ABC123 and your time preference"
- Parse code to retrieve context

**Recommendation:** Use Option 1 (state field) for reliability

---

## Integration 4: n8n Workflow Orchestration

### Workflow 1: Daily Sync & Message Scheduler

**Trigger:** Schedule (Cron: 0 9 * * * - 9am daily)

**Steps:**

1. **Query Salesforce for Mortgage Renewals**
   - Node: Salesforce (SOQL Search)
   - Get all records with expiry dates in next 6 months
   - Filter: Not opted out

2. **Calculate Days Until Expiry**
   - Node: Code (JavaScript)
   - For each record, calculate: `daysUntilExpiry = (expiryDate - today) / (1000*60*60*24)`

3. **Split by Message Type**
   - Node: Switch
   - Cases:
     - `daysUntilExpiry == 180` → 6-month message
     - `daysUntilExpiry == 150` → 5-month message
     - `daysUntilExpiry == 120` → 4-month message
     - `daysUntilExpiry == 105 && noResponse` → Escalation task

4. **Send SMS via Twilio**
   - Node: Twilio (Send SMS)
   - Personalized message with variables
   - One message per contact

5. **Log Activity in Salesforce**
   - Node: Salesforce (Update)
   - Update `SMS_X_Month_Sent__c` timestamp
   - Create Task record for activity history

6. **Error Handling**
   - Node: If (check for errors)
   - Log failed sends to Salesforce
   - Send alert email to admin

**Rate Limiting:**
- Add delay between SMS sends (e.g., 1 second)
- Prevents Twilio rate limit violations
- Use n8n Wait node

### Workflow 2: Inbound SMS Handler & Booking Bot

**Trigger:** Webhook (Twilio incoming SMS)

**Steps:**

1. **Receive Webhook**
   - Node: Webhook
   - Path: `/webhook/twilio-sms`
   - Extract: From (phone), Body (message)

2. **Lookup Customer in Salesforce**
   - Node: Salesforce (Search)
   - Query by phone number on Contact object
   - Get related Mortgage_Renewal__c record

3. **Parse Intent**
   - Node: Code (JavaScript)
   ```javascript
   const message = $input.item.json.Body.toLowerCase().trim();
   const intents = {
     booking: ['yes', 'book', 'interested', 'call', 'schedule'],
     optout: ['stop', 'unsubscribe', 'opt out', 'optout'],
     cancel: ['cancel', 'no', 'not interested']
   };

   let intent = 'unknown';
   if (intents.booking.some(word => message.includes(word))) intent = 'booking';
   if (intents.optout.some(word => message.includes(word))) intent = 'optout';
   if (intents.cancel.some(word => message.includes(word))) intent = 'cancel';

   return { intent, originalMessage: message };
   ```

4. **Route by Intent**
   - Node: Switch (on `intent`)

5. **Booking Flow Branch**
   - Check conversation state
   - If first booking request:
     - Query Reapit for advisor availability
     - Format available slots
     - Send SMS with options
     - Update Salesforce state: "AWAITING_TIME_SELECTION"
   - If time selection:
     - Parse selected time
     - Create appointment in Reapit
     - Update Salesforce: Appointment_ID__c, Status = "Booked"
     - Send confirmation SMS

6. **Opt-out Branch**
   - Update Salesforce: Opt_Out__c = true
   - Send confirmation SMS
   - End workflow

7. **Unknown Intent Branch**
   - Send helpful response: "Sorry, I didn't understand. Reply YES to book, or STOP to opt out."

### Workflow 3: Escalation Trigger (3.5mo Phone Call)

**Trigger:** Schedule (Cron: 0 10 * * * - 10am daily)

**Steps:**

1. **Query Salesforce**
   - Node: Salesforce (SOQL)
   ```sql
   SELECT Id, Contact__c, Contact__r.Name, Contact__r.Phone,
          Mortgage_Expiry_Date__c, Assigned_Advisor__c
   FROM Mortgage_Renewal__c
   WHERE Mortgage_Expiry_Date__c = NEXT_N_DAYS:105
   AND SMS_Response__c = 'None'
   AND Appointment_ID__c = null
   AND Phone_Call_Task_Created__c = false
   AND Opt_Out__c = false
   ```

2. **Create High-Priority Task**
   - Node: Salesforce (Create Task)
   - Assign to mortgage advisor
   - Set priority: High
   - Due date: Today
   - Include context from SMS history

3. **Update Mortgage Renewal Record**
   - Node: Salesforce (Update)
   - Set `Phone_Call_Task_Created__c = true`
   - Prevents duplicate tasks

4. **Send Advisor Notification**
   - Node: Send Email (or Slack/Teams)
   - Alert advisor of urgent follow-up needed
   - Include customer details and context

### Workflow 4: Webhook Receiver (Reapit Appointment Events)

**Trigger:** Webhook (Reapit)

**Steps:**

1. **Receive Webhook**
   - Node: Webhook
   - Path: `/webhook/reapit-appointments`
   - Verify signature (Ed25519)

2. **Parse Event Type**
   - Node: Switch (on `topicId`)
   - Cases:
     - `appointments.created`
     - `appointments.confirmed`
     - `appointments.cancelled`
     - `appointments.modified`

3. **Update Salesforce**
   - For `created`: Update Appointment_ID__c, Status = "Booked"
   - For `confirmed`: Status = "Confirmed"
   - For `cancelled`: Status = "Cancelled", clear appointment fields

4. **Send Customer Notification (Optional)**
   - If cancelled: SMS to customer
   - If confirmed: Reminder SMS

---

## Technical Implementation Plan

### Phase 1: API Access & Credentials (Week 1)

**Tasks:**
- [ ] KTFS to provide Reapit API credentials (Client ID, Secret, Customer ID)
- [ ] KTFS to provide Salesforce admin credentials or create Connected App
- [ ] Oliver to create Twilio account and purchase UK number
- [ ] Oliver to set up n8n workspace (Cloud or self-hosted)

**Deliverables:**
- All APIs accessible from n8n
- Authentication working for all services
- Test environment configured

### Phase 2: Data Model & Sync (Week 2)

**Tasks:**
- [ ] Create Salesforce custom object: Mortgage_Renewal__c
- [ ] Build Reapit → Salesforce sync workflow
- [ ] Map data fields (property ID, expiry date, contact info)
- [ ] Test with 10 sample records

**Deliverables:**
- Salesforce populated with mortgage data
- Daily sync workflow running
- Data quality verified

### Phase 3: Message Scheduler (Week 3)

**Tasks:**
- [ ] Build daily scheduler workflow
- [ ] Implement date calculation logic
- [ ] Create message templates (3 versions)
- [ ] Integrate Twilio SMS sending
- [ ] Add Salesforce logging

**Deliverables:**
- Messages sent at 6mo, 5mo, 4mo triggers
- All sends logged in Salesforce
- Error handling functional

### Phase 4: Booking Integration (Week 4-5)

**Tasks:**
- [ ] Configure Twilio webhook
- [ ] Build inbound SMS parser
- [ ] Implement booking flow logic
- [ ] Integrate Reapit appointment creation
- [ ] Test end-to-end booking

**Deliverables:**
- Two-way SMS conversation working
- Appointments created in Reapit
- Confirmation messages sent

### Phase 5: Escalation & Webhooks (Week 6)

**Tasks:**
- [ ] Build escalation workflow (3.5mo trigger)
- [ ] Configure Reapit webhook subscription
- [ ] Build webhook receiver workflow
- [ ] Test task creation in Salesforce
- [ ] Test webhook event handling

**Deliverables:**
- Phone call tasks auto-created
- Reapit events synced to Salesforce
- Full workflow integrated

### Phase 6: Testing & Launch (Week 7-8)

**Tasks:**
- [ ] End-to-end testing with 50 sample leads
- [ ] Load testing (100 messages in batch)
- [ ] Compliance review (GDPR, FCA, PECR)
- [ ] User acceptance testing with KTFS team
- [ ] Training session for advisors
- [ ] Soft launch with 100 real leads
- [ ] Monitor for 1 week, adjust as needed
- [ ] Full rollout to 1,000 leads

**Deliverables:**
- System fully functional
- KTFS team trained
- Monitoring dashboard
- 100% of leads processed

---

## Technical Specifications Summary

### API Endpoints Used

| System | Endpoint | Method | Purpose |
|--------|----------|--------|---------|
| Reapit | `/properties` | GET | Fetch mortgage data |
| Reapit | `/contacts/{id}` | GET | Get customer details |
| Reapit | `/appointments` | GET | Check availability |
| Reapit | `/appointments` | POST | Create booking |
| Reapit | Webhook | POST | Receive appointment events |
| Salesforce | Custom Object | CRUD | Mortgage tracking |
| Salesforce | Task | CREATE | Phone call escalation |
| Salesforce | SOQL | QUERY | Find records needing messages |
| Twilio | `/Messages` | POST | Send SMS |
| Twilio | Webhook | POST | Receive SMS replies |

### Data Flow Summary

**Daily Sync:**
1. n8n queries Reapit for mortgage data (9am daily)
2. n8n upserts records to Salesforce
3. n8n calculates days until expiry
4. If 180/150/120 days: Send SMS via Twilio
5. Log activity in Salesforce

**Inbound SMS:**
1. Customer replies to SMS
2. Twilio sends webhook to n8n
3. n8n looks up customer in Salesforce
4. n8n parses intent (booking, opt-out, etc.)
5. If booking: Query Reapit for availability
6. n8n sends available times via SMS
7. Customer selects time
8. n8n creates appointment in Reapit
9. n8n updates Salesforce
10. n8n sends confirmation SMS

**Escalation:**
1. n8n checks Salesforce for 105-day records (10am daily)
2. If no response: Create high-priority Task
3. Assign to advisor
4. Send notification email

**Webhook Events:**
1. Appointment created/modified in Reapit
2. Reapit sends webhook to n8n
3. n8n updates Salesforce status
4. Optional: n8n sends customer notification

---

## Code Examples

### n8n Code Node: Calculate Days Until Expiry

```javascript
// Input: Array of Salesforce records with Mortgage_Expiry_Date__c
const today = new Date();
today.setHours(0, 0, 0, 0); // Normalize to midnight

const output = $input.all().map(item => {
  const expiryDate = new Date(item.json.Mortgage_Expiry_Date__c);
  const diffTime = expiryDate - today;
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  const diffWeeks = Math.floor(diffDays / 7);

  return {
    json: {
      ...item.json,
      daysUntilExpiry: diffDays,
      weeksUntilExpiry: diffWeeks,
      shouldSend6MonthMsg: diffDays === 180 && !item.json.SMS_6_Month_Sent__c,
      shouldSend5MonthMsg: diffDays === 150 && !item.json.SMS_5_Month_Sent__c,
      shouldSend4MonthMsg: diffDays === 120 && !item.json.SMS_4_Month_Sent__c,
      shouldEscalate: diffDays === 105 && !item.json.Phone_Call_Task_Created__c
    }
  };
});

return output;
```

### n8n Code Node: Parse SMS Intent

```javascript
// Input: Twilio webhook payload
const message = $input.item.json.Body.toLowerCase().trim();
const from = $input.item.json.From;

// Intent detection
const intents = {
  booking: /\b(yes|book|interested|call|schedule|appointment)\b/,
  timeSelection: /\b([1-3]|one|two|three)\b/,
  optout: /\b(stop|unsubscribe|opt out|remove)\b/,
  cancel: /\b(cancel|no thanks|not interested)\b/
};

let detectedIntent = 'unknown';
let extractedData = {};

if (intents.booking.test(message)) {
  detectedIntent = 'booking_request';
} else if (intents.timeSelection.test(message)) {
  detectedIntent = 'time_selection';
  const match = message.match(/\b([1-3]|one|two|three)\b/);
  extractedData.slotNumber = match[1];
} else if (intents.optout.test(message)) {
  detectedIntent = 'opt_out';
} else if (intents.cancel.test(message)) {
  detectedIntent = 'cancel';
}

return {
  json: {
    from: from,
    message: message,
    intent: detectedIntent,
    ...extractedData
  }
};
```

### n8n Code Node: Format Reapit Availability

```javascript
// Input: Array of existing appointments from Reapit
const existingAppointments = $input.all().map(item => ({
  start: new Date(item.json.start),
  end: new Date(item.json.end)
}));

// Define working hours
const workingHours = {
  start: 9, // 9am
  end: 17,  // 5pm
  slotDuration: 30 // minutes
};

// Get next 7 days
const availableSlots = [];
const today = new Date();

for (let day = 0; day < 7; day++) {
  const date = new Date(today);
  date.setDate(today.getDate() + day);

  // Skip weekends
  if (date.getDay() === 0 || date.getDay() === 6) continue;

  // Generate slots for this day
  for (let hour = workingHours.start; hour < workingHours.end; hour++) {
    for (let minute = 0; minute < 60; minute += workingHours.slotDuration) {
      const slotStart = new Date(date);
      slotStart.setHours(hour, minute, 0, 0);

      const slotEnd = new Date(slotStart);
      slotEnd.setMinutes(slotEnd.getMinutes() + workingHours.slotDuration);

      // Check if slot conflicts with existing appointment
      const hasConflict = existingAppointments.some(appt =>
        slotStart < appt.end && slotEnd > appt.start
      );

      if (!hasConflict) {
        availableSlots.push({
          start: slotStart,
          end: slotEnd,
          display: slotStart.toLocaleString('en-GB', {
            weekday: 'short',
            day: 'numeric',
            month: 'short',
            hour: '2-digit',
            minute: '2-digit'
          })
        });
      }
    }
  }
}

// Return first 3 available slots
const topSlots = availableSlots.slice(0, 3).map((slot, index) => ({
  number: index + 1,
  start: slot.start,
  end: slot.end,
  display: slot.display
}));

// Format for SMS
const smsMessage = `Great! I have availability on: ${topSlots.map(s =>
  `${s.number}) ${s.display}`
).join(', ')}. Reply 1, 2, or 3 to book.`;

return {
  json: {
    availableSlots: topSlots,
    smsMessage: smsMessage
  }
};
```

---

## Monitoring & Maintenance

### Key Metrics to Track

**Delivery Metrics:**
- SMS delivery rate (target: >95%)
- SMS response rate (target: >10%)
- Booking conversion rate (target: >5%)
- Opt-out rate (target: <2%)

**System Health:**
- n8n workflow execution success rate
- API error rates (Reapit, Salesforce, Twilio)
- Webhook delivery success rate
- Average workflow execution time

**Business Metrics:**
- Appointments booked via SMS
- Phone call escalations completed
- Mortgages renewed through KTFS
- Revenue generated

### n8n Monitoring Dashboard

**Built-in Features:**
- Execution log (view all workflow runs)
- Error alerts (email/Slack when workflow fails)
- Execution time tracking
- Manual workflow triggers for testing

**Custom Dashboard:**
- Build separate n8n workflow that queries execution data
- Aggregate metrics daily
- Send summary report to KTFS team
- Store in Google Sheets or visualize in Grafana

### Maintenance Tasks

**Daily:**
- Review failed executions
- Check SMS delivery logs
- Monitor Twilio spend

**Weekly:**
- Review conversion rates
- Analyze common SMS responses
- Check for API changes

**Monthly:**
- Update message templates based on performance
- Review and optimize workflows
- Check compliance with latest regulations
- Test disaster recovery

---

## Risk Mitigation

### Technical Risks

**API Rate Limits:**
- Implement exponential backoff
- Batch operations where possible
- Use caching for frequently accessed data

**Webhook Failures:**
- Implement retry logic in n8n
- Log all webhook payloads for replay
- Monitor webhook delivery success

**Data Sync Issues:**
- Daily reconciliation check
- Alert on missing data
- Manual sync option available

### Compliance Risks

**GDPR:**
- Documented lawful basis
- Clear opt-out mechanism
- Data retention policy (delete after 6 months post-expiry)
- Encryption in transit and at rest

**FCA:**
- Message templates reviewed by compliance
- All communications logged
- No guaranteed outcomes promised
- Clear identification of KTFS

**PECR:**
- Immediate opt-out processing
- Sender identification in all messages
- Service reminder framing

---

## Cost Breakdown

### API & Service Costs

**Reapit API:**
- Pricing model based on API call volume
- Estimate: £100-200/month for 1,000 leads
- (Confirm exact pricing with KTFS's Reapit contract)

**Salesforce:**
- Included in existing Salesforce license
- May need additional API calls if on lower-tier plan
- No additional cost expected

**Twilio:**
- UK SMS: ~£0.04 per message
- 1,000 leads × 3 messages = 3,000 SMS = £120
- Plus responses (estimate 300): +£12
- Phone number: £1/month
- **Monthly: ~£133**

**n8n:**
- Cloud (Starter): $20/month
- Cloud (Pro): $50/month (recommended for production)
- Self-hosted: Free (requires server ~£20/month)
- **Monthly: $50 (£40)**

**Total Monthly Running Costs: ~£293/month**

**Year 1 Total: £1,000 setup + (£500 × 12 management) + (£120 × 12 SMS) = £8,440**

---

## Next Steps

### Immediate Actions (This Week)

1. **KTFS to provide:**
   - Reapit API credentials
   - Salesforce admin access or Connected App details
   - Confirmation of FCA authorization number
   - List of mortgage advisors and their IDs in Reapit

2. **Oliver to complete:**
   - Set up Twilio account
   - Configure n8n Cloud workspace
   - Test API connections
   - Create Salesforce custom objects

3. **Joint call:**
   - Review Reapit data structure
   - Confirm mortgage expiry field location
   - Discuss message template preferences
   - Finalize pricing and contract

### Development Sprint (Week 1-8)

Follow the Phase 1-6 plan outlined above.

---

## Support & Contact

**Oliver Tatler**
Cold Lava - AI Automation & Business Intelligence
📧 oliver@coldlava.ai
📱 +44 151 541 6933
🌐 https://coldlavaai.github.io/home

**For Technical Issues:**
- Email with subject: "KTFS - [Issue Description]"
- Response time: Within 4 business hours
- Emergency hotline: +44 151 541 6933 (10am-6pm GMT)

**Documentation:**
- Project scope: `/Documents/KTFS_project_scope.md`
- Technical integration: `/Documents/KTFS_technical_integration_guide.md` (this file)

---

**Document Version:** 1.0
**Last Updated:** 29 October 2025
**Next Review:** After Phase 1 completion
