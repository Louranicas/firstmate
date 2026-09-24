#!/usr/bin/env bash
# CLI adversarial/negative controls against the release binary; all state in evidence-owned temp dirs.
set -u; B=/var/home/Louranicas/.no-mistakes/worktrees/c1edd232ccb5/01M392CXM7NMXS287F008QRNDX/rust/context-continuity/target/release/fm-context-continuity; E=/var/home/Louranicas/.no-mistakes/evidence/01M392CXM7NMXS287F008QRNDX; R=$(cd $E/lab-root && pwd -P); cd $R
run(){ echo "$ $*"; "$@"; echo "rc=$?"; }
echo "=== A1 identity outside any Herdr pane"; run env -u HERDR_SESSION -u HERDR_PANE_ID $B identity --host orac --root $R --thread t --terminal term_x1
echo "=== A2 Zellij-style numeric pane id refused"; run env HERDR_SESSION=fm-lab-x HERDR_PANE_ID=3 $B identity --host orac --root $R --thread t --terminal term_x1
echo "=== A3 non-Astra model refused"; run env HERDR_SESSION=fm-lab-x HERDR_PANE_ID=w1:p1 $B identity --host orac --root $R --thread t --terminal term_x1 --model gpt-6-sol
echo "=== A4 replay to different host refused"; jq '.host="other-host"' id-dst.json > id-other.json; run $B replay $R/store cp-lab-1 id-src.json id-other.json
echo "=== A5 secret in reviewed checkpoint refused"; jq '.id="cp-secret" | .intent="use password=hunter2"' cp.json > cp-secret.json; run $B checkpoint $R/store cp-secret.json
echo "=== A6 immutable id collision refused"; jq '.intent="different work"' cp.json > cp-collide.json; run $B checkpoint $R/store cp-collide.json
echo "=== A7 stale source after handoff edit"; cp handoff.md handoff.bak; echo "tampered" >> handoff.md; run $B validate $R/store cp-lab-1 id-src.json; run $B replay $R/store cp-lab-1 id-src.json id-other2.json 2>/dev/null; mv handoff.bak handoff.md; run $B validate $R/store cp-lab-1 id-src.json
echo "=== A8 bare relative backup + migrate (child cwd = store parent)"; run $B backup store b.sqlite3; ls -l b.sqlite3 | cut -c1-10; run $B backup store b.sqlite3; run $B migrate store m.sqlite3; ls m.sqlite3 2>&1
echo "=== A9 restore to new private dir, never activated"; run $B restore $R/b.sqlite3 $R/restored; run $B validate $R/restored cp-lab-1 id-src.json
echo "=== L1 launch dry-run with dash-led prompt, empty PATH"; printf -- '- resume at obligation deliver-proof\n' > prompt.md; run env PATH= $B launch --cwd $R --prompt-file prompt.md --dry-run
echo "=== T telemetry classification"; now=$(date +%s)
for c in "active_context 231000 true" "active_context 231000 false" "active_context 225000 true" "active_context 100000 true" "last_request 243589 true" "cumulative 525827 true" "unknown null true"; do set -- $c
 jq -n --slurpfile i id-src.json --argjson n $now --arg s $1 --argjson t $2 --argjson cs $3 '{identity:$i[0],observed_at:$n,semantics:$s,tokens:$t,runtime_version:"codex-cli 0.156.0",compact_supported:$cs}' > tel.json; echo "-- $c"; $B assess tel.json id-src.json; echo rc=$?; done
jq -n --slurpfile i id-src.json --argjson n $((now-3600)) '{identity:$i[0],observed_at:$n,semantics:"active_context",tokens:231000,runtime_version:"x",compact_supported:true}' > tel.json; echo "-- stale active_context 231000"; $B assess tel.json id-src.json; echo rc=$?
