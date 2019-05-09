require "language/node"

class Aglio < Formula
  desc "API Blueprint renderer"
  homepage "https://github.com/danielgtaylor/aglio/"

  depends_on "node"

  devel do
    url "https://github.com/Gasol/aglio/archive/e102cc7.tar.gz"
    version "e102cc7"
    sha256 "8e119f9f637f33b26bd566ed067a4c703994fafe9bc05b96733815769b77fd23"

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
