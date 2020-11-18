class JarDownloadStrategy < NoUnzipCurlDownloadStrategy
  def ext
    ".jar"
  end
end

class BurpsuiteCommunity < Formula
  desc "Advanced set of tools for testing web security"
  homepage "http://portswigger.net/burp/"
  url "https://portswigger.net/Burp/Releases/Download?productId=100&type=Jar&version=2020.9.1", using: JarDownloadStrategy
  version "2020.9.1"
  sha256 "6406c5ef0f49d868c06625507d00849dcdaa5ffe39b83328b0151238191d2ade"

  depends_on "openjdk"

  def install
    jar_file = "#{name}_v#{version}.jar"

    libexec.install jar_file
    bin.write_jar_script libexec/jar_file, "burp_suite"
  end

  test do
    version_output = shell_output("#{bin}/burp_suite --version 2>&1")
    assert_match(/2020\.9\.1-\d+ Burp Suite Community Edition/, version_output)
  end
end
