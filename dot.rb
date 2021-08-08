class Dot < Formula
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
  depends_on "mas" => :recommended
  depends_on "gnutls" => :optional

  version "3.0.8"
  desc "Lazy bash for lazy people. Have maintainable dotfiles with .Sloth. A Dotly fork."
  homepage "https://github.com/gtrabanco/.Sloth"
  url "https://api.github.com/repos/gtrabanco/.Sloth/tarball/v#{version}"
  sha256 "52c42823f0753ba947181c8b0ca83744875f3fe22d043051ace794467d4a8bae"
  head "https://github.com/gtrabanco/.Sloth.git", branch: "master", :using => :git
  license "MIT"

  option "dotfiles-path", "Provide where to place your dotfiles"

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

    if build.with? "dotfiles-path"
      ohai "Installing .Sloth"
      system "make", "install"
    end
    
    if build.without? "dotfiles-path"
      ohai "Initilising .Sloth as repository"
      system "make init"
    end
  end

  test do
    assert_match "dot " + version, shell_output("#{bin}/dot --version")
  end
end
