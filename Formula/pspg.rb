class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/3.1.5.tar.gz"
  sha256 "7ca7cd233726478ea276d6af83fcb9d8061d3e851aa533977310fdeebbc793e9"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "21e2efbe6cfaabe7e6b14f1457a61ffd2749b641ed3d3d252f849537ec4cae10" => :catalina
    sha256 "cb76982d14b5490e86d2664b02f127eb7848ed792a2eb61624fde9467411f6fd" => :mojave
    sha256 "51dba789c8fb09d7317ef41383405187188ac1b68099df0a9358bc75fbf2df38" => :high_sierra
    sha256 "2e473a9b905962c527ccc6621254e08f9f4f7b58020d0217512ded3d1dcb222d" => :x86_64_linux
  end

  depends_on "libpq"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Add the following line to your psql profile (e.g. ~/.psqlrc)
        \\setenv PAGER pspg
        \\pset border 2
        \\pset linestyle unicode
    EOS
  end

  test do
    assert_match "pspg-#{version}", shell_output("#{bin}/pspg --version")
  end
end
