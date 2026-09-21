---
name: tool-source-shelf
description: Agent-only pointer to the Kun Cheng (kunchenguid) source shelf on the 10TB HDD. Load before reading, inspecting, or patching the source behind a live axi, no-mistakes, or treehouse tool, before drawing on a capability repo (kun, compact-adviser, grok-ship, gnhf, backpass, vision), or before deciding anything about Pi context compaction.
user-invocable: false
metadata:
  internal: true
---

# tool-source-shelf

Firstmate's tooling and several capability repos are cloned as source on the 10TB HDD, off the 2TB NVMe, under `/var/mnt/STORAGE-10TB/repos/<name>`.
`/var/mnt/STORAGE-10TB/repos/KUNCHENGUID_REPOS.md` is the shelf-side index and records the clone rationale, the Jev ranking, and what was deliberately skipped.
These clones are source to read, inspect, or patch; they are never a second install.

## Live tools: invoke the PATH binary, read the clone

Each tool below runs from its installed binary on `PATH`; the clone is only its source.
Do not run one of these out of its clone, and do not reinstall it from the clone.

- `gh-axi` - GitHub CLI - source `.../gh-axi`
- `quota-axi` - quota snapshots for dispatch - source `.../quota-axi`
- `tasks-axi` - backlog backend CLI - source `.../tasks-axi`
- `lavish-axi` - HTML artifact and board surface - source `.../lavish-axi`
- `chrome-devtools-axi` - browser automation - source `.../chrome-devtools-axi`
- `no-mistakes` - ship and validation pipeline - source `.../no-mistakes`
- `treehouse` - disposable worktree isolation - source `.../treehouse`

## Capability repos: knowledge and workflows to draw on

These are not installed binaries; read them as source when the work calls for their capability.

- `kun` - Jev first pick; PE knowledge, workflows, and skills - `.../kun`
- `compact-adviser` - context source for the `/compact` skill - `.../compact-adviser`
- `grok-ship` - Grok bot factory - `.../grok-ship`
- `gnhf` - overnight agent loop - `.../gnhf`
- `backpass` - trains a project `AGENTS.md` - `.../backpass`
- `vision` - reconstructs `VISION.md` from git history - `.../vision`

`...` is `/var/mnt/STORAGE-10TB/repos` throughout.

## Context compaction: two facts that must not be confused

`compact-adviser` sources its compact hints from Jev; Grok is hint-only there.
`pi-openai-server-compaction` (`.../pi-openai-server-compaction`) is OpenAI compaction, not Jev, and must not be pi-installed on Pi 0.86.
