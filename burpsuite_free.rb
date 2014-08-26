require "formula"

class BurpsuiteFree < Formula
  homepage "http://portswigger.net/burp/"
  version "1.6"
  url "http://portswigger.net/burp/burpsuite_free_v#{version}.jar", :using => :nounzip
  sha1 "017fdab9fb9dab2c214f0273b9f47195832824ae"

  def install
    jar_file = "burpsuite_free_v#{version}.jar"
    libexec.install jar_file
    bin.write_jar_script libexec/jar_file, "burp_suite"
  end
end
