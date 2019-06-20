//
//  AuthSubmitButton.swift
//  Courier
//
//  Created by Ido Pesok on 3/25/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

class AuthSubmitButton: UIButton {
    
    private var title: String = ""
    
    init(title: String) {
        super.init(frame: .zero)
        
        self.title = title
        self.backgroundColor = Colors.naval
        self.setTitle(title, for: .normal)
        self.setTitleColor(Colors.cloudWhite, for: .normal)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.titleLabel?.font = UIFont.bold(size: 19)
    }
    
    private var rotation: CABasicAnimation = {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = 0.75
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        
        return rotation
    }()
    
    private var rotationKey = "rotationAnimation"
    
    func isLoading(value: Bool) {
        if value {
            self.isEnabled = false
            self.setTitle("", for: .normal)
            self.layer.cornerRadius = 0
            self.layer.add(rotation, forKey: rotationKey)
        } else {
            self.isEnabled = true
            self.setTitle(title, for: .normal)
            self.layer.cornerRadius = 5
            self.layer.removeAnimation(forKey: rotationKey)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
