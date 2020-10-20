//
//  WifiCell.swift
//  WiFiList
//
//  Created by Tataru Robert on 18/10/2020.
//

import Foundation
import UIKit

class WifiCell: UITableViewCell {
    
    var wifi: Wifi? {
        didSet {
            updateViews()
        }
    }
    
    var containerLeadingConstraintNormal: NSLayoutConstraint!
    var containerLeadingConstraintEdit: NSLayoutConstraint!
    var labelsLeadingConstraintNormal: NSLayoutConstraint!
    var labelsLeadingConstraintEdit: NSLayoutConstraint!
    
    let iconImageView = UIImageView()
    lazy var labelStackView = UIStackView()
    let networkLabel = MyTitleLabel(textAlignment: .left, fontSize: 18)
    let nicknameLabel = MyTitleLabel(textAlignment: .left, fontSize: 12)

    let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mySecondaryBackground
        view.layer.cornerRadius = 12
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        // Editing styles don't seem to match what's actually happening
        // Without the line below, the icon disappears even when swiping on the cell. Line below fixes that
        guard editingStyle != .delete else { return }
        if editing {
            animateLabelConstraints(setToNormal: true)
        } else {
            animateLabelConstraints(setToNormal: false)
        }
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        UIView.animate(withDuration: 0.3) {
            if selected {
                self.container.backgroundColor = UIColor.myGlobalTint.withAlphaComponent(0.2)
            } else {
                self.container.backgroundColor = .mySecondaryBackground
            }
        }
        
        guard isEditing else { return }
        UIView.animate(withDuration: 0.3) {
            if selected {
                self.animateContainerConstraints(setToNormal: true)
            } else {
                self.animateContainerConstraints(setToNormal: false)
            }
        }

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    private func animateContainerConstraints(setToNormal: Bool) {
        if setToNormal {
            guard containerLeadingConstraintNormal.isActive else { return }
            NSLayoutConstraint.deactivate([containerLeadingConstraintNormal])
            NSLayoutConstraint.activate([containerLeadingConstraintEdit])

        } else {
            guard containerLeadingConstraintEdit.isActive else { return }
            NSLayoutConstraint.deactivate([containerLeadingConstraintEdit])
            NSLayoutConstraint.activate([containerLeadingConstraintNormal])
        }
    }


    private func animateLabelConstraints(setToNormal: Bool) {
        if setToNormal {
            guard labelsLeadingConstraintNormal.isActive else { return }
            UIView.animate(withDuration: 0.15) {
                self.iconImageView.alpha = 0
            }
            NSLayoutConstraint.deactivate([labelsLeadingConstraintNormal])
            NSLayoutConstraint.activate([labelsLeadingConstraintEdit])
        } else {
            guard labelsLeadingConstraintEdit.isActive else { return }
            NSLayoutConstraint.deactivate([labelsLeadingConstraintEdit])
            NSLayoutConstraint.activate([labelsLeadingConstraintNormal])
            UIView.animate(withDuration: 0.5) {
                self.iconImageView.alpha = 1
            }
        }
    }


    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .myBackground
        configureContainer()
        configureIconImageView()
        configureLabels()
        configureConstraints()
        accessoryType = .disclosureIndicator
    }
    
    private func configureContainer() {
        contentView.addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            container.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureIconImageView() {
        container.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .center

        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor, multiplier: 1),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            iconImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: 0)
        ])

        guard let wifi = wifi else { return }
        iconImageView.tintColor = wifi.isFavorite == true ? UIColor.myGlobalTint : UIColor.myGlobalTint
        iconImageView.image = UIImage(systemName: wifi.iconName ?? "house.fill", withConfiguration: configuration)
    }

    private func configureLabels() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.addArrangedSubview(networkLabel)
        labelStackView = stackView
        container.addSubview(labelStackView)
        labelStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            labelStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
            labelStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12)
        ])
    }
    
    private func configureConstraints() {
        // Container
        containerLeadingConstraintNormal = container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -10)
        containerLeadingConstraintNormal.isActive = true
        containerLeadingConstraintEdit = container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        containerLeadingConstraintEdit.isActive = false

        // labelStackView
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelsLeadingConstraintNormal = labelStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12)
        labelsLeadingConstraintNormal.isActive = true
        labelsLeadingConstraintEdit = labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60)
        labelsLeadingConstraintEdit.isActive = false
    }
    
    func updateViews() {
        guard let wifi = wifi else { return }
        networkLabel.text = wifi.networkName
        
        if let password = wifi.password {
            if password == "" {
                detailTextLabel?.textColor = .systemGray2
            } else {
                detailTextLabel?.textColor = .secondaryLabel
            }
        }

        configureIconImageView()
        //configureLockImageView()
    }
}
