# Tophat IPC PoC on GH Actions macos-latest

Push this directory as the root of any GitHub repo you own, then trigger the
`tophat-ipc-poc` workflow manually from the Actions tab. The runner will:

1. Download and open the latest official Tophat release.
2. Plant an attacker script at `~/Library/Application Scripts/com.shopify.Tophat/x.sh`.
3. Compile and run the Foundation-only Swift PoC that posts a
   `Tophat.InstallFromRecipesRequest` distributed notification with
   `artifactProviderID = "shell"` and `parameters = { "script": "x.sh" }`.
4. Print the marker file the script wrote, and dump the last 60s of
   Tophat's unified log.

Expected outcome on success:
- `/tmp/tophat_shell_proof.txt` contains a timestamp + the runner's username.
- Tophat log includes `[ArtifactDownloader] Adding downloaded artifact to container`.
