class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.8.3.tar.gz"
  sha256 "31c837cb028a9e32e98c3d7071d80dbbaba7e6f35b3a33496aa39d5d8370d9ba"
  license "CC0-1.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b545b774d8b02c850f4ef476a4b0d0e14db13920765ec86c7778fea1affd1d84" => :catalina
    sha256 "2254dc738e8f62d5fe20467e2bbd93207ce2670628f644ed320b8640d59b51f0" => :mojave
    sha256 "40b53f4c712088b72fc5a44f1be1040f9a6223f2a66a5126bae20b30fc2edd57" => :high_sierra
    sha256 "320d4694ccf82a63970f03d6ca8346a90e700a67ca64eca7657277d0dd65db46" => :x86_64_linux
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system "#{bin}/just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
