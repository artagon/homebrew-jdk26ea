cask "jdk26valhalla" do
  version "__VERSION__"
  name "JDK 26 Valhalla EA"
  desc "Early-Access JDK 26 with Project Valhalla (value classes)"
  homepage "https://jdk.java.net/valhalla/"
  on_macos do
    on_arm do
      url "__URL_MAC_ARM__"
      sha256 "__SHA_MAC_ARM__"
    end
    on_intel do
      url "__URL_MAC_INTEL__"
      sha256 "__SHA_MAC_INTEL__"
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
