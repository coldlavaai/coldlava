# KTFS Mortgage Renewal Automation System
**Karl Taylor Financial Services - Automated SMS & Booking System**

**Project Start:** 29 October 2025
**Developer:** Oliver Tatler - Cold Lava
**Client Contact:** Anthony (Head of KTFS)

---

## 📋 Project Overview

Automated mortgage renewal engagement system that:
- Sends SMS reminders at 6, 5, and 4 months before mortgage expiry
- Enables two-way SMS booking with Reapit calendar integration
- Escalates non-responders to advisors at 3.5 months
- Fully integrated with Salesforce CRM and Reapit property management

**Target:** 1,000 mortgage holders
**Goal:** High engagement rate, frictionless booking, zero compliance issues

---

## 📚 Documentation

### 🎯 For Presenting to Anthony
- **[PRESENTATION.md](PRESENTATION.md)** ⭐ - Full slide deck (40+ slides)
- **[WORKFLOW_DIAGRAM.md](WORKFLOW_DIAGRAM.md)** ⭐ - Visual system architecture & flows
- **[HOW_TO_PRESENT.md](HOW_TO_PRESENT.md)** ⭐ - Guide for Oliver on how to present

### 📄 Client-Facing Documents
- **[One-Page Summary](KTFS_one_page_summary.md)** - Executive overview for Anthony
- **[Questions for Anthony](KTFS_questions_for_anthony.md)** - Pre-build information needed
- **[SMS Templates](KTFS_sms_templates.md)** - Message templates for approval

### 🔧 Build & Technical
- **[1-Week Build Plan](KTFS_one_week_build_plan.md)** - Day-by-day development schedule
- **[Technical Integration Guide](KTFS_technical_integration_guide.md)** - Deep dive into APIs and architecture
- **[Project Scope](KTFS_project_scope.md)** - Complete requirements document

---

## 🏗️ Tech Stack

**Orchestration:** n8n (workflow automation)
**CRM:** Salesforce (lead tracking & management)
**Calendar:** Reapit (appointment booking)
**SMS:** Twilio (two-way messaging)
**Hosting:** n8n Cloud

---

## 🚀 Timeline

| Phase | Dates | Status |
|-------|-------|--------|
| Pre-Build (Data prep) | 29 Oct - 1 Nov | 🟡 In Progress |
| Development | 4 Nov - 8 Nov | ⚪ Pending |
| Testing | 8 Nov | ⚪ Pending |
| Pilot (100 leads) | 11 Nov | ⚪ Pending |
| Full Launch (1,000) | 13 Nov | ⚪ Pending |

---

## 💰 Investment

**Setup:** £1,000 (one-time)
**Monthly:** £500 (ongoing support & monitoring)
**SMS Costs:** ~£120/month (Twilio pass-through)
**Year 1 Total:** £8,440

---

## 📞 Key Contacts

**Oliver Tatler** (Developer)
📧 oliver@coldlava.ai
📱 +44 151 541 6933

**Anthony** (KTFS - Client Lead)
[Contact details to be added]

---

## 🔐 Access & Credentials

**Salesforce:**
- [ ] API credentials provided
- [ ] Custom fields created
- [ ] Test environment access

**Reapit:**
- [ ] API credentials provided
- [ ] Customer ID confirmed
- [ ] Test environment access

**Twilio:**
- [ ] Account SID & Auth Token
- [ ] UK phone number purchased
- [ ] Webhook configured

---

## ✅ Pre-Launch Checklist

### Data & Access
- [ ] Salesforce data cleaned and validated
- [ ] 1,000 mortgage records with expiry dates
- [ ] Valid mobile phone numbers confirmed
- [ ] Advisor assignments verified
- [ ] API credentials for all systems

### Approvals
- [ ] SMS message templates approved
- [ ] FCA authorization number provided
- [ ] Compliance review completed
- [ ] Budget confirmed (£1,000 + £500/month)
- [ ] Timeline confirmed (launch 11th Nov)

### Technical
- [ ] n8n workflows built and tested
- [ ] Salesforce integration working
- [ ] Reapit calendar integration working
- [ ] Twilio SMS sending and receiving
- [ ] Error handling and monitoring
- [ ] Documentation complete

### Testing
- [ ] End-to-end test with sample leads
- [ ] SMS delivery confirmed
- [ ] Booking flow tested
- [ ] Opt-out handling verified
- [ ] Escalation trigger tested
- [ ] Performance testing (50+ leads)

---

## 📊 Success Metrics

**Engagement:**
- Target: >80% SMS delivery rate
- Target: >10% response rate
- Target: >5% booking rate
- Target: <2% opt-out rate

**Technical:**
- Zero critical errors
- <5% API failure rate
- <1 second average response time

**Business:**
- Reply from almost every customer (even "no thanks")
- Reduced advisor workload (only speak to interested leads)
- Improved renewal conversion rate

---

## 🛠️ Development Log

### 29 October 2025
- Initial meeting with Anthony
- Requirements gathered
- Research completed (Reapit, Salesforce, Twilio APIs)
- Documentation created
- GitHub repo initialized

### [To be updated daily during build week]

---

## 📝 Notes

**Key Principles:**
1. Simple and reliable > Complex and buggy
2. Pilot first (100 leads) before full launch
3. Family business - zero tolerance for mistakes
4. FCA compliance built-in from day one
5. Adjust pricing/scope as we go (£1,000 + £500/month to start)

**Architecture:**
- Salesforce = source of truth (no sync FROM Reapit)
- n8n queries Salesforce daily for expiry dates
- SMS sent via Twilio, responses trigger booking flow
- Appointments created in Reapit
- Everything logged back to Salesforce

---

## 🆘 Support

**During Build (4-8 Nov):**
- Oliver available Mon-Fri 9am-6pm
- After-hours for urgent issues

**Post-Launch:**
- Email support within 4 hours
- Phone support for critical issues
- Monthly review calls
- Quarterly optimization

---

**Last Updated:** 29 October 2025
**Version:** 1.0
**Status:** Pre-Build / Documentation Phase
