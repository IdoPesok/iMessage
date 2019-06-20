//
//  UsernameTextField.swift
//  Courier
//
//  Created by Ido Pesok on 4/20/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

class UsernameTextField: UIView, UITextFieldDelegate {
    
    private var placeholder = ""
    
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.font = UIFont.regular(size: 20)
        tf.textColor = Colors.grey
        tf.autocapitalizationType = .none
        
        return tf
    }()
    
    private let divider: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.midnightBlue
        
        return v
    }()
    
    init(placeholder: String) {
        super.init(frame: .zero)
        
        setPlaceholder(placeholder)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .clear
        
        // Add Subviews
        [textField, divider].forEach({ addSubview($0) })
        
        // TextField
        textField.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, centerX: nil, centerY: nil, size: .init(width: 0, height: 50))
        
        // Divider
        divider.anchor(top: textField.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, centerX: nil, centerY: nil, size: .init(width: 0, height: 2))
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == placeholder {
            textField.text = ""
            textField.textColor = Colors.midnightBlue
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = placeholder
            textField.textColor = Colors.grey
        }
    }
    
    func endEditing() {
        textField.endEditing(true)
    }
    
    private func setPlaceholder(_ ph: String) {
        self.textField.text = ph
        self.placeholder = ph
    }
    
    func getText() -> String {
        return textField.text ?? ""
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize.init(width: .zero, height: 52)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
