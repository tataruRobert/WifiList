//
//  MyTextField.swift
//  WiFiList
//
//  Created by Tataru Robert on 18/10/2020.
//

import Foundation
import UIKit

class MyTextField: UITextField {
    let revealButton = UIButton(type: .system)

    var needsRevealButton: Bool = false {
        didSet {
            updateRevealButtonImage()
            configureRevealButton()
        }
    }

    var isRevealed: Bool = false {
        didSet {
            updateRevealButtonImage()
        }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(isSecureEntry: Bool, placeholder: String, autocorrectionType: UITextAutocorrectionType, autocapitalizationType: UITextAutocapitalizationType, returnType: UIReturnKeyType, needsRevealButton: Bool = false) {
        super.init(frame: .zero)
        isSecureTextEntry = isSecureEntry
        self.autocorrectionType = autocorrectionType
        self.placeholder = placeholder
        self.autocapitalizationType = autocapitalizationType
        self.returnKeyType = returnType
        self.needsRevealButton = needsRevealButton
        configure()
        if isSecureEntry {
            updateRevealButtonImage()
            configureRevealButton()
        }
    }
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        tintColor = .myGlobalTint
        textColor = .label
        font = UIFont.preferredFont(forTextStyle: .title3)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        clearButtonMode = .whileEditing
        borderStyle = .roundedRect
    }


    private func configureRevealButton() {
        addSubview(revealButton)
        revealButton.translatesAutoresizingMaskIntoConstraints = false
        revealButton.tintColor = .myGlobalTint
        rightView = revealButton
        rightViewMode = .always
        revealButton.addTarget(self, action: #selector(toggleSecureEntry(_:)), for: .touchUpInside)
    }


    private func updateRevealButtonImage() {
        let config = UIImage.SymbolConfiguration(pointSize: 12)
        let image = isSecureTextEntry ? UIImage(systemName: "eye.slash", withConfiguration: config) : UIImage(systemName: "eye", withConfiguration: config)
        revealButton.setImage(image, for: .normal)
    }


    @objc private func toggleSecureEntry(_ sender: UIButton) {
        isSecureTextEntry.toggle()
        updateRevealButtonImage()
    }
}
