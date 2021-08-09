class Sloth < Formula
  version "3.0.8"
  desc "Lazy bash for lazy people. Have maintainable dotfiles with .Sloth. A Dotly fork."
  homepage "https://github.com/gtrabanco/.Sloth"
  url "https://api.github.com/repos/gtrabanco/.Sloth/tarball/v#{version}"
  sha256 "afbd281a2587a77837b839b3da0a231d21a1ffbbaa8ef586e6c6f6b54531fb53"
  head "https://github.com/gtrabanco/.Sloth.git", branch: "master", :using => :git
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

    if build.with? "dotfiles-path"
      ohai "Installing .Sloth"
      system "make", "install"
    end
    
    if build.without? "dotfiles-path"
      ohai "Initilising .Sloth as repository"
      system "make", "init"
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
