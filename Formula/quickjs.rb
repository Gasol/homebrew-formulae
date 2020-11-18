class Quickjs < Formula
  desc "An embeddable Javascript engine"
  homepage "https://bellard.org/quickjs/"
  url "https://bellard.org/quickjs/quickjs-2019-07-09.tar.xz"
  sha256 "350c1cd9dd318ad75e15c9991121c80b85c2ef873716a8900f811554017cd564"

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "qjs", "-e", "console.log('test')"
  end
end
