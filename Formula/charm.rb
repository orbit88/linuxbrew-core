class Charm < Formula
  desc "Tool for managing Juju Charms"
  homepage "https://github.com/juju/charmstore-client"
  url "https://github.com/juju/charmstore-client/archive/v2.5.1.tar.gz"
  sha256 "fee065673c3b9cf036b51d67672a8ede060652d803eef98fe490fbe8d83b2a7c"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2a4c9b953f6a54c51a171d819cfddc0655caf857ec72c3ec5136493f9296b24" => :catalina
    sha256 "58e3a054f6b6ff73184e1f2909ee58117bd023bc28e448af2d6fe2e82b192735" => :mojave
    sha256 "389d0723e4bcc34bc7747e66f7f721a36cf1ab63623ec23982d68ca2623e3f29" => :high_sierra
    sha256 "e149e78ec5ae240183c8f5c497f7eb5312c0e75a3fbba953b9a227b951eff34e" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/charm"
  end

  test do
    assert_match "show-plan           - show plan details", shell_output("#{bin}/charm 2>&1")

    assert_match "ERROR missing plan url", shell_output("#{bin}/charm show-plan 2>&1", 2)
  end
end
