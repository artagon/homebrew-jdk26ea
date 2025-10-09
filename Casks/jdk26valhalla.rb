cask "jdk26valhalla" do
  version "26-ea+18"
  name "JDK 26 EA"
  desc "Early-Access JDK 26"
  homepage "https://jdk.java.net/26/"
  on_macos do
    on_arm do
      url "https://download.java.net/java/early_access/jdk26/18/GPL/openjdk-26-ea+18_macos-aarch64_bin.tar.gz"
      sha256 "4a74619f410602fe94225796b1cd7dd6bc914a2b6d9d76a1ae3934173dec85c3"
    end
    on_intel do
      url "https://download.java.net/java/early_access/jdk26/18/GPL/openjdk-26-ea+18_macos-x64_bin.tar.gz"
      sha256 "b6a8d8f6610fce87d04d7b61dbf1893a098a8d5c0eeb5790a0c8fdfda766af2e"
    end
  end
  postflight do
    jdk_target = "/Library/Java/JavaVirtualMachines/jdk-26-ea.jdk"
    jdk_src = Dir["#{staged_path}/jdk-*"].first

    # Detect rsync path based on OS
    rsync_path = if MacOS.version
                   "/usr/bin/rsync"
                 else
                   # Linux typically has rsync in /usr/bin
                   system("command -v rsync > /dev/null 2>&1") ? `which rsync`.strip : "/usr/bin/rsync"
                 end

    if jdk_src
      system_command "/bin/mkdir", args: ["-p", jdk_target], sudo: true
      system_command rsync_path, args: ["-a", jdk_src + "/", jdk_target + "/"], sudo: true
    end
  end
  uninstall_postflight do
    system_command "/bin/rm", args: ["-rf", "/Library/Java/JavaVirtualMachines/jdk-26-ea.jdk"], sudo: true
  end
end
