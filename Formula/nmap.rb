class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.91.tar.bz2"
  sha256 "18cc4b5070511c51eb243cdd2b0b30ff9b2c4dc4544c6312f75ce3a67a593300"
  license :cannot_represent
  head "https://svn.nmap.org/nmap/"

  livecheck do
    url "https://nmap.org/dist/"
    regex(/href=.*?nmap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "5592fb8c2fe633a6339ee61901122c075a4b44c002e2887bddfb2c4b3aa2885f" => :catalina
    sha256 "ba808d31033d996488fdf56664de1cf424fc942db794ab7030d40a1caad93aa8" => :mojave
    sha256 "b9a5b9d54fb0af76b1ce343e94f142b3421309fbeb81078d73e41bc2a9d862ea" => :high_sierra
    sha256 "d05a8f02cea4a640932703a473f15f4f46bf44cc81da41c26fa369306894bbe3" => :x86_64_linux
  end

  depends_on "openssl@1.1"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  conflicts_with "ndiff", because: "both install `ndiff` binaries"

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --with-libpcre=included
      --with-liblua=included
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-nmap-update
      --disable-universal
      --without-zenmap
    ]

    system "./configure", *args
    system "make" # separate steps required otherwise the build fails
    system "make", "install"

    rm_f Dir[bin/"uninstall_*"] # Users should use brew uninstall.
  end

  test do
    system "#{bin}/nmap", "-p80,443", "google.com"
  end
end
