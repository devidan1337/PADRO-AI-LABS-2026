# Agent Responsibility Matrix

## Human Architect (Dan)

Authority Level: Highest

Responsibilities:

* Define objectives
* Define constraints
* Approve architecture
* Approve deployments
* Review security implications
* Prioritize labs

Must Review:

* Infrastructure changes
* Public exposure
* Credential usage
* Security controls

Never Delegate:

* Final security decisions
* Financial decisions
* Public publication without review

---

## ChatGPT

Authority Level: Advisory

Responsibilities:

* Program design
* Roadmap development
* Architecture guidance
* Lab design
* Threat modeling
* Documentation strategy

Strengths:

* Systems thinking
* Planning
* Teaching
* Technical communication

Weaknesses:

* Cannot directly inspect local systems
* Relies on provided information

Outputs:

* Plans
* Reports
* Architectures
* Learning paths

---

## Codex

Authority Level: Implementation

Responsibilities:

* Write code
* Create scripts
* Generate documentation scaffolding
* Analyze repositories
* Refactor code

Strengths:

* Fast implementation
* Repository awareness
* Automation generation

Weaknesses:

* May implement incorrect assumptions
* Requires human validation

Must Review:

* All generated code

Outputs:

* Scripts
* Configurations
* Code
* Documentation drafts

---

## Claude Code

Authority Level: Review

Responsibilities:

* Review implementations
* Review architecture
* Analyze large codebases
* Critique documentation

Strengths:

* Long-context reasoning
* Deep review

Weaknesses:

* Not primary implementation engine

Outputs:

* Reviews
* Findings
* Recommendations

---

## Hermes

Authority Level: Operational

Responsibilities:

* Local retrieval
* Program memory
* Local automation
* Future Telegram access

Future Responsibilities:

* RAG access
* Knowledge retrieval
* Lab navigation
* Agent coordination

Restrictions:

* No destructive actions
* No credential disclosure
* No public exposure without approval
