require "language/node"

class Aglio < Formula
  desc "API Blueprint renderer"
  homepage "https://github.com/danielgtaylor/aglio/"

  depends_on "node"

  devel do
    url "https://github.com/Gasol/aglio/archive/333da5.tar.gz"
    version "333da5"
    sha256 "7952eccf8ee89a2a05e6a89160d855f377777132a5637782db369b84e4a35d64"

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
