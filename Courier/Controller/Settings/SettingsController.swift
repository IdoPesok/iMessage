//
//  SettingsController.swift
//  Courier
//
//  Created by Ido Pesok on 4/7/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit
import SDWebImage

class SettingsController: UIViewController {
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = profileImageViewSize / 2
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.backgroundColor = UIColor.gray
        
        return iv
    }()
    private let profileImageViewSize: CGFloat = 100
    
    private let currentUsernameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = Colors.darkGrey
        lbl.textAlignment = .center
        lbl.font = UIFont.bold(size: 22)
        
        return lbl
    }()
    
    private let logoutButton = SettingsButton.init(title: "LOGOUT")
    private let changeUsernameButton = SettingsButton.init(title: "CHANGE USERNAME")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupViews()
        setupTargets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setProfileImageAndUsername()
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = UIColor.white
        
        // Add Subviews
        [profileImageView, currentUsernameLabel, changeUsernameButton, logoutButton].forEach({ view.addSubview($0 )})
        
        // Profile Image View
        profileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, centerX: view.centerXAnchor, centerY: nil, size: .init(width: profileImageViewSize, height: profileImageViewSize), padding: .init(top: 40, left: 0, bottom: 0, right: 0))
        
        // Current Username Label
        currentUsernameLabel.anchor(top: profileImageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 20, left: 15, bottom: 0, right: 15))
        
        // Change Username Button
        changeUsernameButton.anchor(top: currentUsernameLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, centerX: view.centerXAnchor, centerY: nil, size: .init(width: view.frame.width * 0.8, height: 50), padding: .init(top: 40, left: 0, bottom: 0, right: 0))
        
        // Logout Button
        logoutButton.anchor(top: changeUsernameButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil, centerX: view.centerXAnchor, centerY: nil, size: .init(width: view.frame.width * 0.8, height: 50), padding: .init(top: 10, left: 0, bottom: 0, right: 0))
    }
    
    private func setupTargets() {
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        changeUsernameButton.addTarget(self, action: #selector(handleChangeUsername), for: .touchUpInside)
        profileImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleNewProfileImage)))
    }
    
    fileprivate func setupNavBar() {
        navigationItem.title = "Settings"
        
        let cancelBtn = UIBarButtonItem.init(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
        cancelBtn.tintColor = Colors.midnightBlue
        navigationItem.setLeftBarButton(cancelBtn, animated: true)
        
        let backBtnItem = UIBarButtonItem()
        backBtnItem.title = ""
        navigationItem.backBarButtonItem = backBtnItem
    }
    
    @objc private func handleLogout() {
        AuthService.shared.logout(onError: { (errMessage) in
            AlertService.shared.launchOkAlert(title: "Oops!", message: errMessage, sender: self)
        }) {
            UserDefaultsService.shared.logout()
            let navController = UINavigationController.init(rootViewController: LoginController())
            present(navController, animated: true, completion: nil)
        }
    }
    
    @objc private func handleNewProfileImage() {
        navigationController?.pushViewController(ProfileImageController(), animated: true)
    }
    
    private func setProfileImageAndUsername() {
        guard let currentUser = AppUser.currentUser, let piUrl = URL.init(string: currentUser.profileImageUrl) else { return }
        profileImageView.sd_setImage(with: piUrl, completed: nil)
        currentUsernameLabel.text = currentUser.username
    }
    
    @objc private func handleChangeUsername() {
        navigationController?.pushViewController(ChangeUsernameController(), animated: true)
    }
    
    @objc fileprivate func handleCancel() {
        navigationController?.popViewController(animated: true)
    }
    
}
