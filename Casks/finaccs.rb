# The FinAccs cask for the thelonejordan/homebrew-finaccs tap. The release workflow
# (.github/workflows/release.yml) fills in the version, URL and checksum and pushes it to the tap as
# Casks/finaccs.rb. Edit this template, not the tap's copy.
#
# A cask, not a formula: a formula without a bottle is a source install, and Homebrew refuses those
# when the Command Line Tools are out of date, even when nothing gets compiled. A cask installs
# the prebuilt binary as it is.
cask "finaccs" do
  version "0.2.0"
  sha256 "c2f3a79462f97cdb76e10fa2457abcdca789cf09652d0f6ca1bd51f65fd51441"

  url "https://github.com/thelonejordan/homebrew-finaccs/releases/download/v0.2.0/finaccs-0.2.0-macos-arm64.tar.gz"
  name "FinAccs"
  desc "Personal finance, reconciled: bank and card statements in one ledger"
  homepage "https://github.com/thelonejordan/homebrew-finaccs"

  depends_on arch: :arm64
  # Sonoma or later (Homebrew 5.1.11+; older versions read a bare symbol as exactly that version)
  depends_on macos: :sonoma
  # For `finaccs tunnel`
  depends_on formula: "cloudflared"

  # A compiled build (Nuitka), not source: the binary and the libraries next to it
  binary "finaccs/finaccs"

  # The build isn't notarized, so clear the download quarantine or macOS kills it and the libraries
  # it loads. Steps run in Homebrew's sandbox (5.1.14+), with paths relative to the staged folder.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "."], chdir: ".", writable_paths: ["."]
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
