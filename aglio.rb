require "language/node"

class Aglio < Formula
  desc "API Blueprint renderer"
  homepage "https://github.com/danielgtaylor/aglio/"

  depends_on "node"

  devel do
    url "https://github.com/Gasol/aglio/archive/0c0b309.tar.gz"
    version "0c0b309"
    sha256 "f5b8a5a79becc43892cb73ff5a3e905f571197906bd0b13bf19a004e0de2b771"

  end

  def install
    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run-script", "prepare"
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/aglio.js" => "aglio"
  end

  test do
    system "false"
  end
end
