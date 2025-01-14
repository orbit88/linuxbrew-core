class Ultralist < Formula
  desc "Simple GTD-style task management for the command-line"
  homepage "https://ultralist.io"
  url "https://github.com/ultralist/ultralist/archive/1.7.0.tar.gz"
  sha256 "d4a524c94c1ea4a748711a1187246ed1fd00eaaafd5b8153ad23b42d36485f79"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "529daa8fdf264f4f13f8f93d785095d4a803f94902772e25094415691bf7f83c" => :catalina
    sha256 "5bf8a9d39b953f0c24c8a1b978fab945f667a5f4e48c0d2729162f948f3b9118" => :mojave
    sha256 "eff4c2ac2bd4d1a4bfe6f0d2bcd92b4c572d17eaa047df909533d8f510f366a1" => :high_sierra
    sha256 "4ae5bd854437f1e9a3b2905bc8927f4aa18b2d3bc603b7b22f0ee0744e4722bb" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"ultralist", "init"
    assert_predicate testpath/".todos.json", :exist?
    add_task = shell_output("#{bin}/ultralist add learn the Tango")
    assert_match /Todo.* added/, add_task
  end
end
