class AtSpi2Atk < Formula
  desc "GTK+ module for bridging AT-SPI to ATK"
  homepage "http://www.linuxfoundation.org/en/Accessibility/ATK/AT-SPI/AT-SPI_on_D-Bus"
  url "https://github.com/GNOME/at-spi2-atk/archive/AT_SPI2_ATK_2_34_1.tar.gz"
  sha256 "d44e9b06125dbe346dce494e8baf637637622d1445d52ee52e122c366ad9aa2d"

  depends_on "at-spi2-core" => :build
  depends_on "cmake" => :build
  depends_on "git" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "dbus"
  depends_on "glib"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["atk"].opt_lib}/pkgconfig"
    ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["at-spi2-core"].opt_lib}/pkgconfig"
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
