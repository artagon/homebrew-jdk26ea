cask "jdk26valhalla" do
  version "23-"
  name "JDK 26 Valhalla EA"
  desc "Early-Access JDK 26 with Project Valhalla (value classes)"
  homepage "https://jdk.java.net/valhalla/"
  on_macos do
    on_arm do
      url "https://download.java.net/java/early_access/valhalla/1/openjdk-23-valhalla+1-90_linux-aarch64_bin.tar.gz"
      sha256 "5c5de0d2e9e6353c7690c23f56571ca368816c76daf860350d904645d3ac2da2"
    end
    on_intel do
      url "https://download.java.net/java/early_access/valhalla/1/openjdk-23-valhalla+1-90_linux-x64_bin.tar.gz"
      sha256 "5235afaf5ecc86f2237458cf40f8ed965939372f606edbd0fc46e1ee2e69f5f5"
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
