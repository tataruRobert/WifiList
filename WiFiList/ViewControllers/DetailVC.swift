//
//  DetailVC.swift
//  WiFiList
//
//  Created by Tataru Robert on 20/10/2020.
//

import UIKit

class DetailVC: UIViewController {
    
    private let wifi: Wifi
    private var qrImageView: WiFiImageView
    private var infoView: InfoView

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavController()
        configureView()
        configureWifiInfoView()
    }
    
    init(with wifi: Wifi) {
        self.wifi = wifi
        self.qrImageView = WiFiImageView(with: wifi)
        self.infoView = InfoView(with: wifi)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("Use init(with wifi: Wifi)")
    }
    
    func configureNavController() {
        title = wifi.networkName
        let star = UIImage(systemName: "star.fill")?.withTintColor(.myGlobalTint, renderingMode: .alwaysOriginal)
        let starImageView = UIImageView(image: star)

        if wifi.isFavorite {
            navigationItem.titleView = starImageView
        } else {
            navigationItem.titleView = nil
        }

//        let optionsButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(optionsButtonTapped(_:)))
//        navigationItem.rightBarButtonItem = optionsButton
    }
    
    private func configureView() {
        view.backgroundColor = .myBackground
        layoutAndConfigureImageView(imageView: qrImageView)
    }
    
    private func layoutAndConfigureImageView(imageView: UIImageView) {
        view.addSubview(imageView)
        imageView.isUserInteractionEnabled = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])

//        let interaction = UIContextMenuInteraction(delegate: self)
//        imageView.addInteraction(interaction)
    }
    
    private func configureWifiInfoView() {
        view.addSubview(infoView)

        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: qrImageView.bottomAnchor, constant: 30),
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
}
