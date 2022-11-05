class Bkcrack < Formula
  desc "Crack legacy zip encryption with Biham and Kocher's known plaintext attack"
  homepage "https://github.com/kimci86/bkcrack"
  url "https://github.com/kimci86/bkcrack/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "ad33a72be3a6a0d29813cbb5f5837281f274cb3e13a534202afccd2c623329d0"
  license "Zlib"
  head "https://github.com/kimci86/bkcrack.git", branch: "master"

  bottle do
    root_url "https://github.com/LoSunny/homebrew-tap-bk/releases/download/bkcrack-1.5.0"
    sha256 cellar: :any,                 monterey:     "db72fd01f6e970d8bb948c460a1446b5a41a21996cfbaed4d2340d39f9ad4295"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f363eca062d0f6735380e19d020e374bfcf5d09d23b598579e305b6ee0eb4e2a"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :optional # For the tools provided

  on_macos do
    depends_on "libomp" => :build if Hardware::CPU.arm?
    depends_on "libomp" if Hardware::CPU.intel?
  end

  on_linux do
    depends_on "libomp" => :build
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_PREFIX=install", *std_cmake_args
    system "cmake", "--build", "build", "--config", "Release"
    system "cmake", "--build", "build", "--config", "Release", "--target", "install"

    bin.install "build/src/bkcrack"
  end

  test do
    ENV.delete "GITHUB_TOKEN"
    assert_match(/bkcrack 1\.5\.0 - 2022-07-07/, shell_output(bin/"bkcrack", 1))
  end
end
