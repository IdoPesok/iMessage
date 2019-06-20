//
//  AlertController.swift
//  Courier
//
//  Created by Ido Pesok on 3/26/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

class AlertController: UIViewController {
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderColor = Colors.nightBlue.cgColor
        view.layer.masksToBounds = true
        view.layer.borderWidth = 2
        view.backgroundColor = Colors.cloudWhite
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bold(size: 25)
        label.textAlignment = .center
        
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(size: 15)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    init(title: String, message: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.titleLabel.text = title
        self.messageLabel.text = message
        self.modalPresentationStyle = .overCurrentContext
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        
        // ADD SUBVIEWS
        view.addSubview(containerView)
        [titleLabel, messageLabel].forEach({ containerView.addSubview($0) })
        
        // Container View
        containerView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: view.centerXAnchor, centerY: view.centerYAnchor, padding: .init(top: 0, left: view.frame.width / 5, bottom: 0, right: view.frame.width / 5))
        
        // Title Label
        titleLabel.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, centerX: nil, centerY: nil, size: .init(width: 0, height: 30), padding: .init(top: 25, left: 16, bottom: 0, right: 16))
        
        // Message Label
        messageLabel.anchor(top: titleLabel.bottomAnchor, leading: titleLabel.leadingAnchor, bottom: nil, trailing: titleLabel.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
    }
    
    @objc func dismissAlert() {
        dismiss(animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

