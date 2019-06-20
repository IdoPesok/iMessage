//
//  AuthTextField.swift
//  Courier
//
//  Created by Ido Pesok on 3/25/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

class AuthTextField: UIView {
    
    static let textfieldHeight = 53.0
    
    private var placeholderText: String = ""
    private var keyboardType: UIKeyboardType = .default
    private var isSecure: Bool = false
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.blueGrey
        label.font = UIFont.bold(size: 18)
        label.text = placeholderText
        
        return label
    }()
    
    private lazy var textfield: UITextField = {
        let tf = UITextField()
        tf.textColor = .white
        tf.keyboardType = self.keyboardType
        tf.isSecureTextEntry = self.isSecure
        tf.backgroundColor = Colors.midnightBlue
        tf.autocapitalizationType = .none
        tf.font = UIFont.regular(size: 18)
        
        return tf
    }()
    
    private var bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.electricBlue
        
        return view
    }()
    
    init(frame: CGRect, placeholder: String, keyboardType: UIKeyboardType = .default, isSecure: Bool = false) {
        super.init(frame: frame)
        
        self.placeholderText = placeholder
        self.keyboardType = keyboardType
        self.isSecure = isSecure
        
        setupViews()
    }
    
    fileprivate func setupViews() {
        // ADD SUBVIEWS
        [placeholderLabel, textfield, bottomBorder].forEach({ self.addSubview($0) })
        
        // Placeholder Label
        placeholderLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, centerX: nil, centerY: nil, size: .init(width: 0, height: 20), padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        // Textfield
        textfield.anchor(top: placeholderLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, centerX: nil, centerY: nil, size: .init(width: 0, height: 40), padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        // Bottom Border
        bottomBorder.anchor(top: textfield.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, centerX: nil, centerY: nil, size: .init(width: 0, height: 3), padding: .init(top: 2, left: 0, bottom: 0, right: 0))
    }
    
    func setTextFieldDelegate(delegate: UITextFieldDelegate) {
        self.textfield.delegate = delegate
    }
    
    func beganEditing() {
        placeholderLabel.textColor = UIColor.white
    }
    
    func endedEditing() {
        placeholderLabel.textColor = Colors.blueGrey
    }
    
    func getTextField() -> UITextField {
        return textfield
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

