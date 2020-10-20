//
//  WifiImageView.swift
//  WiFiList
//
//  Created by Tataru Robert on 20/10/2020.
//

import Foundation
import UIKit

class WiFiImageView: UIImageView {

    let placeholderImage = UIImage(systemName: "qrcode")!

    private let wifi: Wifi

    override init(frame: CGRect) {
        fatalError("Use init(frame with wifi)")
    }

    init(frame: CGRect = .zero, with wifi: Wifi) {
        self.wifi = wifi
        super.init(frame: frame)
        configure()
        configureQRCode()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureQRCode()
    }

    private func configure() {
        layer.cornerCurve = .continuous
        layer.cornerRadius = 12
        clipsToBounds = true
        contentMode = .scaleAspectFit
        image = placeholderImage
        backgroundColor = .myBackground
        translatesAutoresizingMaskIntoConstraints = false
    }

    func configureQRCode() {

        let qrData = configureWifiCodeString()
        let qrGen = generateQRCode(from: qrData)
        self.image = qrGen
    }

    func generateQRCode(from string: String) -> UIImage? {
        let myString = string
        // Get data from the string
        let data = myString.data(using: String.Encoding.ascii)
        // Get a QR CIFilter
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil}
        // Input the data
        qrFilter.setValue(data, forKey: "inputMessage")
        // Get the output image
        guard let qrImage = qrFilter.outputImage else { return nil }
        // Scale the image
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)

        // Create the filter
        guard let colorInvertFilter = CIFilter(name: "CIColorInvert") else { return nil}
        // Set the input image to what we generated above
        colorInvertFilter.setValue(scaledQrImage, forKey: "inputImage")
        // Get the output CIImage
        guard let outputInvertedImage = colorInvertFilter.outputImage else { return nil}

        // Create the filter
        guard let maskToAlphaFilter = CIFilter(name: "CIMaskToAlpha") else { return nil}
        // Set the input image to the colorInvertFilter output
        maskToAlphaFilter.setValue(outputInvertedImage, forKey: "inputImage")
        // Get the output CIImage
        guard let outputCIImage = maskToAlphaFilter.outputImage else { return nil}
        

        // Do some processing to get the UIImage
        let context = CIContext()
        guard let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return nil}
        let processedImage = UIImage(cgImage: cgImage)
        let image = UIImageView(image: processedImage)
        image.tintImage(color: .myGlobalTint)
        return image.image
    }

    private func configureWifiCodeString() -> String {
        let pass =  wifi.password ?? "nopass"
        let network = wifi.networkName ?? "NoName"

        if pass == "nopass" {
            return #"WIFI:S:"\#(network)";;"#
        } else {
            return #"WIFI:T:WPA;S:\#(network);P:\#(pass );;"#
        }
    }
    
   
}

extension UIImageView {
    func tintImage(color: UIColor) {
        image = image?.withTintColor(color)
    }
}

