class Dot < Formula
  version "3.0.9"
  desc "Lazy bash for lazy people. Have maintainable dotfiles with .Sloth. A Dotly fork."
  homepage "https://github.com/gtrabanco/.Sloth"
  url "https://api.github.com/repos/gtrabanco/.Sloth/tarball/v#{version}"
  sha256 "bfb0478e8224c144a3d2696bb23b158f042bdbab7648990e559a1bdde92d1266"
  head "https://github.com/gtrabanco/.Sloth.git", branch: "master", :using => :git
  license "MIT"

  option "dotfiles-path", "Provide where to place your dotfiles"
  option "no-init-as-repository", "Ignore the initialization of .Sloth installation as git repository"
  
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

  def install
    ENV["SLOTH_PATH"] = "#{prefix}"
    bin.install "bin/dot"
    prefix.install "bin"
    prefix.install "_raycast"
    prefix.install "dotfiles_template"
    prefix.install "migration"
    prefix.install "modules"
    prefix.install "scripts"
    prefix.install "shell"
    prefix.install "symlinks"
    prefix.install ".gitmodules"
    prefix.install "Makefile"

    if build.without? "no-init-as-repository"
      system "git", "init"
      system "git", "remote", "add", "origin", "https://github.com/gtrabanco/.Sloth"
      system "git", "config", "remote.origin.url", "https://github.com/gtrabanco/.Sloth"
      system "git", "config", "remote.origin.fetch", "+refs/heads/*:refs/remotes/origin/*"
      system "git", "fetch", "--all", "--tags", "--force"
      system "git", "remote", "set-head", "origin", "--auto"
      system "git", "clean", "-f", "-d"
      system "git", "pull", "--tags", "-s" "recursive", "-X", "theirs", "origin", "master"
      system "git", "reset", "--hard", "HEAD"
      system "git", "branch", "--set-upstream-to=origin/master", "master"
      system "git", "checkout", "--force", "v#{version}"
    end

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
