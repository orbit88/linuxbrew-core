class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://symas.com/lmdb/"
  url "https://git.openldap.org/openldap/openldap/-/archive/LMDB_0.9.27/openldap-LMDB_0.9.27.tar.bz2"
  sha256 "2746e429364bfa6f048f2980b8aab6ef461937e33e5c955d7b6242719b2527c4"
  license "OLDAP-2.8"
  version_scheme 1
  head "https://git.openldap.org/openldap/openldap.git", branch: "mdb.master"

  livecheck do
    url :head
    regex(/^LMDB[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "1495b5b154e77771ff450d1687c2afeec377db57498900b2bb692d23b4bd25b8" => :catalina
    sha256 "496f41bc0f050e5657a4ecc1409fccf8f2247521c3d3ebe16bdeb2007e0dbc71" => :mojave
    sha256 "36d2564ec79b8547154e706980fbc25d38575d424299216ec10adae598e6b1c9" => :high_sierra
    sha256 "dbcbb0fa6ecb93b3ef47f20be0e027ef9fb91a621d8b365a2775f8187413ce41" => :x86_64_linux
  end

  def install
    cd "libraries/liblmdb" do
      args = *("SOEXT=.dylib" if OS.mac?)
      system "make", *args
      system "make", "install", "prefix=#{prefix}", *args
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdb_dump -V")
  end
end
