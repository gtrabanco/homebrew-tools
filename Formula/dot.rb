class Dot < Formula
  version "3.1.2"
  desc "Lazy bash for lazy people. Have maintainable dotfiles with .Sloth. A Dotly fork."
  homepage "https://github.com/gtrabanco/.Sloth"
  url "https://github.com/gtrabanco/.Sloth.git", :using => :git, tag: "v#{version}"
  mirror "https://api.github.com/repos/gtrabanco/.Sloth/tarball/v#{version}"
  sha256 "bd332af9ff84b3d546c5aef0635b188712b4590aa9f496e8fd9be8da9af763b0"
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
    bin.install "bin/up"
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

    patch do
      url "https://raw.githubusercontent.com/gtrabanco/homebrew-tools/HEAD/formula-patches/dot-v#{version}.diff"
      sha256 "c79f7b1438aa134f5753c2ddfa1053ae0c6b67232e339c189f51dea146c3f66e"
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

  test do
    assert_match "dot " + version, shell_output("#{bin}/dot --version")
  end
end
