class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/12/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v13.1/postgresql-13.1.tar.bz2"
  sha256 "12345c83b89aa29808568977f5200d6da00f88a035517f925293355432ffe61f"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/?C=M&O=A"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 "394a2065cf06312fe23f56978cecdd3adc7f73bb6b2a3b9949cb7f3fba364ea2" => :catalina
    sha256 "af4326fa978a2e4c61070e8ecb6c43ec22fff5a0320a86ceba52366bc2991183" => :mojave
    sha256 "47101f9b3f690bffef78b2b656583d43e1e91cb2d563abfbbaecff7040a5b097" => :high_sierra
    sha256 "244481cecdbfab3e50f818ff7a0b27598b727012bb030c525df8464677a797e9" => :x86_64_linux
  end

  keg_only "conflicts with postgres formula"

  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https://github.com/Homebrew/homebrew-core/issues/47494.
  depends_on "krb5"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "readline"
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-gssapi",
                          "--with-openssl",
                          "--libdir=#{opt_lib}",
                          "--includedir=#{opt_include}"
    dirs = %W[
      libdir=#{lib}
      includedir=#{include}
      pkgincludedir=#{include}/postgresql
      includedir_server=#{include}/postgresql/server
      includedir_internal=#{include}/postgresql/internal
    ]
    system "make"
    system "make", "-C", "src/bin", "install", *dirs
    system "make", "-C", "src/include", "install", *dirs
    system "make", "-C", "src/interfaces", "install", *dirs
    system "make", "-C", "src/common", "install", *dirs
    system "make", "-C", "src/port", "install", *dirs
    system "make", "-C", "doc", "install", *dirs
  end

  test do
    (testpath/"libpq.c").write <<~EOS
      #include <stdlib.h>
      #include <stdio.h>
      #include <libpq-fe.h>

      int main()
      {
          const char *conninfo;
          PGconn     *conn;

          conninfo = "dbname = postgres";

          conn = PQconnectdb(conninfo);

          if (PQstatus(conn) != CONNECTION_OK) // This should always fail
          {
              printf("Connection to database attempted and failed");
              PQfinish(conn);
              exit(0);
          }

          return 0;
        }
    EOS
    system ENV.cc, "libpq.c", "-L#{lib}", "-I#{include}", "-lpq", "-o", "libpqtest"
    ENV.prepend_path "LD_LIBRARY_PATH", lib unless OS.mac?
    assert_equal "Connection to database attempted and failed", shell_output("./libpqtest")
  end
end
