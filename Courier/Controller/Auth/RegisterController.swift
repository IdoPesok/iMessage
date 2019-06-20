//
//  RegisterController.swift
//  Courier
//
//  Created by Ido Pesok on 3/25/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

class RegisterController: AuthController {
    
    fileprivate let emailTextField = AuthTextField.init(frame: .zero, placeholder: "Email", keyboardType: .emailAddress)
    fileprivate let passwordTextField = AuthTextField.init(frame: .zero, placeholder: "Password", isSecure: true)
    fileprivate let usernameTextField = AuthTextField.init(frame: .zero, placeholder: "Username")
    
    fileprivate let backButton: UIButton = {
        let btn = AuthMinorButton.init(title: "Back")
        btn.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        return btn
    }()
    
    override func setupViews() {
        super.setupViews()
        
        // ADD SUBVIEWS
        [usernameTextField, emailTextField, passwordTextField, submitButton, backButton].forEach({ view.addSubview($0) })
        
        // Username Text Field
        usernameTextField.anchor(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: nil, centerY: nil, size: .init(width: 0, height: AuthTextField.textfieldHeight), padding: .init(top: 40, left: 25, bottom: 0, right: 25))
        
        // Email Text Field
        emailTextField.anchor(top: usernameTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: nil, centerY: nil, size: .init(width: 0, height: AuthTextField.textfieldHeight), padding: .init(top: 40, left: 25, bottom: 0, right: 25))
        
        // Password Text Field
        passwordTextField.anchor(top: emailTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: nil, centerY: nil, size: .init(width: 0, height: AuthTextField.textfieldHeight), padding: .init(top: 40, left: 25, bottom: 0, right: 25))
        
        // Login Button
        submitButton.anchor(top: passwordTextField.bottomAnchor, leading: passwordTextField.leadingAnchor, bottom: nil, trailing: passwordTextField.trailingAnchor, centerX: nil, centerY: nil, size: .init(width: 0, height: 60), padding: .init(top: 40, left: 0, bottom: 0, right: 0))
        
        // No Account Button
        backButton.anchor(top: submitButton.bottomAnchor, leading: passwordTextField.leadingAnchor, bottom: nil, trailing: passwordTextField.trailingAnchor, centerX: nil, centerY: nil, size: .init(width: 0, height: 30), padding: .init(top: 20, left: 0, bottom: 0, right: 0))
    }
    
    override func setupTextFields() {
        emailTextField.setTextFieldDelegate(delegate: self)
        passwordTextField.setTextFieldDelegate(delegate: self)
        usernameTextField.setTextFieldDelegate(delegate: self)
    }
    
    override func setupSubmitButton() {
        let title = "SIGN UP"
        submitButtonTitle = title
        submitButton.setTitle(title, for: .normal)
        submitButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
    }
    
    @objc fileprivate func handleRegister() {
        startLoading()
        bringKeyboardDown()
        validateUsername()
    }
    
    fileprivate func validateUsername() {
        guard usernameTextField.getTextField().text != "", let username = usernameTextField.getTextField().text else {
            handleError(message: "Please fill in the entire form.")
            return
        }
        
        AuthService.shared.checkIfUsernameExists(username: username, error: { (errMessage) in
            self.handleError(message: errMessage)
        }) {
            self.validateEmailAndPassword(username: username)
        }
    }
    
    fileprivate func validateEmailAndPassword(username: String) {
        checkForErrors(emailTF: emailTextField.getTextField(), passwordTF: passwordTextField.getTextField(), error: { (message) in
            self.handleError(message: message)
        }) { (email, password) in
            createUser(email: email, username: username, password: password)
        }
    }
    
    fileprivate func createUser(email: String, username: String, password: String) {
        AuthService.shared.createUser(email: email, username: username, password: password, error: { (message) in
            self.handleError(message: message)
        }) { (user) in
            self.handleSuccess()
        }
    }
    
    fileprivate func handleError(message: String) {
        self.endLoading()
        AlertService.shared.launchOkAlert(title: "Oops!", message: message, sender: self)
    }
    
    fileprivate func handleSuccess() {
        self.endLoading()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc override func bringKeyboardDown() {
        super.bringKeyboardDown()
        
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        usernameTextField.endEditing(true)
    }
    
}

