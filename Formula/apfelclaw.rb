class Apfelclaw < Formula
  desc "Local-first macOS AI agent with guided onboarding and a separate chat app"
  homepage "https://github.com/julianYaman/apfelclaw"
  url "https://github.com/julianYaman/apfelclaw/releases/download/v0.2.2/apfelclaw-v0.2.2-darwin-arm64.tar.gz"
  version "0.2.2"
  sha256 "165cee200aeb6bf3989c128fbc70ba8e27114656d42e7bff83b57047730282b0"
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
