class Xorgrgb < Formula
  desc "X.Org: color names database"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/app/rgb-1.0.6.tar.bz2"
  sha256 "bbca7c6aa59939b9f6a0fb9fff15dfd62176420ffd4ae30c8d92a6a125fbe6b0"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec1075868cfedeed6e68f844637fe8cbf1d978cacb6bedf6ca746a3a2a5e68f8" => :catalina
    sha256 "ab75e74585e880cdaa2a0383626440834dcf2ed164d8c556d12ca9e74ede9386" => :mojave
    sha256 "9035c5f64f471dcf32ab07e2321237fcab8a5fc3057cef3f29664db32222fc35" => :high_sierra
    sha256 "0fab3363c2e69d362c34706f051f19487f6a8b6bd7758f94e6d06f1f0fc770b8" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "gray100", shell_output("#{bin}/showrgb").chomp
  end
end
