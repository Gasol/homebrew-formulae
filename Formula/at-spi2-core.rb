# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
class AtSpi2Core < Formula
  desc "D-Bus accessibility specifications, library, and registration daemon"
  homepage "http://www.linuxfoundation.org/en/Accessibility/ATK/AT-SPI/AT-SPI_on_D-Bus"
  url "https://github.com/GNOME/at-spi2-core/archive/AT_SPI2_CORE_2_34_0.tar.gz"
  sha256 "1ec82280e203276f61cc554f47c5abe0bc6f58851dc304b9d293929eaa80d44d"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gobject-introspection" => :build
  depends_on "dbus"
  depends_on "glib"

  def install
		mkdir "build" do
			system "meson", "--prefix=#{prefix}", ".."
			system "ninja"
			system "ninja", "install"
		end
  end

  test do
    system "false"
  end
end
