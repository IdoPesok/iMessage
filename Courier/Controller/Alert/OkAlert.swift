//
//  OkAlert.swift
//  Courier
//
//  Created by Ido Pesok on 3/26/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

class OkAlert: AlertController {
    
    lazy var okButton: UIButton = {
        let btn = AlertButton.init(title: "OK")
        btn.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        
        return btn
    }()
    
    override func setupViews() {
        super.setupViews()
        
        // Add Subviews
        view.addSubview(okButton)
        
        // Ok Button
        okButton.anchor(top: messageLabel.bottomAnchor, leading: messageLabel.leadingAnchor, bottom: containerView.bottomAnchor, trailing: messageLabel.trailingAnchor, centerX: nil, centerY: nil, size: .init(width: 0, height: 50), padding: .init(top: 15, left: 0, bottom: 25, right: 0))
    }
    
}
