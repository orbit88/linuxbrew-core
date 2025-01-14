require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-6.10.5.tgz"
  sha256 "3d6ac98e1e777f9f7a33a21a01f4f181a8d9252acb46003a0e850fb8c62bc918"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4ca44dc77bab71951af8df0ecd0c2ff4c42ced99da51489eb762dd5811930105" => :catalina
    sha256 "dc57fc139d909b7da4f0c9a0d3fd8f13aadbd1b41daa4036377f8ce236d5aad9" => :mojave
    sha256 "faf1d7553a95d40e7a7efb0115c811633f4b436eee9776eab9a41de70df47e20" => :high_sierra
    sha256 "d8358618db796d18c3c660cbd24d2fe0362f7725dc6db7616d239a5993291c2e" => :x86_64_linux
  end

  depends_on "node"
  depends_on "openjdk"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    assert_match "execution is complete", shell_output("#{bin}/jhipster info")
  end
end
