//
//  MyTextFieldView.swift
//  WiFiList
//
//  Created by Tataru Robert on 18/10/2020.
//

import UIKit

func configure<T>(_ object: T, using closure: (inout T) -> Void) -> T {
    var object = object
    closure(&object)
    return object
}

class MyTextFieldView: UIView, UITextFieldDelegate {

    var labelText: String {
        get { textField.text ?? "" }
        set { textField.text = newValue }
    }

    var color: UIColor = .secondaryLabel

    private let border = configure(CALayer()) {
        $0.borderColor = UIColor.myBorderColor.cgColor
        $0.borderWidth = 1
        $0.cornerRadius = 4
    }

    let textField = UITextField()
    let label = MyPlaceholderLabel(textAlignment: .center, fontSize: 10)

    let activeColorCG = UIColor.myActiveBorderColor.cgColor
    let inactiveColorCG = UIColor.myBorderColor.cgColor
    let activeColor = UIColor.myActiveBorderColor
    let inactiveColor = UIColor.label.withAlphaComponent(0.7)

    let padding: CGFloat = 8

    let revealButton = UIButton(type: .system)

    var needsRevealButton = false {
        didSet {
            updateRevealButtonImage()
            configureRevealButton()
        }
    }

    var isRevealed = false {
        didSet {
            updateRevealButtonImage()
        }
    }

    var isActive = false


    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configureCointainer()
        configureTextField()
        configureLabel()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    init(isSecureEntry: Bool,
         placeholder: String,
         autocorrectionType: UITextAutocorrectionType,
         autocapitalizationType: UITextAutocapitalizationType,
         returnType: UIReturnKeyType,
         needsRevealButton: Bool = false) {

        super.init(frame: .zero)
        textField.isSecureTextEntry = isSecureEntry
        textField.autocorrectionType = autocorrectionType
        textField.autocapitalizationType = autocapitalizationType
        textField.returnKeyType = returnType
        if isSecureEntry {
            updateRevealButtonImage()
            configureRevealButton()
        }
        label.text = placeholder
        configureCointainer()
        configureTextField()
        configureLabel()
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        // Calling setActive here to update changes if user toggles dark mode
        setActiveColor(isActive)
        border.frame = bounds
        //border.mask(withRect: label.frame.insetBy(dx: -3, dy: 0), inverse: true)
        border.mask(withRect: label.frame.insetBy(dx: -3, dy: 0), inverse: true)

        
    }


    private func configureCointainer() {
        layer.addSublayer(border)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        clipsToBounds = false
        layer.cornerRadius = 6
        layer.cornerCurve = .continuous
    }

    #warning("Place textField and button in stackview and make sure to set priority and compression resistence on eye button")
    private func configureTextField() {
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false

        textField.addTarget(self, action: #selector(editingBegan(_:)), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(editingFinished(_:)), for: .editingDidEnd)

        textField.textColor = .label
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.adjustsFontSizeToFitWidth = true
        textField.keyboardType = .asciiCapable
        textField.minimumFontSize = 12

        if !textField.isSecureTextEntry {
            textField.clearButtonMode = .whileEditing
        }

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
//            textField.trailingAnchor.constraint(equalTo: revealButton.leadingAnchor, constant: -padding),
        ])

        if textField.isSecureTextEntry {
            textField.trailingAnchor.constraint(equalTo: revealButton.leadingAnchor, constant: -padding).isActive = true
        } else {
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding).isActive = true
        }
    }


    private func configureLabel() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = .systemFont(ofSize: 12)
        
        label.textColor = UIColor.label.withAlphaComponent(0.7)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.centerYAnchor.constraint(equalTo: topAnchor),
        ])
    }


    private func configureRevealButton() {
        addSubview(revealButton)
        revealButton.translatesAutoresizingMaskIntoConstraints = false
        revealButton.tintColor = .myBorderColor
        revealButton.addTarget(self, action: #selector(toggleSecureEntry(_:)), for: .touchUpInside)

        NSLayoutConstraint.activate([
            revealButton.heightAnchor.constraint(equalToConstant: 30),
            revealButton.widthAnchor.constraint(equalTo: revealButton.heightAnchor, multiplier: 1),
            revealButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            revealButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
        ])
    }


    private func updateRevealButtonImage() {
        let config = UIImage.SymbolConfiguration(pointSize: 12)
        let image = textField.isSecureTextEntry ? UIImage(systemName: "eye", withConfiguration: config) : UIImage(systemName: "eye.slash", withConfiguration: config)
        revealButton.setImage(image, for: .normal)
    }


    @objc private func toggleSecureEntry(_ sender: UIButton) {
        textField.isSecureTextEntry.toggle()
        updateRevealButtonImage()
    }


    @objc private func editingBegan(_ sender: UITextField) {
        setActiveColor()
    }

    @objc private func editingFinished(_ sender: UITextField) {
        setActiveColor(false)
    }


    private func setActiveColor(_ isActive: Bool = true, animated: Bool = true) {
        self.isActive = isActive
        let logic = {
            if isActive {
                self.label.textColor = .myActiveBorderColor
                self.revealButton.tintColor = .myActiveBorderColor
                self.border.borderColor = UIColor.myActiveBorderColor.cgColor
            } else {
                self.label.textColor = UIColor.label.withAlphaComponent(0.7)
                self.revealButton.tintColor = .myBorderColor
                self.border.borderColor = UIColor.myBorderColor.cgColor
            }
        }
        if animated {
            UIView.animate(withDuration: 0.3, animations: logic)
        } else {
            logic()
        }
    }
}
