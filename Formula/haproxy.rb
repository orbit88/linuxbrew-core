class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.3/src/haproxy-2.3.0.tar.gz"
  sha256 "08badc59e037883f788f2c8f3358fa3e351aeaee826fd8a719f1e6252aff78fc"

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "a61445323cd92c223842bf14df474b0e0850281415b9bb6b42bf9f470fd66d7b" => :catalina
    sha256 "424ad65db3ede0866a8caf50faf4af2277dfd50126b09ca1287f7f06e226592e" => :mojave
    sha256 "b761d262408f70b715ae13090cd7672e30cd11afcb8279ad5b712219794f3dd8" => :high_sierra
    sha256 "91a71cba5de4caf55f33813678cb5dea9fcf589b849a502619f31c67f8f47e97" => :x86_64_linux
  end

  depends_on "openssl@1.1"
  depends_on "pcre"

  def install
    args = %W[
      TARGET=#{OS.mac? ? "generic" : "linux-glibc"}
      USE_POLL=1
      USE_PCRE=1
      USE_OPENSSL=1
      USE_THREAD=1
      USE_ZLIB=1
      ADDLIB=-lcrypto
    ]
    args << "USE_KQUEUE=1" if OS.mac?

    # We build generic since the Makefile.osx doesn't appear to work
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", *args
    man1.install "doc/haproxy.1"
    bin.install "haproxy"
  end

  plist_options manual: "haproxy -f #{HOMEBREW_PREFIX}/etc/haproxy.cfg"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>KeepAlive</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/haproxy</string>
            <string>-f</string>
            <string>#{etc}/haproxy.cfg</string>
          </array>
          <key>StandardErrorPath</key>
          <string>#{var}/log/haproxy.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/haproxy.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    system bin/"haproxy", "-v"
  end
end
