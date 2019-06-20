//
//  ChangeUsernameController.swift
//  Courier
//
//  Created by Ido Pesok on 4/20/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

class ChangeUsernameController: UIViewController {
    
    private let textField = UsernameTextField.init(placeholder: "New Username")
    
    private let submitButton = SettingsButton.init(title: "SUBMIT")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupViews()
        setupTargets()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        // Add Subviews
        [textField, submitButton].forEach({ view.addSubview($0) })
        
        // Text Field
        textField.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 10, left: 15, bottom: 0, right: 15))
        
        // Submit Button
        submitButton.anchor(top: textField.bottomAnchor, leading: textField.leadingAnchor, bottom: nil, trailing: textField.trailingAnchor, centerX: nil, centerY: nil, size: .init(width: 0, height: 50), padding: .init(top: 20, left: 0, bottom: 0, right: 0))
    }
    
    private func setupNavBar() {
        navigationItem.title = "Change Username"
        
        let cancelBtn = UIBarButtonItem.init(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
        cancelBtn.tintColor = Colors.midnightBlue
        navigationItem.setLeftBarButton(cancelBtn, animated: true)
    }
    
    private func setupTargets() {
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
    }
    
    @objc private func handleSubmit() {
        let username = textField.getText()
        guard username != "" else {
            AlertService.shared.launchOkAlert(title: "Oops!", message: "You can't submit an empty username. Please try again.", sender: self)
            return
        }
        
        AuthService.shared.checkIfUsernameExists(username: username, error: { (err) in
            AlertService.shared.launchOkAlert(title: "Oops!", message: "The new username you chose is already taken. Please try again.", sender: self)
        }) {
            self.updateUsername(username)
        }
    }
    
    private func updateUsername(_ username: String) {
        UserService.shared.changeUsernameTo(newUsername: username, onError: { (errMessage) in
            AlertService.shared.launchOkAlert(title: "Oops!", message: errMessage, sender: self)
        }) {
            AppUser.currentUser?.username = username
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func handleCancel() {
        navigationController?.popViewController(animated: true)
    }
    
}
