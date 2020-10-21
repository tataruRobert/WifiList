//
//  InfoView.swift
//  WiFiList
//
//  Created by Tataru Robert on 21/10/2020.
//

import Foundation
import UIKit
import LocalAuthentication

class InfoView: UIView {
    
    enum RevealState {
        case revealed
        case hidden
        case noPassword
    }
    
    var wifi: Wifi

    let tapToRevealStr = "Tap to Reveal"

    var isRevealed: RevealState = .hidden {
        didSet {
            updatePasswordText()
        }
    }
    
    let networkHeaderLabel = MyTitleLabel(textAlignment: .left, fontSize: 12)
    let networkValueLabel = MyTitleLabel(textAlignment: .left, fontSize: 18)
    let passwordHeaderLabel = MyTitleLabel(textAlignment: .left, fontSize: 12)
    let passwordValueLabel = MyTitleLabel(textAlignment: .left, fontSize: 18)
    
    let tapGestureRecognizer = UITapGestureRecognizer()
    
    let networkImageView = IconImageView()
    let passwordImageView = IconImageView()
    
    var networkStackView = UIStackView()
    var passwordStackView = UIStackView()
    var mainStackView = UIStackView()
    
    init(frame: CGRect = .zero, with wifi: Wifi) {
        self.wifi = wifi
        super.init(frame: frame)
        configureView()
        configureLayout()
        loadContent()
        configureTapGesture()
        configureIntialPasswordRevealState(wifi: wifi)
    }


    override init(frame: CGRect) {
        fatalError("Use init(frame with wifi")
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        [networkImageView, passwordImageView].forEach { ($0).tintColor = .myGlobalTint }
    }
    
    private func configureLayout() {
        let networkLabelStackView = UIStackView.fillStackView(spacing: 4, with: [networkHeaderLabel, networkValueLabel])
        let passwordLabelStackView = UIStackView.fillStackView(spacing: 4, with: [passwordHeaderLabel, passwordValueLabel])

        let divider = UIView()
        divider.backgroundColor = .tertiaryLabel

        networkStackView = UIStackView.fillStackView(axis: .horizontal, spacing: 12, with: [networkImageView, networkLabelStackView])
        passwordStackView = UIStackView.fillStackView(axis: .horizontal, spacing: 12, with: [passwordImageView, passwordLabelStackView])
        mainStackView = UIStackView.fillStackView(spacing: 10, with: [networkStackView, divider, passwordStackView])

        addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            divider.heightAnchor.constraint(equalToConstant: 1),

            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),

            networkImageView.widthAnchor.constraint(equalTo: networkImageView.heightAnchor),
            passwordImageView.widthAnchor.constraint(equalTo: passwordImageView.heightAnchor),
        ])
    }
    
    private func loadContent() {
        networkImageView.icon = .network
        passwordImageView.icon = .password

        networkHeaderLabel.text = "Network"
        passwordHeaderLabel.text = "Password"

        networkValueLabel.text = wifi.networkName

        if wifi.password == "" {
            passwordValueLabel.text = "No Password"
            passwordValueLabel.textColor = .secondaryLabel
        } else {
            passwordValueLabel.text = tapToRevealStr
            passwordValueLabel.textColor = .myGlobalTint
        }
        
    }
    
    private func configureTapGesture() {
        tapGestureRecognizer.addTarget(self, action: #selector(revealPassword(_:)))
        passwordValueLabel.isUserInteractionEnabled = true
        passwordValueLabel.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func revealPassword(_ sender: UITapGestureRecognizer) {

        guard passwordValueLabel.text == tapToRevealStr else {
            isRevealed = .hidden
            return
        }
        
        
        FaceIDManager.requestAuth { (success, authError) in
            DispatchQueue.main.async {
                if success {
                    self.isRevealed = .revealed
                } else {
                    guard let error = authError as? LAError else { return }
                    NSLog(error.code.getErrorDescription())
                }
            }
        }
        
    }
    
    private func configureIntialPasswordRevealState(wifi: Wifi) {
        let password = wifi.password
        if password == "" {
            isRevealed = .noPassword
        } else {
            isRevealed = .hidden
        }
    }
    
    private func updatePasswordText() {
        guard passwordValueLabel.text != "No Password" else { return }
        if isRevealed == .revealed {
            UIView.animate(withDuration: 0.5) { self.passwordValueLabel.alpha = 0 }
            UIView.animate(withDuration: 0.5) {
                self.passwordValueLabel.textColor = .label
                self.passwordValueLabel.text = self.wifi.password
                self.passwordValueLabel.alpha = 1
                self.passwordHeaderLabel.text = "Tap To Hide Password"
            }
        } else {
            UIView.animate(withDuration: 0.5) { self.passwordValueLabel.alpha = 0 }
            UIView.animate(withDuration: 0.5) {
                self.passwordValueLabel.textColor = .myGlobalTint
                self.passwordValueLabel.text = self.tapToRevealStr
                self.passwordValueLabel.alpha = 1
                self.passwordHeaderLabel.text = "Password"
            }
        }
    }


}
