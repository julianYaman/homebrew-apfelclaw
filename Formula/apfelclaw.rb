class Apfelclaw < Formula
  desc "Local-first macOS AI agent with guided onboarding and a separate chat app"
  homepage "https://github.com/julianYaman/apfelclaw"
  url "https://github.com/julianYaman/apfelclaw/releases/download/v0.2.3/apfelclaw-v0.2.3-darwin-arm64.tar.gz"
  version "0.2.3"
  sha256 "b939f22d41beed6fa43576c3541ee3b7808a504cc99aa77895d8c330ed6318a0"
  license "MIT"
  head "https://github.com/julianYaman/apfelclaw.git", branch: "main"
  depends_on "node"
  depends_on arch: :arm64
  depends_on macos: :tahoe

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  def install
    bin.install "bin/apfelclaw-chat"
    libexec.install Dir["libexec/*"]

    (bin/"apfelclaw").write <<~SH
      #!/bin/bash
      set -euo pipefail
      exec node "#{opt_libexec}/cli/apfelclaw.js" "$@"
    SH
  end

  def caveats
    <<~EOS
      Run `apfelclaw` once after install to finish onboarding and start the backend service.

      Manage the backend service with:
        brew services start apfelclaw
        brew services stop apfelclaw

      apfelclaw talks to the local apfel server on 127.0.0.1:11434 by default.
      Ollama uses the same port. If that port is already taken, point apfelclaw
      at a free port in ~/.apfelclaw/config.json, for example:

        "apfelPort": 11436

      then restart the service. Homebrew service logs are at:
        #{var}/log/apfelclaw.log
    EOS
  end

  service do
    run [
      "/usr/bin/env",
      "PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin",
      opt_libexec/"bin/apfelclaw-backend",
    ]
    keep_alive true
    working_dir var
    log_path var/"log/apfelclaw.log"
    error_log_path var/"log/apfelclaw.log"
  end

  test do
    assert_match "Commands:", shell_output("#{bin}/apfelclaw --help")
    assert_match "onboardingCompleted", shell_output("#{bin}/apfelclaw --status 2>&1")
  end
end
