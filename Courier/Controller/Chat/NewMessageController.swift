//
//  NewMessageController.swift
//  Courier
//
//  Created by Ido Pesok on 3/30/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

class NewMessageController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "user__cell"
    
    fileprivate var users = [AppUser]()
    
    fileprivate var homeController: HomeController?
    
    fileprivate var chats = [Chat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        retrieveUsers()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserCell
        
        cell.setUser(user: users[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.size.width - 40) / 2.0
        let height = UserCell.imageViewSize + UserCell.usernameLabelHeight + 30
        return CGSize.init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedUser = self.users[indexPath.item]
        if let chat = chats.first(where: { $0.chatToUserId == selectedUser.userId }) {
            homeController?.goToChat(chat)
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        createChat(selectedUser: selectedUser) { (chatId) in
            self.homeController?.updateChatsThenGoToChatWithId(chatId)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    fileprivate func setupViews() {
        collectionView.backgroundColor = Colors.cloudWhite
    }
    
    fileprivate func setupCollectionView() {
        collectionView.contentInset = UIEdgeInsets.init(top: 10, left: 20, bottom: 0, right: 20)
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    fileprivate func setupNavBar() {
        navigationItem.title = "New Message"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.setLeftBarButton(UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel)), animated: true)
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func retrieveUsers() {
        UserService.shared.retrieveAllUsers { (users) in
            self.users = users
            self.sortUsers()
            self.collectionView.reloadData()
        }
    }
    
    fileprivate func sortUsers() {
        self.users.sort { (userOne, userTwo) -> Bool in
            return userOne.username < userTwo.username
        }
        users.removeAll(where: { $0.username == AppUser.currentUser?.username })
    }
    
    func setHomeController(_ vc: HomeController) {
        self.homeController = vc
    }
    
    func setChats(_ chats: [Chat]) {
        self.chats = chats
    }
    
    fileprivate func createChat(selectedUser: AppUser, completion: @escaping (String) -> Void) {
        guard let currentUser = AppUser.currentUser else {
            return
        }
        let participantIds = [selectedUser.userId, currentUser.userId]
        
        ChatService.shared.createNewChat(userIds: participantIds, error: { (errMessage) in
            AlertService.shared.launchOkAlert(title: "Oops!", message: errMessage, sender: self)
        }) { (chatId) in
            completion(chatId)
        }
    }
    
}
