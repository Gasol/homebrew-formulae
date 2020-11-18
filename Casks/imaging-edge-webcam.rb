cask "imaging-edge-webcam" do
  version "1.0.00,4il6RXM99T"
  sha256 "942a650e11d88aa4d4668ab2b6d26075980a062bf2c9c7aa3654d3e0e4332c5b"

  # di.update.sony.net was verified as official when first introduced to the cask
  url "https://di.update.sony.net/NEX/#{version.after_comma}/IEW100_2010a.dmg"
  name "Imaging Edge Webcam"
  desc "Turns your SONY camera as a webcam"
  homepage "https://support.d-imaging.sony.co.jp/app/webcam/en/"

  depends_on macos: ">= :high_sierra"

  pkg "IEW_INST.pkg"

  uninstall pkgutil: "com.sony.Webcam",
            delete:  "/Library/CoreMediaIO/Plug-Ins/DAL/ImagingEdgeWebcam.plugin"
end
