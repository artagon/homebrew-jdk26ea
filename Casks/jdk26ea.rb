cask "jdk26ea" do
  version "26-ea+20"
  name "JDK 26 EA"

  desc "Early-Access JDK 26"
  homepage "https://jdk.java.net/26/"

  # Installs to: /Library/Java/JavaVirtualMachines/jdk-26-ea.jdk
  # Supports: macOS ARM64 (Apple Silicon) and x64 (Intel)
  on_macos do
    on_arm do
      sha256 "dc75cdb507e47a66b0edc73d1cfc4a1c011078d5d0785c7660320d2e9c3e04d4"
      url "https://download.java.net/java/early_access/jdk26/20/GPL/openjdk-26-ea+20_macos-aarch64_bin.tar.gz"
    end

    on_intel do
      sha256 "5da4095d77d50eb19d8df7f0d128c16a6ff933d6cadc5cbf6fff1bf0530b6474"
      url "https://download.java.net/java/early_access/jdk26/20/GPL/openjdk-26-ea+20_macos-x64_bin.tar.gz"
    end
  end

  postflight do
    jdk_target = "/Library/Java/JavaVirtualMachines/jdk-26-ea.jdk"
    jdk_src = Dir["#{staged_path}/jdk-*.jdk"].first

    # Validate source exists before installation
    ohai "Installing JDK 26 EA to #{jdk_target}"
    unless jdk_src && File.directory?(jdk_src)
      opoo "JDK source directory not found in staged path"
      return
    end

    # Use ditto for secure, atomic copy with full metadata preservation
    system_command "/usr/bin/ditto",
                   args: ["--noqtn", jdk_src, jdk_target],
                   sudo: true
  end

  uninstall_postflight do
    jdk_path = "/Library/Java/JavaVirtualMachines/jdk-26-ea.jdk"
    if File.directory?(jdk_path)
      ohai "Removing JDK 26 EA from #{jdk_path}"
      system_command "/bin/rm",
                     args: ["-rf", jdk_path],
                     sudo: true
    end
  end
end
