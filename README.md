# CI workflow shell

This repository contains CI workflow definitions only.

No application source code, credentials, build outputs or internal
configuration is stored here. The source tree is fetched at build time as an
encrypted archive and unpacked only into the ephemeral runner workspace.

## Workflows

- `probe.yml` — read-only environment check, manual trigger only, no
  checkout, no artifacts, no uploads.
- `build-macos.yml` — manual macOS build. Produces unsigned packages only.
  No code signing and no notarization are performed.

## Required repository secrets

| Secret | Purpose |
| --- | --- |
| `SOURCE_BUNDLE_URL` | Short-lived URL of the encrypted source archive |
| `SOURCE_BUNDLE_KEY` | Passphrase for the source archive |
| `ARTIFACT_ENC_KEY` | Passphrase used to encrypt build outputs |

Never place these values in workflow files, commit messages, logs or
artifacts. Use short-lived URLs and rotate the passphrases after each run.

## Output handling

Build outputs are encrypted before upload and retained for one day. Download
and delete them promptly. The archive is ciphertext; it contains no plaintext
package.

## Status

These workflows are templates. They have not been executed on a hosted macOS
runner. Run `probe.yml` first and adjust toolchain versions before building.
