#!/usr/bin/env bash
# Runs INSIDE Herdr lab pane w1:p2 (fresh context stand-in): replay, readback, ack, retry.
set -u
B=/var/home/Louranicas/.no-mistakes/worktrees/c1edd232ccb5/01M392CXM7NMXS287F008QRNDX/rust/context-continuity/target/release/fm-context-continuity; R=$(cd /var/home/Louranicas/.no-mistakes/evidence/01M392CXM7NMXS287F008QRNDX/lab-root && pwd -P); cd $R; exec > /var/home/Louranicas/.no-mistakes/evidence/01M392CXM7NMXS287F008QRNDX/pane-target.log 2>&1
echo "HERDR_SESSION=$HERDR_SESSION HERDR_PANE_ID=$HERDR_PANE_ID"
$B identity --host orac --root $R --thread thread-fresh --terminal $1 > id-dst.json; echo "identity rc=$?"; cat id-dst.json
echo "--- replay 1"; $B replay $R/store cp-lab-1 id-src.json id-dst.json > replay1.json; echo "rc=$?"
jq -c '{sha256,state}' replay1.json; jq -r .body replay1.json | jq -c '{obligations:.checkpoint.obligations, effects:.checkpoint.effects, next:.checkpoint.next_action, rule}'
echo "--- replay 2 (pre-ack retry)"; $B replay $R/store cp-lab-1 id-src.json id-dst.json > replay2.json; cmp replay1.json replay2.json && echo "IDENTICAL_RETRY"
echo "--- ack with forged digest (must refuse)"; $B ack $R/store cp-lab-1 id-dst.json $(printf forged|sha256sum|cut -d" " -f1); echo "rc=$?"
echo "--- ack"; $B ack $R/store cp-lab-1 id-dst.json $(jq -r .sha256 replay1.json); echo "rc=$?"
echo "--- replay 3 (post-ack)"; $B replay $R/store cp-lab-1 id-src.json id-dst.json; echo "rc=$?"
echo TARGET_DONE
