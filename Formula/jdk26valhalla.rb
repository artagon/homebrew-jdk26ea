class Jdk26valhalla < Formula
  desc "Early-Access JDK 26 with Project Valhalla (value classes)"
  homepage "https://jdk.java.net/valhalla/"
  version "__VERSION__"
  on_macos do
    if Hardware::CPU.arm?
      url "__URL_MAC_ARM__"
      sha256 "__SHA_MAC_ARM__"
    else
      url "__URL_MAC_INTEL__"
      sha256 "__SHA_MAC_INTEL__"
    end
  end
  on_linux do
    url "__URL_LINUX_X64__"
    sha256 "__SHA_LINUX_X64__"
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
