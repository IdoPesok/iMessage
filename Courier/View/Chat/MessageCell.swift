//
//  MessageCell.swift
//  Courier
//
//  Created by Ido Pesok on 4/2/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    fileprivate var message: Message?
    
    fileprivate let messageBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.lightGrey
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        
        return view
    }()
    
    fileprivate let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(size: 16)
        label.numberOfLines = 0
        
        return label
    }()
    
    fileprivate let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.grey
        label.font = UIFont.regular(size: 16)
        label.textAlignment = .center
        
        return label
    }()
    
    fileprivate var messageLabelLeadingConstraint: NSLayoutConstraint?
    fileprivate var messageLabelTrailingConstraint: NSLayoutConstraint?
    fileprivate var messageLabelWidthConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    fileprivate func setupViews() {
        clipsToBounds = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add Subviews
        [messageBubbleView, messageLabel, dateLabel].forEach({ addSubview($0) })
        
        // Message Label
        messageLabel.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: nil, centerX: nil, centerY: nil, padding: .init(top: 22, left: 32, bottom: 22, right: 32))
        
        messageLabelLeadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        messageLabelTrailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        // Message Bubble View
        messageBubbleView.anchor(top: messageLabel.topAnchor, leading: messageLabel.leadingAnchor, bottom: messageLabel.bottomAnchor, trailing: messageLabel.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: -16, left: -16, bottom: -16, right: -16))
        
        // Date Label
        dateLabel.anchor(top: nil, leading: trailingAnchor, bottom: nil, trailing: nil, centerX: nil, centerY: centerYAnchor, size: .init(width: 100, height: 0))
    }
    
    func setMessage(_ m: Message) {
        message = m
        messageLabel.text = m.text
        dateLabel.text = m.timestamp.toTimeString()
        
        if m.fromUserId == AppUser.currentUser?.userId {
            handleHomeMessage()
        } else {
            handleAwayMessage()
        }
    }
    
    fileprivate func handleHomeMessage() {
        messageBubbleView.backgroundColor = Colors.electricBlue
        messageLabel.textColor = Colors.cloudWhite
        messageLabelLeadingConstraint?.isActive = false
        messageLabelTrailingConstraint?.isActive = true
    }
    
    fileprivate func handleAwayMessage() {
        messageBubbleView.backgroundColor = Colors.lightGrey
        messageLabel.textColor = nil
        messageLabelTrailingConstraint?.isActive = false
        messageLabelLeadingConstraint?.isActive = true
    }
    
    func getMessage() -> Message? {
        return message
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
