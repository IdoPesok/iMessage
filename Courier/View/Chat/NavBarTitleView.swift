//
//  NavBarTitleView.swift
//  Courier
//
//  Created by Ido Pesok on 4/4/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

class NavBarTitleView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bold(size: 20)
        
        return label
    }()
    
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = Colors.lightGrey
        iv.clipsToBounds = true
        iv.layer.cornerRadius = (self.viewHeight - 8) / 2
        iv.contentMode = UIView.ContentMode.scaleToFill
        
        return iv
    }()
    
    fileprivate var viewHeight: CGFloat = 0
    
    init(height: CGFloat) {
        super.init(frame: .zero)
        viewHeight = height
        
        setupViews()
    }
    
    fileprivate func setupViews() {
        // Add Subviews
        [profileImageView, titleLabel].forEach({ addSubview($0) })
        
        // Profile Image View
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, centerX: nil, centerY: nil, size: CGSize.init(width: viewHeight - 8, height: 0), padding: .init(top: 4, left: 0, bottom: 4, right: 0))
        
        // Title Label
        titleLabel.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
