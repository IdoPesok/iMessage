//
//  ChatService.swift
//  Courier
//
//  Created by Ido Pesok on 4/1/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit
import Firebase

class ChatService {
    
    static let shared = ChatService()
    
    func createNewChat(userIds: [String], error: @escaping (String) -> Void, completion: @escaping (String) -> Void) {
        guard let (value, uuid) = Chat.getChatValues(userIds: userIds) else {
            error("Could not create a chat due to an unknown error. Please try again.")
            return
        }
        
        DatabaseReferences.chats.child(uuid).setValue(value) { (err, chatRef) in
            if err != nil {
                error("Could not create a chat due to an unknown error. Please try again.")
                return
            }
            
            self.addChatToUsers(userIds: userIds, chatId: uuid, error: error, completion: completion)
        }
    }
    
    func addChatToUsers(userIds: [String], chatId: String, error: @escaping (String) -> Void, completion: @escaping (String) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        for id in userIds {
            dispatchGroup.enter()
            
            addChatToUser(userId: id, chatId: chatId, error: error) {
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            AppUser.currentUser?.chatIds.append(chatId)
            completion(chatId)
        }
    }
    
    func addChatToUser(userId: String, chatId: String, error: @escaping (String) -> Void, completion: @escaping () -> Void) {
        DatabaseReferences.users.child(userId).child(UserKeys.ChatIds.rawValue).child(chatId).setValue(1) { (err, chatRef) in
            if err != nil {
                error("Could not create your chat due to an unknown error. Please try again later.")
                return
            }
            
            completion()
        }
    }
    
    func retrieveChatWithId(_ id: String, completion: @escaping (Chat) -> Void) {
        DatabaseReferences.chats.child(id).observeSingleEvent(of: .value) { (snapshot) in
            if let snapValue = snapshot.value as? [String: Any], let chat = Chat.init(values: snapValue) {
                completion(chat)
            }
        }
    }
    
    func retrieveAllChats(completion: @escaping ([Chat]) -> Void) {
        var chats = [Chat]()
        DatabaseReferences.chats.observeSingleEvent(of: .value) { (snapshot) in
            if let children = snapshot.children.allObjects as? [DataSnapshot] {
                for snapValue in children {
                    if let value = snapValue.value as? [String: Any], let chat = Chat.init(values: value) {
                        chats.append(chat)
                    }
                }
            }
            
            completion(chats)
        }
    }
    
    func retrieveAllChatsForCurrentUser(completion: @escaping ([Chat]) -> Void) {
        guard let currentUser = AppUser.currentUser else {
            return
        }
        let dispatchGroup = DispatchGroup()
        var chats = [Chat]()
        for id in currentUser.chatIds {
            dispatchGroup.enter()
            
            retrieveChatWithId(id) { (chat) in
                chats.append(chat)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(chats)
        }
    }
    
    func addMessageToChat(chatId: String, messageId: String, error: @escaping (String) -> Void, completion: @escaping () -> Void) {
        let chatRef = DatabaseReferences.chats.child(chatId)
        chatRef.child(ChatKeys.MessageIds.rawValue).child(messageId).setValue(1) { (err, messageRef) in
            if err != nil {
                error("Could not send your message due to an unknown error. Please try again later.")
                return
            }
            self.addLastMessageToChat(chatId: chatId, messageId: messageId, error: error, completion: completion)
        }
    }
    
    func addLastMessageToChat(chatId: String, messageId: String, error: @escaping (String) -> Void, completion: @escaping () -> Void) {
        let chatRef = DatabaseReferences.chats.child(chatId)
        let timestamp = Date.init().timeIntervalSince1970
        chatRef.child(ChatKeys.LastMessageTimestamp.rawValue).setValue(timestamp, withCompletionBlock: { (err, ref) in
            if err != nil {
                error("Could not send your message due to an unknown error. Please try again later.")
                return
            }
            
            self.addLastMessageIdToChat(chatId: chatId, messageId: messageId, error: error, completion: completion)
        })
    }
    
    func addLastMessageIdToChat(chatId: String, messageId: String, error: @escaping (String) -> Void, completion: @escaping () -> Void) {
        let chatRef = DatabaseReferences.chats.child(chatId)
        chatRef.child(ChatKeys.LastMessageId.rawValue).setValue(messageId, withCompletionBlock: { (err, ref) in
            if err != nil {
                error("Could not send your message due to an unknown error. Please try again later.")
                return
            }
            
            completion()
        })
    }

}
