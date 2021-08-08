class Sloth < Formula
  depends_on "curl"
  depends_on "rust"
  depends_on "git-delta"
  depends_on "rust"
  depends_on "bash" => :recommended
  depends_on "zsh" => :recommended
  depends_on "git" => :recommended
  depends_on "python-yq" => :recommended

  version "3.0.5"
  desc "Lazy bash for lazy people. Have maintainable dotfiles with .Sloth. A Dotly fork."
  homepage "https://github.com/gtrabanco/.Sloth"
  url "https://github.com/gtrabanco/.Sloth/archive/refs/tags/#{version}.tar.gz"
  sha256 "1499175e3c988a3e4e9ce058a699ea9758d64d52b21a8cb06103c77941ab8086"
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
