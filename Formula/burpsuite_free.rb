require "formula"

class JarDownloadStrategy < NoUnzipCurlDownloadStrategy
  def ext
    ".jar"
  end
end

class BurpsuiteFree < Formula
  homepage "http://portswigger.net/burp/"
  version "1.7.10"
  url "https://portswigger.net/Burp/Releases/Download?productId=100&type=Jar&version=#{version}",
	  :using => JarDownloadStrategy
  sha256 "9f609d14d474f43c9261c920c4a868278cbac119fcee62a328274e093738378d"

  def install
    jar_file = "burpsuite_free-#{version}.jar"

    libexec.install cached_download
    bin.write_jar_script libexec/jar_file, "burp_suite"
  end
end
