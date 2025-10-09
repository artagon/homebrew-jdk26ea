cask "jdk26valhalla" do
  version "23-valhalla+1-90"
  name "JDK 26 Valhalla EA"
  desc "Early-Access JDK 26 with Project Valhalla (value classes)"
  homepage "https://jdk.java.net/valhalla/"
  on_macos do
    on_arm do
      url "https://download.java.net/java/early_access/valhalla/1/openjdk-23-valhalla+1-90_macos-aarch64_bin.tar.gz"
      sha256 "e7c490e33056a6dabb06e69ec63d42dc7eab7134e4e5cea0df41dbf1cfb63e2e"
    end
    on_intel do
      url "https://download.java.net/java/early_access/valhalla/1/openjdk-23-valhalla+1-90_macos-x64_bin.tar.gz"
      sha256 "9cc2e89745f95f3d9f7d16e8a7285e9de1cee03f85e3d8e7a5ae86d44f91e3ef"
    end
  end
  postflight do
    jdk_target = "/Library/Java/JavaVirtualMachines/jdk-26-ea.jdk"
    jdk_src = Dir["#{staged_path}/jdk-*"].first
    if jdk_src
      system_command "/bin/mkdir", args: ["-p", jdk_target], sudo: true
      system_command "/bin/rsync", args: ["-a", jdk_src + "/", jdk_target + "/"], sudo: true
    end
  end
  uninstall_postflight do
    system_command "/bin/rm", args: ["-rf", "/Library/Java/JavaVirtualMachines/jdk-26-ea.jdk"], sudo: true
  end
end
