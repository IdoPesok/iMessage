//
//  MessageInputAccessoryView.swift
//  Courier
//
//  Created by Ido Pesok on 3/31/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

protocol MessageInputViewDelegate {
    func handleSend(message: String)
}

class MessageInputView: UIView, UITextViewDelegate {
    
    fileprivate let contentView: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.lightGrey
        
        return v
    }()
    
    fileprivate var delegate: MessageInputViewDelegate?
    
    fileprivate let topDividerLine: UIView = {
        let view = UIView()
        
        return view
    }()
    
    lazy fileprivate var textView: UITextView = {
        let tv = UITextView()
        tv.layer.cornerRadius = 8
        tv.layer.masksToBounds = true
        tv.font = UIFont.regular(size: 18)
        tv.textContainerInset = UIEdgeInsets.init(top: 6, left: 10, bottom: 6, right: 10)
        tv.delegate = self
        tv.isScrollEnabled = false
        
        return tv
    }()
    
    fileprivate lazy var sendButton: UIButton = {
        let btn = UIButton.init(type: .system)
        btn.setTitle("⇨", for: .normal)
        btn.setTitleColor(Colors.cloudWhite, for: .normal)
        btn.backgroundColor = Colors.electricBlue
        btn.layer.cornerRadius = 8
        btn.clipsToBounds = true
        btn.titleLabel?.font = UIFont.bold(size: 20)
        btn.addTarget(self, action: #selector(handleSendPressed), for: .touchUpInside)
        
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    fileprivate func setup() {
        autoresizingMask = [.flexibleHeight]
        setupViews()
    }
    
    fileprivate func setupViews() {
        backgroundColor = Colors.lightGrey
        
        // Add Subviews
        addSubview(contentView)
        [textView, topDividerLine, sendButton].forEach({ contentView.addSubview($0) })
        
        // Content View
        contentView.anchor(top: topAnchor, leading: leadingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: trailingAnchor, centerX: nil, centerY: nil, size: .init(width: 0, height: getTextViewHeight() + 16))
        
        // Top Divider Line
        topDividerLine.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, centerX: nil, centerY: nil, size: .init(width: 0, height: 1))
        
        // Text Field
        setupPlaceholder()
        textView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 8, left: 10, bottom: 8, right: 70))
        
        // Send Button
        sendButton.anchor(top: nil, leading: textView.trailingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, centerX: nil, centerY: nil, size: .init(width: 0, height: getTextViewHeight()), padding: .init(top: 0, left: 10, bottom: 8, right: 10))
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateTextViewHeight()
    }
    
    fileprivate func updateTextViewHeight() {
        contentView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = self.getTextViewHeight() + 16
                self.layoutIfNeeded()
            }
        }
    }
    
    fileprivate let placeholderText = "Message"
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            setupPlaceholder()
        }
    }
    
    fileprivate func setupPlaceholder() {
        textView.text = placeholderText
        textView.textColor = Colors.grey
    }
    
    fileprivate func getTextViewHeight() -> CGFloat {
        let size = CGSize.init(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        let height = estimatedSize.height
        return height
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize.zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDelegate(_ delegate: MessageInputViewDelegate) {
        self.delegate = delegate
    }
    
    @objc fileprivate func handleSendPressed() {
        if textView.text != "" && textView.text != placeholderText {
            delegate?.handleSend(message: textView.text)
            textView.text = ""
            updateTextViewHeight()
            if !textView.isFirstResponder {
                setupPlaceholder()
            }
        }
    }
    
}
