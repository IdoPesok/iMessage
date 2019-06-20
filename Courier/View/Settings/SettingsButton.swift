//
//  SettingsButton.swift
//  Courier
//
//  Created by Ido Pesok on 4/20/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

class SettingsButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(Colors.cloudWhite, for: .normal)
        backgroundColor = Colors.midnightBlue
        layer.cornerRadius = 5
        clipsToBounds = true
        titleLabel?.font = UIFont.bold(size: 16)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
