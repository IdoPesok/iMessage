//
//  ChatController.swift
//  Courier
//
//  Created by Ido Pesok on 3/31/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

class ChatController: UITableViewController, MessageInputViewDelegate {
    
    var chat: Chat?
    
    fileprivate let cellId = "message_cell_id"
    
    fileprivate var chatToUser: AppUser?
    
    var selectedMessageId = ""
    
    // sorted by sections
    fileprivate var messages = [[Message]]()
    // all messages
    fileprivate var allMessages = [Message]()

    fileprivate let hiddenTextField: UITextField = {
        let tf = UITextField()
        tf.isHidden = true
        
        return tf
    }()
    
    fileprivate let messageInputView = MessageInputView()
    
    fileprivate var navBarTitleView: NavBarTitleView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupTableView()
        retrieveMessages()
        checkForDeletedMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavBar()
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        removeKeyboardObservers()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessageCell
        
        let msg = messages[indexPath.section][indexPath.row]
        cell.setMessage(msg)
        addLongPressRecognizerForCell(cell: cell) 
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setupHeaderViewForSection(section)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = Colors.cloudWhite
        
        // Add Subviews
        [hiddenTextField].forEach({ view.addSubview($0) })
        
        // Hidden Text Field
        hiddenTextField.becomeFirstResponder()
        hiddenTextField.endEditing(true)
    }
    
    override init(style: UITableView.Style) {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupTableView() {
        tableView.keyboardDismissMode = .interactive
        tableView.backgroundColor = .white
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.contentInset = UIEdgeInsets.init(top: 8, left: 0, bottom: 8, right: 0)
        tableView.register(MessageCell.self, forCellReuseIdentifier: cellId)
        
        let gestureRecognizer = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(handlePanGesture(_:)))
        gestureRecognizer.edges = .right
        tableView.addGestureRecognizer(gestureRecognizer)
    }
    
    override var inputAccessoryView: UIView? {
        messageInputView.autoresizingMask = .flexibleHeight
        messageInputView.setDelegate(self)
        return messageInputView
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    fileprivate func setupNavBar() {
        guard let nc = navigationController else { return }
        nc.navigationBar.backItem?.title = ""
        navBarTitleView = NavBarTitleView.init(height: nc.navigationBar.frame.height)
        navigationItem.titleView = navBarTitleView
    }
    
    func setChat(_ chat: Chat) {
        self.chat = chat
        getChatToUser()
    }
    
    func getChatToUser() {
        if let c = chat {
            UserService.shared.retrieveUserWithId(c.chatToUserId) { (user) in
                self.chatToUser = user
                guard let nbtv = self.navBarTitleView else { return }
                nbtv.titleLabel.text = user.username
                nbtv.profileImageView.sd_setImage(with: URL.init(string: user.profileImageUrl), completed: nil)
            }
        }
    }
    
    func handleSend(message: String) {
        if let chat = chat {
            MessageService.shared.sendMessage(text: message, chat: chat, error: { (errMessage) in
                AlertService.shared.launchOkAlert(title: "Oops!", message: errMessage, sender: self)
            }) {
                print("message was sent")
            }
        }
    }
    
    fileprivate func retrieveMessages() {
        if let chat = chat {
            MessageService.shared.retrieveMessagesFromChat(chat) { (message) in
                self.allMessages.append(message)
                self.sortMessagesByDate()
                self.tableView.reloadData()
                self.scrollToBottom()
            }
        }
    }
    
    private func checkForDeletedMessages() {
        if let chat = chat {
            MessageService.shared.observeForDeletedMessagesInChat(chat) { (messageId) in
                print(messageId)
                self.allMessages.removeAll(where: { $0.messageId == messageId })
                self.sortMessagesByDate()
                self.tableView.reloadData()
                self.scrollToBottom()
            }
        }
    }
    
    @objc fileprivate func scrollToBottom() {
        guard messages.count > 0 else { return }
        let lastSection = messages.count - 1
        let indexPath = IndexPath.init(row: self.messages[lastSection].count - 1, section: lastSection)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    fileprivate func sortMessagesByDate() {
        messages = [[Message]]()
        let groupedMessages = Dictionary.init(grouping: allMessages) { (message) -> String in
            return message.timestamp.toString()
        }
        
        let sortedKeys = groupedMessages.keys.sorted()
        sortedKeys.forEach { (key) in
            var values = groupedMessages[key]
            values?.sort(by: { $0.timestamp < $1.timestamp })
            messages.append(values ?? [])
        }
    }
    
    fileprivate func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToBottom), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToBottom), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    fileprivate func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handlePanGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: tableView)
        tableView.contentOffset = CGPoint.init(x: -(translation.x / 3), y: tableView.contentOffset.y)
        
        if gestureRecognizer.state == .ended {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.tableView.contentOffset = CGPoint.init(x: 0, y: self.tableView.contentOffset.y)
            }, completion: nil)
        }
    }
    
    fileprivate func setupHeaderViewForSection(_ section: Int) -> UIView? {
        let containerView = UIView()
        if let message = messages[section].first {
            let dateString = message.timestamp.toString()
            let label = DateHeaderLabel.init(text: dateString)
            
            containerView.addSubview(label)
            label.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, centerX: containerView.centerXAnchor, centerY: containerView.centerYAnchor)
            
            return containerView
        }
        
        return nil
    }
    
}
