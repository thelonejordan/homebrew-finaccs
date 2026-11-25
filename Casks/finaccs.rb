# The FinAccs cask for the thelonejordan/homebrew-finaccs tap. The release workflow
# (.github/workflows/release.yml) fills in the version, URL and checksum and pushes it to the tap as
# Casks/finaccs.rb. Edit this template, not the tap's copy.
#
# A cask, not a formula: a formula without a bottle is a source install, and Homebrew refuses those
# when the Command Line Tools are out of date, even when nothing gets compiled. A cask installs
# the prebuilt binary as it is.
cask "finaccs" do
  version "0.1.0"
  sha256 "fdb862300beffc6d910fc9423c113d3ab471f22ea40e42ef6b93f5ee03e7eec5"

  url "https://github.com/thelonejordan/homebrew-finaccs/releases/download/v0.1.0/finaccs-0.1.0-macos-arm64.tar.gz"
  name "FinAccs"
  desc "Personal finance, reconciled: bank and card statements in one ledger"
  homepage "https://github.com/thelonejordan/homebrew-finaccs"

  depends_on arch: :arm64
  depends_on macos: ">= :sonoma"
  # For `finaccs tunnel`
  depends_on formula: "cloudflared"

  # A compiled build (Nuitka), not source: the binary and the libraries next to it
  binary "finaccs/finaccs"

  # The build isn't notarized, so clear the download quarantine or macOS won't run it and the
  # libraries it loads
  postflight do
    system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", staged_path.to_s]
  end

  # Only with `brew uninstall --zap finaccs`: deletes all your FinAccs data
  zap trash: "~/Library/Application Support/FinAccs"

  caveats <<~EOS
    Start FinAccs and open it in your browser:
      finaccs

    Your data is kept in ~/Library/Application Support/FinAccs.
    brew upgrade and brew uninstall leave it alone (brew uninstall --zap deletes it).
  EOS
end
