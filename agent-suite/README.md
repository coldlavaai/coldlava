# Cold Lava Agent Suite

**Version:** 1.0
**Last Updated:** 2025-10-30
**Maintained by:** Cold Lava (oliver@otdm.net)

---

## Overview

This is the central reference repository for building voice and chat agents at Cold Lava. Every agent we create for clients should follow these guidelines, templates, and best practices.

## Purpose

- **Standardise** agent creation across all client projects
- **Document** conversation design principles
- **Maintain** UK spelling and pronunciation guidelines
- **Provide** reusable prompts and templates
- **Link** to Cold Lava dashboard and tools

## Structure

```
agent-suite/
├── README.md (this file)
├── guides/
│   ├── creating-agents.md
│   ├── improving-agents.md
│   └── troubleshooting.md
├── conversation-design/
│   ├── conversation-principles.md
│   ├── dialogue-patterns.md
│   └── handling-objections.md
├── uk-localization/
│   ├── spelling-guide.md
│   ├── pronunciation-guide.md
│   └── regional-variations.md
├── prompts/
│   ├── base-system-prompt.md
│   ├── industry-templates/
│   └── sophie-greenstar.md (current production example)
├── testing/
│   ├── tools/
│   │   └── vapi_agent_tester.py
│   ├── templates/
│   │   └── test_suite_template.sh
│   └── examples/
│       ├── sophie_exhaustive_test.sh
│       └── sophie_diagnostic_test.sh
└── examples/
    ├── solar-industry/
    ├── automotive/
    └── home-services/

```

## Quick Start

1. **Creating a new agent?** → Start with `/guides/creating-agents.md`
2. **Need a prompt template?** → Check `/prompts/base-system-prompt.md`
3. **UK client project?** → Review `/uk-localization/`
4. **Improving existing agent?** → See `/guides/improving-agents.md`
5. **Testing an agent?** → Use `/testing/tools/vapi_agent_tester.py`

## Dashboard Links

- **Cold Lava Dashboard:** [Coming soon]
- **n8n Workflows:** https://otdm22.app.n8n.cloud
- **Agent Deployments:** [Coming soon]

## Contributing

When adding new agents or updating guidelines:

1. Test thoroughly with real conversations
2. Document UK-specific requirements
3. Update relevant templates
4. Commit with clear messages
5. Update this README if structure changes

## Current Production Agents

- **Sophie (Greenstar Solar)** - Voice agent for solar panel enquiries
- **Detail Dynamics Widget** - Chat/voice embeddable widget

---

*For questions or support: oliver@otdm.net | +44 151 541 6933*
