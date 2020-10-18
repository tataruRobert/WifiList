//
//  AddWifiVC.swift
//  WiFiList
//
//  Created by Tataru Robert on 18/10/2020.
//

import UIKit

class AddWifiVC: UIViewController {
    
    var wifi: Wifi?
    
    enum IconInfo: String {
        case home = "Home"
        case homeIconName = "house.fill"
        case work = "Work"
        case workIconName = "briefcase.fill"
        

        var homeImage: UIImage {
            return UIImage(systemName: "house.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))!
        }

        var workImage: UIImage {
            return UIImage(systemName: "briefcase.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))!
        }

    }
    
    private let iconButton = UIButton()
    private let saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                    target: self, action: #selector(saveTapped(_:)))
    private let iconSegControl = UISegmentedControl()
    private let elementStackView = UIStackView()
    
    private let networkTextField = MyTextFieldView(isSecureEntry: false, placeholder: "Network", autocorrectionType: .no, autocapitalizationType: .none, returnType: .continue, needsRevealButton: false)
    private let passwordTextField = MyTextFieldView(isSecureEntry: true, placeholder: "Password", autocorrectionType: .no, autocapitalizationType: .none, returnType: .done, needsRevealButton: true)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .mySecondaryBackground
        configureNavBar()
        configureSegmentedControl()
        configureElementStackView()
        
    }
    
    private func configureNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.tintColor = .myGlobalTint

        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.myGlobalTint,
        .font : UIFont.roundedFont(ofSize: 35, weight: .heavy)]

        if wifi == nil {
            title = "Add WiFi"
        }
        
        let cancelBarbutton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped(_:)))
        navigationItem.leftBarButtonItem = cancelBarbutton
        navigationItem.rightBarButtonItem = saveBarButtonItem
        saveBarButtonItem.target = self
        saveBarButtonItem.isEnabled = false
        iconButton.setImage(IconInfo.home.homeImage, for: .normal)
        iconButton.tintColor = .myGlobalTint
        navigationItem.titleView = iconButton
    }
    
    private func configureSegmentedControl() {
        view.addSubview(iconSegControl)
        iconSegControl.translatesAutoresizingMaskIntoConstraints = false
        iconSegControl.sizeToFit()
        iconSegControl.setTitleTextAttributes([.foregroundColor : UIColor.segSelectedTextColor], for: .selected)
        iconSegControl.selectedSegmentTintColor = .myGlobalTint
        iconSegControl.backgroundColor = .myGrayColor
        iconSegControl.tintColor = .myGlobalTint
        
        iconSegControl.insertSegment(withTitle: IconInfo.home.rawValue, at: 0, animated: true)
        iconSegControl.insertSegment(withTitle: IconInfo.work.rawValue, at: 1, animated: true)
        
        iconSegControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        if wifi == nil {
            iconSegControl.selectedSegmentIndex = 0
        }
        //iconSegControl.addTarget(self, action: #selector(segControlDidChange), for: .valueChanged)
    }
    
    private func configureElementStackView() {
        view.addSubview(elementStackView)
        elementStackView.translatesAutoresizingMaskIntoConstraints = false

        elementStackView.axis = .vertical
        elementStackView.alignment = .fill
        elementStackView.distribution = .fill
        
        if UIScreen.main.bounds.height <= 667 {
            elementStackView.spacing = 25
            [networkTextField, passwordTextField].forEach {
                $0.heightAnchor.constraint(equalToConstant: 40).isActive = true
            }
        } else {
            elementStackView.spacing = 30
            [networkTextField, passwordTextField].forEach {
                $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
            }
        }
        
        [networkTextField.textField, passwordTextField.textField].forEach {
            $0.addTarget(self, action: #selector(watchChangesOccured(_:)), for: .editingChanged)
        }
        
        [iconSegControl,
         networkTextField,
         passwordTextField,
        ].forEach { elementStackView.addArrangedSubview($0) }
        
        
        NSLayoutConstraint.activate([
            elementStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            elementStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            elementStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
        
        
    }
    
    @objc func watchChangesOccured(_: UITextField) {
        
    }
    
    @objc func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc func saveTapped(_ sender: UIBarButtonItem) {
        
    }
    

   

}
