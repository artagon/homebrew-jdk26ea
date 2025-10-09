class Jdk26valhalla < Formula
  desc "Early-Access JDK 26 with Project Valhalla (value classes)"
  homepage "https://jdk.java.net/valhalla/"
  version "23-valhalla+1-90"
  on_macos do
    if Hardware::CPU.arm?
      url "https://download.java.net/java/early_access/valhalla/1/openjdk-23-valhalla+1-90_macos-aarch64_bin.tar.gz"
      sha256 "e7c490e33056a6dabb06e69ec63d42dc7eab7134e4e5cea0df41dbf1cfb63e2e"
    else
      url "https://download.java.net/java/early_access/valhalla/1/openjdk-23-valhalla+1-90_macos-x64_bin.tar.gz"
      sha256 "9cc2e89745f95f3d9f7d16e8a7285e9de1cee03f85e3d8e7a5ae86d44f91e3ef"
    end
  end
  on_linux do
    url "https://download.java.net/java/early_access/valhalla/1/openjdk-23-valhalla+1-90_linux-x64_bin.tar.gz"
    sha256 "5235afaf5ecc86f2237458cf40f8ed965939372f606edbd0fc46e1ee2e69f5f5"
  end
  def install
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
  test do
    (testpath/"Hello.java").write "class Hello{public static void main(String[]a){System.out.println("hi");}}"
    system "#{bin}/javac","--enable-preview","--release","26","Hello.java"
    assert_match(/26|26-ea/, shell_output("#{bin}/java --enable-preview Hello"))
  end
end
