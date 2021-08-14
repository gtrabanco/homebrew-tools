class Dot < Formula
  revision 2
  version "3.0.9"
  desc "Lazy bash for lazy people. Have maintainable dotfiles with .Sloth. A Dotly fork."
  homepage "https://github.com/gtrabanco/.Sloth"
  url "https://github.com/gtrabanco/.Sloth.git", :using => :git, tag: "v#{version}"
  # mirror "https://api.github.com/repos/gtrabanco/.Sloth/tarball/v#{version}"
  sha256 "bfb0478e8224c144a3d2696bb23b158f042bdbab7648990e559a1bdde92d1266"
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
  depends_on "python-yq" => :recommended
  depends_on "gnutls" => :optional

  on_macos do
    depends_on "mas" => :recommended
  end

  patch :p0, :DATA

  def install
    ENV["SLOTH_PATH"] = "#{prefix}"
    bin.install "bin/dot"
    prefix.install "bin/$" => "bin/$"
    prefix.install "bin/open" => "bin/open"
    prefix.install "bin/pbcopy" => "bin/pbcopy"
    prefix.install "bin/pbpaste" => "bin/pbpaste"
    prefix.install "_raycast"
    prefix.install "dotfiles_template"
    prefix.install "migration"
    prefix.install "modules"
    prefix.install "scripts/core/src"
    prefix.install "scripts/core/_main.sh"
    prefix.install "scripts/self"
    prefix.install "shell"
    prefix.install "symlinks"
    #bash_completion/"dot" "shell/bash/completions/_dot"

    if build.with? "dotfiles-path"
      ENV["DOTFILES_PATH"] = build.dotfiles_path
      ohai "Installing .Sloth"
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      To activate .Sloth in your zsh and bash shell, run:
        dot core loader --modify
      If you want to use .Sloth only in zsh or bash, see the help for know how:
        dot core loader --help

      Additionally, if you haven't done yet, you can create your custom dotfiles with:
        DOTFILES_PATH="/path/to/your/desired/dir" dot dotfiles create
    EOS
  end

  test do
    assert_match "dot " + version, shell_output("#{bin}/dot --version")
  end
end
__END__
--- a/bin/dot
+++ b/bin/dot
@@ -3,6 +3,8 @@

 set -euo pipefail

+SLOTH_PATH="HOMEBREW_PREFIX/opt/dot"
+
 # In Linux we can do this with readlink -f but will fail in macOS and BSD OS
 if [[ -z "${SLOTH_PATH:-${DOTLY_PATH:-}}" || ! -d "${SLOTH_PATH:-${DOTLY_PATH:-}}" ]]; then
   dot_path="$BASH_SOURCE"
