//
//  ChatCell.swift
//  Courier
//
//  Created by Ido Pesok on 4/2/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit
import SDWebImage

class ChatCell: UITableViewCell {
    
    static let imageViewSize: CGFloat = 80
    
    fileprivate var chat: Chat?
    
    fileprivate let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Colors.lightGrey
        imageView.layer.cornerRadius = ChatCell.imageViewSize / 2
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    fileprivate let chatTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bold(size: 24)
        
        return label
    }()
    
    fileprivate let lastMessageTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(size: 16)
        label.textColor = Colors.grey
        label.textAlignment = .right
        
        return label
    }()
    
    fileprivate let lastMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(size: 20)
        label.textColor = Colors.darkGrey
        label.textAlignment = .left
        label.numberOfLines = 2
        
        return label
    }()
    
    fileprivate let bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.lightGrey
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    fileprivate func setupViews() {
        selectionStyle = .none
        
        // Add Subviews
        [profileImageView, chatTitleLabel, lastMessageTimeLabel, lastMessageLabel, bottomBorder].forEach({ addSubview($0) })
        
        // Profile Image View
        profileImageView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, centerX: nil, centerY: centerYAnchor, size: .init(width: ChatCell.imageViewSize, height: ChatCell.imageViewSize), padding: UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0))
        
        // Chat Title Label
        chatTitleLabel.anchor(top: profileImageView.topAnchor, leading: profileImageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 20, bottom: 0, right: 110))
        
        // Last Message Time Label
        lastMessageTimeLabel.anchor(top: nil, leading: chatTitleLabel.trailingAnchor, bottom: nil, trailing: trailingAnchor, centerX: nil, centerY: chatTitleLabel.centerYAnchor, padding: .init(top: 0, left: 10, bottom: 0, right: 10))
        
        // Last Message Label
        lastMessageLabel.anchor(top: chatTitleLabel.bottomAnchor, leading: chatTitleLabel.leadingAnchor, bottom: profileImageView.bottomAnchor, trailing: lastMessageTimeLabel.trailingAnchor, centerX: nil, centerY: nil)
        
        // Bottom Border
        bottomBorder.anchor(top: nil, leading: chatTitleLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, centerX: nil, centerY: nil, size: .init(width: 0, height: 1.5), padding: .init(top: 0, left: 0, bottom: 0, right: 8))
    }
    
    func setChat(_ chat: Chat) {
        self.chat = chat
        self.lastMessageTimeLabel.text = chat.lastMessageTimestamp.toString()
        
        UserService.shared.retrieveUserWithId(chat.chatToUserId) { (user) in
            self.profileImageView.sd_setImage(with: URL.init(string: user.profileImageUrl), completed: nil)
            self.chatTitleLabel.text = user.username
            
            if chat.lastMessageId != "" {
                MessageService.shared.retrieveMessageWithId(chat.lastMessageId, completion: { (message) in
                    self.lastMessageLabel.text = message.text
                })
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
