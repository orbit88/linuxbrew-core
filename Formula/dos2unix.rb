class Dos2unix < Formula
  desc "Convert text between DOS, UNIX, and Mac formats"
  homepage "https://waterlan.home.xs4all.nl/dos2unix.html"
  url "https://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.4.2.tar.gz"
  mirror "https://fossies.org/linux/misc/dos2unix-7.4.2.tar.gz"
  sha256 "6035c58df6ea2832e868b599dfa0d60ad41ca3ecc8aa27822c4b7a9789d3ae01"
  license "BSD-2-Clause"

  livecheck do
    url "https://waterlan.home.xs4all.nl/dos2unix/"
    regex(/href=.*?dos2unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "eb14b6db2fbf8fa0f52b69aa33101e1eb04bf3d4ef5dae7234754046e4cd54a6" => :catalina
    sha256 "7a23d283d81cad13690d788c61117cbfe091282503077ad56bde83f026dd5097" => :mojave
    sha256 "98858938fe95e2453056d80c03c35396913a5c6902b2df00b618c884a4b51521" => :high_sierra
    sha256 "4777c53f5a7d5d58b8ccb6cadf06a27f4e3ab815b141af3331d93373b526e4bd" => :x86_64_linux
  end

  def install
    args = %W[
      prefix=#{prefix}
      CC=#{ENV.cc}
      CPP=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      ENABLE_NLS=
      install
    ]

    system "make", *args
  end

  test do
    # write a file with lf
    path = testpath/"test.txt"
    path.write "foo\nbar\n"

    # unix2mac: convert lf to cr
    system "#{bin}/unix2mac", path
    assert_equal "foo\rbar\r", path.read

    # mac2unix: convert cr to lf
    system "#{bin}/mac2unix", path
    assert_equal "foo\nbar\n", path.read

    # unix2dos: convert lf to cr+lf
    system "#{bin}/unix2dos", path
    assert_equal "foo\r\nbar\r\n", path.read

    # dos2unix: convert cr+lf to lf
    system "#{bin}/dos2unix", path
    assert_equal "foo\nbar\n", path.read
  end
end
