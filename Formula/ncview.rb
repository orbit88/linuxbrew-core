class Ncview < Formula
  desc "Visual browser for netCDF format files"
  homepage "https://cirrus.ucsd.edu/ncview/"
  url "ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.1.8.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/ncview-2.1.8.tar.gz"
  sha256 "e8badc507b9b774801288d1c2d59eb79ab31b004df4858d0674ed0d87dfc91be"
  revision OS.mac? ? 3 : 5

  # The stable archive in the formula is fetched over FTP and the website for
  # the software hasn't been updated to list the latest release (it has been
  # years now). We're checking Debian for now because it's potentially better
  # than having no check at all.
  livecheck do
    url "https://deb.debian.org/debian/pool/main/n/ncview/"
    regex(/href=.*?ncview[._-]v?(\d+(?:\.\d+)+)(?:\+ds)?\.orig\.t/i)
  end

  bottle do
    sha256 "0a1594bb793189d1359cbd800e44d830cc9cf39b713d71128d41323b284e687a" => :catalina
    sha256 "d0b8e9fb871edf26633325c7309269689d0b4bd858f16a45527230dc16533abf" => :mojave
    sha256 "5511d243f73fd1a7867bb4dd0263afe215dd0e4e29ef77199efee5db08c2d207" => :high_sierra
    sha256 "6afa0fce06e390ff3a5b8646fb3f98691407bac5e14a313beaed71b141d200ff" => :x86_64_linux
  end

  depends_on "libpng"
  depends_on "netcdf"
  depends_on "udunits"
  depends_on :x11 if OS.mac?

  unless OS.mac?
    depends_on "libx11"
    depends_on "libxaw"
    depends_on "libxext"
    depends_on "libice"
    depends_on "libsm"
    depends_on "libxt"
  end

  def install
    # Bypass compiler check (which fails due to netcdf's nc-config being
    # confused by our clang shim)
    inreplace "configure",
      "if test x$CC_TEST_SAME != x$NETCDF_CC_TEST_SAME; then",
      "if false; then"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    man1.install "data/ncview.1"
  end

  test do
    assert_match "Ncview #{version}",
                 shell_output("#{bin}/ncview -c 2>&1")
  end
end
