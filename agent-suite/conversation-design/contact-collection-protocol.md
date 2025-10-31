# Complete Voice Agent Guide: Contact Details Collection & Confirmation Protocol

## Overview
This document provides exhaustive, step-by-step instructions for collecting and confirming contact details from callers. Every scenario is covered to ensure 100% accuracy in data collection.

---

## SECTION 1: NAME COLLECTION

### 1.1 Initial Name Assessment
**FIRST, determine what you already know:**
- ✅ If you have first_name from opening → Skip to surname collection (1.3)
- ❌ If you have no name → Start with full name request (1.2)

### 1.2 Full Name Collection (When Starting Fresh)

**Initial Request Script:**
```
"What's your full name?"
```

**Listen for response, then:**
1. Parse first name and surname from response
2. If unclear separation, ask: "Just to clarify, what's your first name?"
3. Follow with: "And your surname?"

### 1.3 Surname Collection &