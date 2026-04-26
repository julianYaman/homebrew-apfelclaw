class Apfelclaw < Formula
  desc "Local-first macOS AI agent with guided onboarding and a separate chat app"
  homepage "https://github.com/julianYaman/apfelclaw"
  url "https://github.com/julianYaman/apfelclaw/releases/download/v0.2.0/apfelclaw-v0.2.0-darwin-arm64.tar.gz"
  sha256 "f5dbd4c9259e380d08b9ca3de26654f99f77c7be53cbab2a531b1f49a91a4573"
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
    bin.install "bin/apfelclaw"
    bin.install "bin/apfelclaw-chat"
    libexec.install Dir["libexec/*"]
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
    run [opt_libexec/"bin/apfelclaw-backend"]
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
