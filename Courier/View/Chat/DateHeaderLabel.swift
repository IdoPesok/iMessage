//
//  DateHeaderLabel.swift
//  Courier
//
//  Created by Ido Pesok on 4/4/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

class DateHeaderLabel: UILabel {
    
    init(text: String) {
        super.init(frame: .zero)
        
        textColor = Colors.cloudWhite
        backgroundColor = Colors.midnightBlue
        font = UIFont.medium(size: 16)
        textAlignment = .center
        self.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let originalContentSize = super.intrinsicContentSize
        let height = originalContentSize.height + 16
        layer.cornerRadius = height / 2
        layer.masksToBounds = true
        return CGSize.init(width: originalContentSize.width + 22, height: height)
    }
    
}
