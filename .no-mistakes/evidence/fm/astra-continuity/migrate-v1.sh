#!/usr/bin/env bash
# Build a schema-v1 journal the way v1 created it, then migrate via CLI with a bare relative backup name.
set -u; B=/var/home/Louranicas/.no-mistakes/worktrees/c1edd232ccb5/01M392CXM7NMXS287F008QRNDX/rust/context-continuity/target/release/fm-context-continuity; W=$(mktemp -d /var/home/Louranicas/.no-mistakes/evidence/01M392CXM7NMXS287F008QRNDX/migrate-XXXX); cd $W
mkdir -m 700 v1store
python3 - <<'PY'
import sqlite3, os
c=sqlite3.connect("v1store/journal.sqlite3"); c.executescript("PRAGMA application_id=%d; CREATE TABLE checkpoints(id TEXT PRIMARY KEY, body TEXT NOT NULL, sha TEXT NOT NULL); PRAGMA user_version=1;" % 0x464d4343); c.close(); os.chmod("v1store/journal.sqlite3",0o600)
PY
echo "user_version before: $(python3 -c 'import sqlite3;print(sqlite3.connect("v1store/journal.sqlite3").execute("pragma user_version").fetchone()[0])')"
echo "$ (cwd=$W) fm-context-continuity migrate v1store pre-v2.sqlite3"; $B migrate v1store pre-v2.sqlite3; echo rc=$?
ls -l pre-v2.sqlite3 | cut -d' ' -f1,5,9
echo "backup user_version: $(python3 -c 'import sqlite3;print(sqlite3.connect("file:pre-v2.sqlite3?mode=ro",uri=True).execute("pragma user_version").fetchone()[0])')"
echo "$ migrate again (already current; no-op)"; $B migrate v1store pre-v2.sqlite3; echo rc=$?
