//
//  AlertButton.swift
//  Courier
//
//  Created by Ido Pesok on 3/27/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

class AlertButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        
        self.backgroundColor = Colors.midnightBlue
        self.setTitle(title, for: .normal)
        self.setTitleColor(Colors.cloudWhite, for: .normal)
        self.layer.cornerRadius = 5
        self.titleLabel?.font = UIFont.regular(size: 15)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
