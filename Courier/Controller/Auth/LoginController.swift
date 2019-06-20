//
//  LoginController.swift
//  Courier
//
//  Created by Ido Pesok on 3/25/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

class LoginController: AuthController {
    
    fileprivate let emailTextField = AuthTextField.init(frame: .zero, placeholder: "Email", keyboardType: .emailAddress)
    fileprivate let passwordTextField = AuthTextField.init(frame: .zero, placeholder: "Password", isSecure: true)
    
    fileprivate lazy var noAccountButton: AuthMinorButton = {
        let btn = AuthMinorButton.init(title: "Don't have an account? Sign Up")
        btn.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        return btn
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        AuthService.shared.isLoggedIn { (bool, uid) in
            if bool && uid != nil {
                UserService.shared.retrieveUserWithId(uid!, completion: { (user) in
                    self.handleSuccess(user: user)
                })
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func setupViews() {
        super.setupViews()
        
        // ADD SUBVIEWS
        [emailTextField, passwordTextField, submitButton, noAccountButton].forEach({ view.addSubview($0) })
        
        // Email Text Field
        emailTextField.anchor(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: nil, centerY: nil, size: .init(width: 0, height: AuthTextField.textfieldHeight), padding: .init(top: 40, left: 25, bottom: 0, right: 25))
        
        // Password Text Field
        passwordTextField.anchor(top: emailTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: nil, centerY: nil, size: .init(width: 0, height: AuthTextField.textfieldHeight), padding: .init(top: 40, left: 25, bottom: 0, right: 25))
        
        // Login Button
        submitButton.anchor(top: passwordTextField.bottomAnchor, leading: passwordTextField.leadingAnchor, bottom: nil, trailing: passwordTextField.trailingAnchor, centerX: nil, centerY: nil, size: .init(width: 0, height: 60), padding: .init(top: 40, left: 0, bottom: 0, right: 0))
        
        // No Account Button
        noAccountButton.anchor(top: submitButton.bottomAnchor, leading: passwordTextField.leadingAnchor, bottom: nil, trailing: passwordTextField.trailingAnchor, centerX: nil, centerY: nil, size: .init(width: 0, height: 30), padding: .init(top: 20, left: 0, bottom: 0, right: 0))
    }
    
    override func setupTextFields() {
        emailTextField.setTextFieldDelegate(delegate: self)
        passwordTextField.setTextFieldDelegate(delegate: self)
    }
    
    override func setupSubmitButton() {
        let title = "LOGIN"
        submitButtonTitle = title
        submitButton.setTitle(title, for: .normal)
        submitButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }
    
    @objc fileprivate func handleLogin() {
        bringKeyboardDown()
        startLoading()
        
        checkForErrors(emailTF: emailTextField.getTextField(), passwordTF: passwordTextField.getTextField(), error: { (errMessage) in
            handleError(messsage: errMessage)
        }) { (email, password) in
            AuthService.shared.signIn(email: email, password: password, error: { (errMessage) in
                self.handleError(messsage: errMessage)
            }, completion: { (appUser) in
                self.handleSuccess(user: appUser)
            })
        }
    }
    
    fileprivate func handleError(messsage: String) {
        endLoading()
        AlertService.shared.launchOkAlert(title: "Oops!", message: messsage, sender: self)
    }
    
    fileprivate func handleSuccess(user: AppUser) {
        self.endLoading()
        AppUser.currentUser = user
        UserDefaultsService.shared.login()
        goToHome()
    }
    
    fileprivate func goToHome() {
        let vc = HomeController()
        let navController = UINavigationController.init(rootViewController: vc)
        present(navController, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleRegister() {
        navigationController?.pushViewController(RegisterController(), animated: true)
    }
    
    @objc override func bringKeyboardDown() {
        super.bringKeyboardDown()
        
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }
    
}


