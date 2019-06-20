//
//  HomeController.swift
//  Courier
//
//  Created by Ido Pesok on 3/26/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

class HomeController: UITableViewController {
    
    fileprivate let cellId = "chat_cell_id"
    
    fileprivate var chats = [Chat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkLogin()
        setupNavBar()
        sortChats()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatCell
        
        cell.setChat(chats[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        goToChat(chats[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    fileprivate func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(ChatCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UserCell.imageViewSize + 20
    }
    
    fileprivate func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Chat"
        navigationItem.largeTitleDisplayMode = .always
        
        let rightBtn = UIBarButtonItem.init(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
        rightBtn.tintColor = Colors.midnightBlue
        navigationItem.setRightBarButton(rightBtn, animated: true)
        
        let settingsIcon = UIImage.init(named: "settings")
        let leftBtn = UIBarButtonItem.init(image: settingsIcon, style: .plain, target: self, action: #selector(handleSettings))
        leftBtn.tintColor = Colors.midnightBlue
        navigationItem.setLeftBarButton(leftBtn, animated: true)
        
        let backBtnItem = UIBarButtonItem()
        backBtnItem.title = ""
        navigationItem.backBarButtonItem = backBtnItem
    }
    
    @objc fileprivate func handleNewMessage() {
        let vc = NewMessageController.init(collectionViewLayout: UICollectionViewFlowLayout())
        vc.setHomeController(self)
        vc.setChats(chats)
        let navController = UINavigationController.init(rootViewController: vc)
        present(navController, animated: true, completion: nil)
    }
    
    fileprivate func retrieveChats(completion: (() -> Void)?) {
        ChatService.shared.retrieveAllChatsForCurrentUser { (chats) in
            self.chats = chats
            self.sortChats()
            self.tableView.reloadData()
            if completion != nil {
                completion!()
            }
        }
    }
    
    @objc func handleSettings() {
        navigationController?.pushViewController(SettingsController(), animated: true)
    }
    
    private func logout() {
        AuthService.shared.logout(onError: { (errMessage) in
            AlertService.shared.launchOkAlert(title: "Oops!", message: errMessage, sender: self)
        }) {
            UserDefaultsService.shared.logout()
            let navController = UINavigationController.init(rootViewController: LoginController())
            present(navController, animated: true, completion: nil)
        }
    }
    
    func goToChat(_ chat: Chat) {
        let vc = ChatController.init(style: .grouped)
        vc.setChat(chat)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateChatsThenGoToChatWithId(_ id: String) {
        retrieveChats {
            if let chat = self.chats.first(where: { $0.chatId == id }) {
                self.goToChat(chat)
            }
        }
    }
    
    // auto login
    fileprivate func checkLogin() {
        AuthService.shared.isLoggedIn { (bool, uid) in
            if !bool || uid == nil {
                self.logout()
            } else if AppUser.currentUser == nil {
                UserService.shared.retrieveUserWithId(uid!, completion: { (user) in
                    AppUser.currentUser = user
                    self.retrieveChats(completion: nil)
                })
            } else {
                self.retrieveChats(completion: nil)
            }
        }
    }
    
    fileprivate func sortChats() {
        chats.sort { (chatOne, chatTwo) -> Bool in
            chatOne.lastMessageTimestamp > chatTwo.lastMessageTimestamp
        }
    }
    
}
