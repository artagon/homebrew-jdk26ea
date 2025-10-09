class Jdk26valhalla < Formula
  desc "Early-Access JDK 26"
  homepage "https://jdk.java.net/26/"
  version "26-ea+18"
  on_macos do
    if Hardware::CPU.arm?
      url "https://download.java.net/java/early_access/jdk26/18/GPL/openjdk-26-ea+18_macos-aarch64_bin.tar.gz"
      sha256 "4a74619f410602fe94225796b1cd7dd6bc914a2b6d9d76a1ae3934173dec85c3"
    else
      url "https://download.java.net/java/early_access/jdk26/18/GPL/openjdk-26-ea+18_macos-x64_bin.tar.gz"
      sha256 "b6a8d8f6610fce87d04d7b61dbf1893a098a8d5c0eeb5790a0c8fdfda766af2e"
    end
  end
  on_linux do
    url "https://download.java.net/java/early_access/jdk26/18/GPL/openjdk-26-ea+18_linux-x64_bin.tar.gz"
    sha256 "efaa7c08b216ca30d5769c56a81337742b795188f8ab45532f711cd0fedd7971"
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
