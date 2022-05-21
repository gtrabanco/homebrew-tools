class Sloth < Formula
  revision 0
  version "4.2.2"
  desc "Lazy bash for lazy people. Have maintainable dotfiles with .Sloth. A Dotly fork."
  homepage "https://github.com/gtrabanco/.Sloth"
  url "https://github.com/gtrabanco/.Sloth.git", :using => :git, tag: "v#{version}"
  mirror "https://api.github.com/repos/gtrabanco/.Sloth/tarball/v#{version}"
  sha256 "abe5c4df87abb16c46b3d75e53f7677404f1558bf4f753fa30fb92412b0fca4b"
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
  depends_on "dotbot"
  depends_on "make" => :recommended
  depends_on "gnu-sed" => :recommended
  depends_on "gnu-tar" => :recommended
  depends_on "gnu-which" => :recommended
  depends_on "gawk" => :recommended
  depends_on "grep" => :recommended
  depends_on "bash" => :recommended
  depends_on "bash-completion@2" => :recommended
  depends_on "zsh" => :recommended
  depends_on "python3" => :recommended
  depends_on "python-yq" => :recommended
  depends_on "gnutls" => :optional

  on_linux do
    depends_on "xclip" => :recommended
  end

  on_macos do
    depends_on "zsh-completions" => :recommended
    depends_on "mas" => :recommended
  end

  def install
    ENV["SLOTH_PATH"] = "#{prefix}"
    ENV["INSTALL_PREFIX"] = "#{HOMEBREW_PREFIX}"
    bin.install "bin/dot"
    bin.install "bin/$"
    bin.install "bin/up"
    bin.install "bin/sloth"
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

    cd prefix do
      rm_rf "scripts/core/version"
      ln_sf "scripts/core", "scripts/self"
    end

    if build.with? "dotfiles-path"
      ENV["DOTFILES_PATH"] = build.dotfiles_path
      ohai "Installing .Sloth"
      system "make", "install"
    else
      ENV["DOTFILES_PATH"] = "#{prefix}/dotfiles_template"
      ohai "Installing .Sloth with .Dotfiles"
      system "make", "standalone-install"
    end

    patch do
      url "https://raw.githubusercontent.com/gtrabanco/homebrew-tools/HEAD/formula-patches/dot-v#{version}.diff"
      sha256 "0abc6db4cc2f77ee7e839956bbca753ff67b4c6a4297d514341a438d4228eed2"
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
    assert_match ".Sloth v" + version, shell_output("#{bin}/dot --version")

    assert_match " > Package named gtrabanco/tools/dot was installed with brew", shell_output("#{bin}/dot package which gtrabanco/tools/dot")
  end
end
