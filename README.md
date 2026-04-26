# homebrew-apfelclaw

Homebrew tap for `apfelclaw`.

## Install

```bash
brew tap julianYaman/apfelclaw
brew install apfelclaw
```

Then run:

```bash
apfelclaw
```

## Notes

- Current formula target: Apple Silicon on macOS Tahoe (macOS 26) or newer
- The formula depends on `node`
- The backend is managed as a Homebrew service through the bundled `apfelclaw-backend` binary
- The first `apfelclaw` run completes onboarding and starts the Homebrew service automatically
- You can manage the service manually with `brew services start apfelclaw` and `brew services stop apfelclaw`
