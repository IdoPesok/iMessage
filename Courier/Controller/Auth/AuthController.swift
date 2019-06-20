//
//  AuthController.swift
//  Courier
//
//  Created by Ido Pesok on 3/25/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

class AuthController: UIViewController, UITextFieldDelegate {
    
    let titleLabel: UILabel = {
        let label = UILabel.init()
        label.text = "C O U R I E R"
        label.textColor = UIColor.white
        label.font = UIFont.bold(size: 30)
        label.textAlignment = .center
        
        return label
    }()
    
    var submitButtonTitle: String = ""
    let submitButton: AuthSubmitButton = AuthSubmitButton.init(title: "")
    
    fileprivate var titleLabelTopAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupTextFields()
        setupGestureRecognizers()
        setupSubmitButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let authTextField = textField.superview as? AuthTextField {
            authTextField.beganEditing()
            shakeTextField(tf: authTextField)
        }
        
        moveTitleUp()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let authTextField = textField.superview as? AuthTextField {
            authTextField.endedEditing()
        }
    }
    
    fileprivate func shakeTextField(tf: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: tf.center.x - 3, y: tf.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: tf.center.x + 3, y: tf.center.y))
        tf.layer.add(animation, forKey: "position")
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.init(hexString: "#2c3e50")
        
        // ADD SUBVIEWS
        view.addSubview(titleLabel)
        
        // Title Label
        titleLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: nil, centerY: nil, size: CGSize.init(width: 0, height: 50), padding: UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        titleLabelTopAnchor = titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60)
        titleLabelTopAnchor?.isActive = true
    }
    
    func setupTextFields() {
        preconditionFailure("This method must be overriden")
    }
    
    func setupSubmitButton() {
        preconditionFailure("This method must be overriden")
    }
    
    func setupGestureRecognizers() {
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(bringKeyboardDown)))
        
        let swipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(bringKeyboardDown))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc func bringKeyboardDown() {
        moveTitleDown()
    }
    
    fileprivate func moveTitleDown() {
        self.titleLabelTopAnchor?.constant = 60
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
            self.titleLabel.alpha = 1
        }, completion: nil)
    }
    
    fileprivate func moveTitleUp() {
        self.titleLabelTopAnchor?.constant = -(self.titleLabel.frame.height)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.titleLabel.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func startLoading() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.5, options: .curveEaseInOut, animations: {
            self.submitButton.isLoading(value: true)
            let xScale = self.submitButton.frame.height / self.submitButton.frame.width
            self.submitButton.transform = CGAffineTransform.init(scaleX: xScale, y: 1)
        }, completion: nil)
    }
    
    func endLoading() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.5, options: .curveEaseInOut, animations: {
            self.submitButton.isLoading(value: false)
            self.submitButton.transform = .identity
            self.submitButton.setTitle(self.submitButtonTitle, for: .normal)
        }, completion: nil)
    }
    
    func checkForErrors(emailTF: UITextField, passwordTF: UITextField, error: (String) -> Void, completion: (String, String) -> Void) {
        guard emailTF.text != "", passwordTF.text != "", let email = emailTF.text, let password = passwordTF.text else {
            error("Looks like you didn't fill in the entire form")
            return
        }
        
        guard AuthService.shared.isValidEmail(testStr: email) else {
            error("You must enter a valid email to create an account")
            return
        }
        
        guard password.count >= 6 else {
            error("Your password must be at least 6 characters")
            return
        }
        
        completion(email, password)
    }
    
}

