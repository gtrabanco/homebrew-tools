class Dot < Formula
  version "3.0.12"
  desc "Lazy bash for lazy people. Have maintainable dotfiles with .Sloth. A Dotly fork."
  homepage "https://github.com/gtrabanco/.Sloth"
  url "https://github.com/gtrabanco/.Sloth.git", :using => :git, tag: "v#{version}"
  mirror "https://api.github.com/repos/gtrabanco/.Sloth/tarball/v#{version}"
  sha256 "b755858766d1aab19708f79160d4c035b4e83880dcd7dfc49aa0160c3efac81d"
  head "https://github.com/gtrabanco/.Sloth.git", :using => :git, branch: "master"
  license "MIT"

  option "dotfiles-path", "Provide where to place your dotfiles"
  
  depends_on "curl"
  depends_on "rust"
  depends_on "git"
  depends_on "git-delta"
  depends_on "rust"
  depends_on "coreutils"
  depends_on "findutils"
  depends_on "denisidoro/tools/docpars"
  depends_on "make" => :recommended
  depends_on "gnu-sed" => :recommended
  depends_on "gnu-tar" => :recommended
  depends_on "gnu-which" => :recommended
  depends_on "gawk" => :recommended
  depends_on "grep" => :recommended
  depends_on "bash" => :recommended
  depends_on "bash-completion@2" => :recommended
  depends_on "zsh" => :recommended
  depends_on "zsh-completions" => :recommended
  depends_on "python3" => :recommended
  depends_on "brew-pip" => :recommended
  depends_on "python-yq" => :recommended
  depends_on "gnutls" => :optional

  on_linux do
    depends_on xclip => :recommended
  end

  on_macos do
    depends_on "mas" => :recommended
  end

  def install
    ENV["SLOTH_PATH"] = "#{prefix}"
    bin.install "bin/dot"
    bin.install "bin/$"
    prefix.install "_raycast"
    prefix.install "dotfiles_template"
    prefix.install "migration"
    prefix.install "modules"
    prefix.install "scripts"
    prefix.install "shell"
    prefix.install "symlinks"

    on_linux do
      bin.install "bin/pbcopy"
      bin.install "bin/pbpaste"
      bin.install "bin/open"
    end

    prefix.install Dir["*!bin"]

    cd prefix do
      #rm_rf "bin/bin"
      rm_rf "scripts/core/version"
      ln_sf "scripts/core", "scripts/self"
    end

    #bash_completion/"dot" "shell/bash/completions/_dot"

    if build.with? "dotfiles-path"
      ENV["DOTFILES_PATH"] = build.dotfiles_path
      ohai "Installing .Sloth"
      system "dot", "core", "install"
    end
  end

  def caveats
    <<~EOS
      Additionally, if you haven't done yet, you can create your custom dotfiles with:
        DOTFILES_PATH="${HOME}/.dotfiles" dot dotfiles create
      After that activate .Sloth loader for your zsh & bash shell with:
        dot core loader --modify
      If you want to use .Sloth only in zsh or bash, see the help to know how to do it:
        dot core loader --help
    EOS
  end

  patch :DATA

  test do
    assert_match "dot " + version, shell_output("#{bin}/dot --version")
  end
end
__END__
diff --git a/bin/dot b/bin/dot
index 31a1c02..1abc212 100755
--- a/bin/dot
+++ b/bin/dot
@@ -3,6 +3,8 @@
 
 set -euo pipefail
 
+SLOTH_PATH="HOMEBREW_PREFIX/Cellar/dot"
+
 # In Linux we can do this with readlink -f but will fail in macOS and BSD OS
 if [[ -z "${SLOTH_PATH:-${DOTLY_PATH:-}}" || ! -d "${SLOTH_PATH:-${DOTLY_PATH:-}}" ]]; then
   if ! command -vp realpath &> /dev/null; then
