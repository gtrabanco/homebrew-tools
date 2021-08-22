class Dot < Formula
  version "3.1.1"
  desc "Lazy bash for lazy people. Have maintainable dotfiles with .Sloth. A Dotly fork."
  homepage "https://github.com/gtrabanco/.Sloth"
  url "https://github.com/gtrabanco/.Sloth.git", :using => :git, tag: "v#{version}"
  mirror "https://api.github.com/repos/gtrabanco/.Sloth/tarball/v#{version}"
  sha256 "4c01ab8bc0949bf9281338169fba9244f6f9aa59c42d13e7f665e666baccd047"
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
    ENV["INSTALL_PREFIX"] = "#{HOMEBREW_PREFIX}"
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

    # prefix.install Dir["*!bin"]

    cd prefix do
      rm_rf "scripts/core/version"
      ln_sf "scripts/core", "scripts/self"
    end

    #bash_completion/"dot" "shell/bash/completions/_dot"

    if build.with? "dotfiles-path"
      ENV["DOTFILES_PATH"] = build.dotfiles_path
      ohai "Installing .Sloth"
      system "make", "install"
    else
      ENV["DOTFILES_PATH"] = "#{prefix}/dotfiles_template"
      system "make", "standalone-install"
    end
  end

  def caveats
    <<~EOS
      Additionally, if you haven't done yet, you can create your custom dotfiles with:
        DOTFILES_PATH="${HOME}/.dotfiles" dot dotfiles create
      After that activate .Sloth loader for your zsh & bash shell with:
        dot core loader --modify

        Probably you should uncomment DOTFILES_PATH variable in ~/.bashrc and ~/.zshenv files.
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
 
+export SLOTH_PATH="HOMEBREW_PREFIX/opt/dot"
+export DOTFILES_PATH="${SLOTH_PATH}/dotfiles_template"
+export HOMEBREW_SLOTH=true
+
 # In Linux we can do this with readlink -f but will fail in macOS and BSD OS
 if [[ -z "${SLOTH_PATH:-${DOTLY_PATH:-}}" || ! -d "${SLOTH_PATH:-${DOTLY_PATH:-}}" ]]; then
   if ! command -vp realpath &> /dev/null; then
