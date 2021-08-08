class Sloth < Formula
  depends_on "curl"
  depends_on "rust"
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
  depends_on "git" => :recommended
  depends_on "python3" => :recommended
  depends_on "python-yq" => :recommended
  depends_on "mas" => :recommended
  depends_on "gnutls" => :optional

  version "3.0.7"
  desc "Lazy bash for lazy people. Have maintainable dotfiles with .Sloth. A Dotly fork."
  homepage "https://github.com/gtrabanco/.Sloth"
  url "https://api.github.com/repos/gtrabanco/.Sloth/tarball/v#{version}"
  sha256 "1a077f486ddb77847e6ab4a39174bf32427423fa41a74400cb972f9a5500b741"
  license "MIT"

  def install
    ohai "Linking dot"
    bin.install "dot"
    ohai "Initilisation of .Sloth as repository"
    system("bin/dot", "core install --only-initilize-sloth")
    ohai "Create your DOTFILES_PATH with the command:"
    ohai " $ DOTFILES_PATH=\"${HOME}/.dotfiles\" dot dotfiles create"
    ohai "Use .Sloth loader by using the command:"
    ohai " $ dot dotfiles loader --modify"
    ohai "Restart your terminal to have .Sloth running"

    #ohai "Adding .Sloth to your \`.bashrc\` and \`.zshrc\` files"
    #system("bin/dot", "core loader --modify")
  end

  test do
    assert_match "dot " + version, shell_output("#{bin}/dot --version")
  end
end
