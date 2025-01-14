class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/2.0.6.tar.gz"
  sha256 "9a2263246ffde5f950d49a51e46ddafea0ac95573e0a5a3a5f9194725fe561a4"
  license "GPL-3.0-or-later"
  head "https://github.com/rbsec/sslscan.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:-rbsec)?$/i)
  end

  bottle do
    cellar :any
    sha256 "dfae88a5af610e1ea5707fdd76b48b4c67f0ffbce46721399d97168ffaf29e91" => :catalina
    sha256 "8556ca9cab96ef319a398374cb761169846d53963097772477605084b2b09e0b" => :mojave
    sha256 "7ad72d0cffb03636e6cd67f2bdebf481a731481a1f274d2e472ff4950c1d53f0" => :high_sierra
    sha256 "dcbe78f65c5b492d9f35da9c85c3c041dfd2a09051b8e15d943f9e4204cadca6" => :x86_64_linux
  end

  depends_on "openssl@1.1"

  def install
    # use `libcrypto.dylib`/`libcrypto.a` built from `openssl@1.1`
    libcrypto = OS.mac? ? "libcrypto.dylib" : "libcrypto.a"
    inreplace "Makefile", "static: openssl/libcrypto.a",
                          "static: #{Formula["openssl@1.1"].opt_lib}/#{libcrypto}"

    system "make", "static"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "static", shell_output("#{bin}/sslscan --version")
    system "#{bin}/sslscan", "google.com"
  end
end
