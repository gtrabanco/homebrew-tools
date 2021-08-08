class Sloth < Formula
  depends_on "curl"
  depends_on "rust"
  depends_on "git-delta"
  depends_on "rust"
  depends_on "bash" => :recommended
  depends_on "zsh" => :recommended
  depends_on "git" => :recommended
  depends_on "python-yq" => :recommended

  version "3.0.6"
  desc "Lazy bash for lazy people. Have maintainable dotfiles with .Sloth. A Dotly fork."
  homepage "https://github.com/gtrabanco/.Sloth"
  url "https://github.com/gtrabanco/.Sloth/archive/refs/tags/#{version}.tar.gz"
  sha256 "af64e76804fda5b41da6e6d431f2b42fc88b84e616f985781121c0c26b66f2f7"
  license "MIT"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    # Remove unrecognized options if warned by configure
    # https://rubydoc.brew.sh/Formula.html#std_configure_args-instance_method
    # system "./configure", *std_configure_args, "--disable-silent-rules"
    # system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    bin.install "dot"
    system "bin/dot core install"
  end

  test do
    assert_match "dot " + version, shell_output("#{bin}/dot --version")
  end
end
