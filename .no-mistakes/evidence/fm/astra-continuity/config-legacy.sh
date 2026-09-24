#!/usr/bin/env bash
# Temp-only config-adopt/rollback and legacy injection-DB provenance via CLI. Never touches ~/.codex.
set -u; B=/var/home/Louranicas/.no-mistakes/worktrees/c1edd232ccb5/01M392CXM7NMXS287F008QRNDX/rust/context-continuity/target/release/fm-context-continuity; W=$(cd $(mktemp -d /var/home/Louranicas/.no-mistakes/evidence/01M392CXM7NMXS287F008QRNDX/cfg-XXXX) && pwd -P); cd $W; chmod 700 .
run(){ echo "$ $*"; "$@"; echo "rc=$?"; }
printf '# user notes\nmodel = "gpt-6-astra"\n\n[mcp_servers.x]\ncommand = "y"\n' > config.toml; chmod 600 config.toml
PRE=$(sha256sum config.toml|cut -d' ' -f1)
echo "=== C1 dry run (default) is non-mutating"; run $B config-adopt $W/config.toml $W/config.toml.bak $PRE; echo "hash unchanged: $([ $(sha256sum config.toml|cut -d' ' -f1) = $PRE ] && echo yes)"; ls config.toml.bak 2>&1
echo "=== C2 stale preimage refused"; run $B config-adopt $W/config.toml $W/config.toml.bak $(printf x|sha256sum|cut -d' ' -f1) --apply
echo "=== C3 apply"; run $B config-adopt $W/config.toml $W/config.toml.bak $PRE --apply; echo "--- new config:"; cat config.toml; echo "--- original bytes preserved as suffix: $(tail -c $(stat -c%s config.toml.bak) config.toml | cmp - config.toml.bak && echo yes)"; stat -c '%a %n' config.toml.bak
echo "=== C4 re-adopt refused (existing threshold)"; run $B config-adopt $W/config.toml $W/config2.bak $(sha256sum config.toml|cut -d' ' -f1)
CUR=$(sha256sum config.toml|cut -d' ' -f1); BK=$(sha256sum config.toml.bak|cut -d' ' -f1)
echo "=== C5 rollback dry run then apply"; run $B config-rollback $W/config.toml $W/config.toml.bak $CUR $BK; run $B config-rollback $W/config.toml $W/config.toml.bak $CUR $BK --apply; echo "restored exact: $([ $(sha256sum config.toml|cut -d' ' -f1) = $PRE ] && echo yes)"
echo "=== C6 non-Astra default model refused"; printf 'model = "gpt-6-sol"\n' > sol.toml; run $B config-adopt $W/sol.toml $W/sol.bak $(sha256sum sol.toml|cut -d' ' -f1)
echo "=== G legacy injection DB (synthetic quiescent snapshot)"
python3 - <<'PY'
import sqlite3
c=sqlite3.connect("injection.db"); c.executescript("CREATE TABLE session_checkpoint(id INTEGER PRIMARY KEY, label TEXT, timestamp_utc TEXT, source_file TEXT, consent TEXT, body TEXT);")
c.execute("INSERT INTO session_checkpoint VALUES(1,'habitat-handoff','2026-09-20T00:00:00Z','/zellij/pane/3/handoff.md','Emit','old prose that must not be emitted')")
c.execute("INSERT INTO session_checkpoint VALUES(2,'private','2026-09-20T00:00:00Z','x','Store','secret-ish prose')")
c.commit(); c.close()
PY
H=$(sha256sum injection.db|cut -d' ' -f1)
run $B legacy $W/injection.db 1; run $B legacy $W/injection.db 2; run $B legacy $W/injection.db 1 | grep -c 'old prose\|zellij' ; echo "legacy db unmodified: $([ $(sha256sum injection.db|cut -d' ' -f1) = $H ] && echo yes)"
echo live > injection.db-wal; echo "--- nonempty WAL present"; run $B legacy $W/injection.db 1; rm injection.db-wal
