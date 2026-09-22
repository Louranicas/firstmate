---
name: tool-source-shelf
description: Agent-only pointer to the Kun Cheng (kunchenguid) source shelf. Load before reading, inspecting, or patching the source behind a live axi, no-mistakes, or treehouse tool, before drawing on a capability repo (kun, compact-adviser, grok-ship, gnhf, backpass, vision), or before deciding anything about Pi context compaction.
user-invocable: false
metadata:
  internal: true
---

# tool-source-shelf

A home may keep Firstmate's tooling and several capability repos cloned as source on a local shelf, off the system disk.
Home-local clone paths, where this home has them, are recorded in `data/learnings.md`.

`KUNCHENGUID_REPOS.md` on that shelf is the index for the Kun Cheng (kunchenguid) repos and owns their list, the clone rationale, the Jev ranking that puts `kun` first, and what was deliberately skipped.
Read it for which Kun Cheng repos are on the shelf rather than any list held here; it is not a full inventory of the shelf root, which also holds unrelated clones.

## Invoke the PATH binary, read the clone

Firstmate's live tools - the axi family, `no-mistakes`, `treehouse` - run from their installed binaries on `PATH`.
A shelf clone of one of those is source to read, inspect, or patch, never a second install: do not run one out of its clone, and do not reinstall it from the clone.
The shelf's capability repos are not installed binaries at all; read them as source when the work calls for their capability.

## Capability repos and where they fit

None of these is a PATH binary in this home.
Reach for one only in the live Firstmate workflow named below, invoke it through its public package or by reading the shelf clone as source, and keep the mount path itself out of shared tracked material - the home-local clone path lives only in `data/learnings.md`.

- `kun` is a principal-engineer reasoning skill (`/kun`).
  Use it as a spawn hint: a worker facing a hard design decision or a nasty bug may invoke `/kun`, and Firstmate may use it for an architecture call.
  Invoke the `/kun` skill, installable with `npx skills add kunchenguid/kun -g`; it fetches Kun's living docs over HTTPS, and the shelf clone is that same source offline.
- `vision` mines a repo's own history into a testable `VISION.md` acceptance policy through an interactive review board (`/vision`, or `/vision owner/repo`).
  Use it from `project-management` when a project needs an acceptance policy or should refine one.
  Invoke the `/vision` skill, installable with `npx skills add kunchenguid/vision -g`; its board runs through `npx -y lavish-axi`, the same lavish surface Firstmate already uses.
- `grok-ship` is superseded as a whole, but its `vision-md-triage-verdict` skill is live value: given a repo's `VISION.md`, it returns a per-rule aligns / does not align / cannot tell verdict with cited evidence, and any cannot-tell blocks an auto-merge.
  Use that verdict in contribution follow-up (`bearings`) and before any VISION-gated auto-merge; read the skill from the shelf clone as source.
  Its `adversarial-review` skill is only a supplementary lens, never a substitute for `no-mistakes`, which owns pre-PR review.
- `gnhf` is a ralph-style orchestrator whose every iteration is one small committed change toward an objective.
  Use it only for a bounded, clearly verifiable, unattended improvement run the captain wants driven autonomously; a worker drives it in Companion mode and treats a met stop condition as the worker stopping, not as acceptance.
  Invoke `npx gnhf` (or `npm i -g gnhf`) and follow its `skills/gnhf/SKILL.md`; it runs its own loop and so does not replace Firstmate's crew supervision for ordinary tasks.
- `backpass` is gradient descent for a memory surface: it reads agent session transcripts and proposes evidence-gated edits to `AGENTS.md` and skills, and never writes until `backpass apply`.
  Use it for cross-session, captain-gated maintenance of a memory surface, complementing the in-session `/stow` pass rather than replacing it.
  Invoke `npx backpass` for analysis then `backpass apply` for the human gate; it needs `acpx` on PATH, so confirm that dependency before relying on it.
  Firstmate's own tracked `AGENTS.md` and skills are shared, so route any proposed edit to them through the normal PR path and see `firstmate-coding-guidelines`.

## Context compaction: two facts that must not be confused

`compact-adviser` sources its compact hints from Jev; Grok is hint-only there.
`pi-openai-server-compaction` is OpenAI compaction, not Jev; it targets Pi 0.80.x and must not be pi-installed on this fleet's Pi, which is 0.86 or later.
Neither fact depends on a local clone.
