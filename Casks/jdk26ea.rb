cask "jdk26ea" do
  version "26-ea+20,20"
  name "JDK 26 EA"
  desc "Early-Access JDK 26"
  homepage "https://jdk.java.net/26/"

  on_macos do
    arch arm: "aarch64", intel: "x64"

    # Installs to: /Library/Java/JavaVirtualMachines/jdk-26-ea.jdk
    # Supports: macOS ARM64 (Apple Silicon) and x64 (Intel)
    sha256 arm:   "dc75cdb507e47a66b0edc73d1cfc4a1c011078d5d0785c7660320d2e9c3e04d4",
           intel: "5da4095d77d50eb19d8df7f0d128c16a6ff933d6cadc5cbf6fff1bf0530b6474"

    url "https://download.java.net/java/early_access/jdk26/#{version.csv.second}/GPL/openjdk-#{version.csv.first}_macos-#{arch}_bin.tar.gz"
  end

  postflight do
    require "pathname"

    staged_root = staged_path.realpath
    candidates = Dir["#{staged_root}/jdk-*.jdk"]
    odie "Expected exactly one JDK bundle in #{staged_root}, found #{candidates.length}" if candidates.length != 1

    jdk_src = Pathname(candidates.first).realpath
    odie "Staged JDK bundle #{jdk_src} is not a directory" unless jdk_src.directory?
    odie "Resolved JDK path escapes staging area" unless jdk_src.to_s.start_with?(staged_root.to_s)

    jdk_target = Pathname("/Library/Java/JavaVirtualMachines/jdk-26-ea.jdk")
    if jdk_target.exist?
      ohai "Removing existing JDK at #{jdk_target}"
      removal = system_command "/bin/rm",
                               args: ["-rf", jdk_target.to_s],
                               sudo: true
      odie "Failed to remove existing JDK at #{jdk_target}" unless removal.success?
    end

    ohai "Installing JDK 26 EA to #{jdk_target}"
    install = system_command "/usr/bin/ditto",
                             args: ["--noqtn", jdk_src.to_s, jdk_target.to_s],
                             sudo: true
    odie "Failed to install JDK to #{jdk_target}" unless install.success?
  end

  uninstall delete: "/Library/Java/JavaVirtualMachines/jdk-26-ea.jdk"
end
