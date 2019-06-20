//
//  AuthMinorButton.swift
//  Courier
//
//  Created by Ido Pesok on 3/27/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

class AuthMinorButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        
        self.backgroundColor = nil
        self.setTitle(title, for: .normal)
        self.setTitleColor(Colors.cloudWhite, for: .normal)
        self.titleLabel?.font = UIFont.regular(size: 16)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
