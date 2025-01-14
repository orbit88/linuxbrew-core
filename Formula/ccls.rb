class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  url "https://github.com/MaskRay/ccls/archive/0.20201025.tar.gz"
  sha256 "1470797b2c1a466e2d8a069efd807aac6fefdef8a556e1edf2d44f370c949221"
  license "Apache-2.0"
  head "https://github.com/MaskRay/ccls.git"

  bottle do
    sha256 "9eeac4bcb801299d73e1d8a838b9b75701cef86506928082c5b63603949fad4e" => :catalina
    sha256 "eb2e73b77b5c3221fe9bc2b3330b9a2456b95558fc3b326fc29d35739467847d" => :mojave
    sha256 "578e24f878766fdcc3e024ddfcd6d124fbeaa79c79e32b89f6286f58d1213894" => :high_sierra
    sha256 "053cd63cec45fd12c4f8a4648ef41cf08a211c52da6ac6b68048bd0df5207464" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "llvm"
  depends_on macos: :high_sierra # C++ 17 is required
  depends_on "gcc@9" unless OS.mac? # C++17 is required

  fails_with gcc: "4"
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7" do
    version "7.1"
  end

  def install
    # https://github.com/Homebrew/brew/issues/6070
    ENV.remove %w[LDFLAGS LIBRARY_PATH HOMEBREW_LIBRARY_PATHS], "#{HOMEBREW_PREFIX}/lib" unless OS.mac?

    system "cmake", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"ccls", "-index=#{testpath}"
  end
end
