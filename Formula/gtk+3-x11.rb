class Gtkx3X11 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk+/3.24/gtk+-3.24.12.tar.xz"
  sha256 "1384eba5614fed160044ae0d32369e3df7b4f517b03f4b1f24d383e528f4be83"
  revision 1

  bottle do
    sha256 "4ccac8c178075606f275a258c215d6b805e184335306d9a78cd4b7c7fbf4a13b" => :catalina
    sha256 "5198ebdb8d360fbc1d70b980f99b189348db793aa7a694c79cd7445f2ed7e6dd" => :mojave
    sha256 "23682d476062f2ca5324f2ba584f44712b4d3264c1c9b70d452fead937a77346" => :high_sierra
  end

  depends_on "at-spi2-atk" => :build
  depends_on "at-spi2-core" => :build
  depends_on "dbus" => :build
  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gsettings-desktop-schemas"
  depends_on "hicolor-icon-theme"
  depends_on "libepoxy-x11"
  depends_on "pango"
  depends_on :x11

  conflicts_with "gtk+3"

  patch do
    url "https://gitlab.gnome.org/GNOME/gtk/commit/fa07007389c9662b654680464cf88d8894e4e64d.diff"
    sha256 "995173a076e6984789e862e81b332fa4b3c5794c113251c66b6d8708a1614d8a"
  end

  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      -Dx11_backend=true
      -Dquartz_backend=false
      -Dgtk_doc=false
      -Dman=true
      -Dintrospection=true
    ]

    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["glib"].opt_lib}/pkgconfig"

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    # Prevent a conflict between this and Gtk+2
    mv bin/"gtk-update-icon-cache", bin/"gtk3-update-icon-cache"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system bin/"gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    system "#{bin}/gtk-query-immodules-3.0 > #{HOMEBREW_PREFIX}/lib/gtk-3.0/3.0.0/immodules.cache"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        gtk_disable_setlocale();
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo-xlib"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    harfbuzz = Formula["harfbuzz"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}
      -I#{include}/gtk-3.0
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-3
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
__END__
diff --git a/meson.build b/meson.build
index ba93dcc..48840c9 100644
--- a/meson.build
+++ b/meson.build
@@ -152,7 +152,6 @@ os_unix = not os_win32
 
 if os_darwin
   wayland_enabled = false
-  x11_enabled = false
 else
   quartz_enabled = false
 endif
diff --git a/gdk/x11/gdkapplaunchcontext-x11.c b/gdk/x11/gdkapplaunchcontext-x11.c
index 8051229..bb2622c 100644
--- a/gdk/x11/gdkapplaunchcontext-x11.c
+++ b/gdk/x11/gdkapplaunchcontext-x11.c
@@ -27,7 +27,9 @@
 #include "gdkprivate-x11.h"
 
 #include <glib.h>
+#if defined(HAVE_GIO_UNIX) && !defined(__APPLE__)
 #include <gio/gdesktopappinfo.h>
+#endif
 
 #include <string.h>
 #include <unistd.h>
@@ -352,10 +354,14 @@ gdk_x11_app_launch_context_get_startup_notify_id (GAppLaunchContext *context,
   else
     workspace_str = NULL;
 
+#if defined(HAVE_GIO_UNIX) && !defined(__APPLE__)
   if (G_IS_DESKTOP_APP_INFO (info))
     application_id = g_desktop_app_info_get_filename (G_DESKTOP_APP_INFO (info));
   else
     application_id = NULL;
+#else
+  #warning Please add support for creating AppInfo from id for your OS
+#endif
 
   startup_id = g_strdup_printf ("%s-%lu-%s-%s-%d_TIME%lu",
                                 g_get_prgname (),
