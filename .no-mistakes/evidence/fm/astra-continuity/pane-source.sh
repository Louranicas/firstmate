#!/usr/bin/env bash
# Runs INSIDE Herdr lab pane w1:p1: capture native identity, draft, review, checkpoint, validate.
set -u
B=/var/home/Louranicas/.no-mistakes/worktrees/c1edd232ccb5/01M392CXM7NMXS287F008QRNDX/rust/context-continuity/target/release/fm-context-continuity; R=$(cd /var/home/Louranicas/.no-mistakes/evidence/01M392CXM7NMXS287F008QRNDX/lab-root && pwd -P); cd $R; exec > /var/home/Louranicas/.no-mistakes/evidence/01M392CXM7NMXS287F008QRNDX/pane-source.log 2>&1
echo "HERDR_SESSION=$HERDR_SESSION HERDR_PANE_ID=$HERDR_PANE_ID"
$B init $R/store
$B identity --host orac --root $R --thread thread-source --terminal $1 > id-src.json; echo "identity rc=$?"; cat id-src.json
printf 'Intent: finish continuity lab.\nNext: verify replay in fresh pane.\n' > handoff.md
$B draft id-src.json handoff.md cp-lab-1 > draft.json; echo "draft rc=$?"
echo "--- capture unreviewed draft (must refuse)"; $B checkpoint $R/store draft.json; echo "rc=$?"
jq '.intent="Finish continuity lab" | .scope="Herdr lab only" | .next_action="Verify replay in fresh pane" | .completed=["journal built"] | .decisions=["no live restart"] | .obligations=[{"id":"deliver-proof","state":"open","description":"Publish verified proof","owner":"supervisor"}] | .effects=[{"id":"publish-proof","intent_sha256":"'$(printf publish-once|sha256sum|cut -d" " -f1)'","state":"prepared","receipt_sha256":null}] | .reviewed_for_secrets=true' draft.json > cp.json
echo "--- capture reviewed"; $B checkpoint $R/store cp.json; echo "rc=$?"
echo "--- idempotent retry"; $B checkpoint $R/store cp.json; echo "rc=$?"
echo "--- validate"; $B validate $R/store cp-lab-1 id-src.json; echo "rc=$?"
echo SOURCE_DONE
