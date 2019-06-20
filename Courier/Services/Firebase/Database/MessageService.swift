//
//  MessageService.swift
//  Courier
//
//  Created by Ido Pesok on 4/1/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit
import Firebase

class MessageService {
    
    static let shared = MessageService()
    
    func sendMessage(text: String, chat: Chat, error: @escaping (String) -> Void, completion: @escaping () -> Void) {
        MessageService.shared.createMessage(text: text, chat: chat, error: error) { (messageId) in
            ChatService.shared.addMessageToChat(chatId: chat.chatId, messageId: messageId, error: error, completion: completion)
        }
    }
    
    func createMessage(text: String, chat: Chat, error: @escaping (String) -> Void, completion: @escaping (String) -> Void) {
        guard let (value, uuid) = Message.getMessageValues(text: text, chat: chat) else {
            error("Could not send your message due to an unknown error. Please try again.")
            return
        }
        
        DatabaseReferences.messages.child(uuid).setValue(value) { (err, messageRef) in
            if err != nil {
                error("Could not send your message due to an unknown error. Please try again.")
                return
            }
            
            completion(uuid)
        }
    }
    
    func retrieveMessageWithId(_ id: String, completion: @escaping (Message) -> Void) {
        DatabaseReferences.messages.child(id).observeSingleEvent(of: .value) { (snapshot) in
            if let snapValue = snapshot.value as? [String: Any], let message = Message.init(values: snapValue) {
                completion(message)
            } else {
                let deletedMessage = Message.init(timestamp: TimeInterval.init(), chatId: "", fromUserId: "", text: "Message Deleted", messageId: "")
                completion(deletedMessage)
            }
        }
    }
    
    func retrieveMessagesFromChat(_ chat: Chat, completion: @escaping (Message) -> Void) {
        DatabaseReferences.chats.child(chat.chatId).child(ChatKeys.MessageIds.rawValue).observe(.childAdded) { (snapshot) in
            let messageId = snapshot.key
            MessageService.shared.retrieveMessageWithId(messageId, completion: completion)
        }
    }
    
    func deleteMessage(chatId: String, messageId: String, onError: @escaping (String) -> Void, completion: @escaping () -> Void) {
        DatabaseReferences.chats.child(chatId).child(ChatKeys.MessageIds.rawValue).child(messageId).removeValue { (err, ref) in
            if err != nil {
                onError("Could not delete your message due to an unknown error.")
                return
            }
            
            DatabaseReferences.messages.child(messageId).removeValue { (err, ref) in
                if err != nil {
                    onError("Could not delete your message due to an unknown error.")
                    return
                }
                
                completion()
            }
        }
    }
    
    func observeForDeletedMessagesInChat(_ chat: Chat, completion: @escaping (String) -> Void) {
        DatabaseReferences.chats.child(chat.chatId).child(ChatKeys.MessageIds.rawValue).observe(.childRemoved) { (snap) in
            completion(snap.key)
        }
    }
    
}
