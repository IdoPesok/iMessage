//
//  ActionSheet.swift
//  Courier
//
//  Created by Ido Pesok on 4/22/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

class ActionSheet: AlertController {
    
    private var buttons = [AlertButton]()
    
    private lazy var cancelButton: AlertButton = {
        let ab = AlertButton.init(title: "Cancel")
        ab.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        
        return ab
    }()
    
    init(buttons: [AlertButton]) {
        super.init(title: "", message: "")
        
        self.buttons = buttons
    }
    
    override func setupViews() {
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        
        // ADD SUBVIEWS
        view.addSubview(containerView)
        
        // Container View
        containerView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: view.centerXAnchor, centerY: view.centerYAnchor, padding: .init(top: 0, left: view.frame.width / 6, bottom: 0, right: view.frame.width / 6))
        
        // Buttons
        for i in 0..<buttons.count {
            let btn = buttons[i]
            containerView.addSubview(btn)
            
            let tAnchor = i == 0 ? containerView.topAnchor : buttons[i - 1].bottomAnchor
            let tConstant: CGFloat = i == 0 ? 20 : 10
            btn.anchor(top: tAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, centerX: nil, centerY: nil, size: .init(width: 0, height: 50), padding: .init(top: tConstant, left: 20, bottom: 0, right: 20))
        }
        
        // Cancel Button
        containerView.addSubview(cancelButton)
        cancelButton.anchor(top: buttons.last?.bottomAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, centerX: nil, centerY: nil, size: .init(width: 0, height: 50), padding: .init(top: 10, left: 20, bottom: 20, right: 20))
    }
    
    @objc private func handleCancel() {
        dismissAlert()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
