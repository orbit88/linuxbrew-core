class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.7.2.tar.gz"
  sha256 "481dc0589ecea67a8ea706bceff935bea6886b55062b485e8c0ef08f7e123281"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "45ac661839f2c8f39576289b1ddf2e821f722e97a000415cc46c2160d0de2668" => :catalina
    sha256 "1b3375697e30cc0f0ad46e7732e038b9541aa08e5cae4a7e3a14e3e1cdbc8609" => :mojave
    sha256 "19aed52b30358d70d438f20308fc4ea0140db45070c428b0c77f874e00f6ed23" => :high_sierra
    sha256 "33c6af173cf7389d323cc9b4620bd7346804fabde259f69f62923286ca224121" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --help 2>&1")

    output = shell_output("#{bin}/infracost --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
