//
//  UserCell.swift
//  Courier
//
//  Created by Ido Pesok on 3/30/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit
import SDWebImage

class UserCell: UICollectionViewCell {
    
    static let imageViewSize: CGFloat = 80
    static let usernameLabelHeight: CGFloat = 30
    
    fileprivate var user: AppUser?
    
    let containerView = UIView()
    
    fileprivate let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.medium(size: 22)
        label.textAlignment = .center
        
        return label
    }()
    
    fileprivate let profileImgView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = Colors.lightGrey
        iv.layer.cornerRadius = UserCell.imageViewSize / 2
        iv.clipsToBounds = true
        
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    fileprivate func setupViews() {
        // Add Subviews
        self.addSubview(containerView)
        [usernameLabel, profileImgView].forEach({ containerView.addSubview($0) })
        
        // Container View
        containerView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, centerX: centerXAnchor, centerY: centerYAnchor, size: .init(width: 0, height: UserCell.imageViewSize + 5 + UserCell.usernameLabelHeight))
        
        // Profile Image View
        profileImgView.anchor(top: containerView.topAnchor, leading: nil, bottom: nil, trailing: nil, centerX: containerView.centerXAnchor, centerY: nil, size: .init(width: UserCell.imageViewSize, height: UserCell.imageViewSize))
        
        // Username Label
        usernameLabel.anchor(top: profileImgView.bottomAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 5, left: 15, bottom: 0, right: 15))
    }
    
    func setUser(user: AppUser) {
        self.user = user
        self.usernameLabel.text = user.username
        self.profileImgView.sd_setImage(with: URL.init(string: user.profileImageUrl), completed: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
