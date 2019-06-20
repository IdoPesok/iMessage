//
//  Message.swift
//  Courier
//
//  Created by Ido Pesok on 4/1/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

class Message {
    
    var timestamp: TimeInterval
    var fromUserId: String
    var text: String
    var messageId: String
    var chatId: String
    
    convenience init?(values: [String: Any]) {
        guard let timestamp = values[MessageKeys.Timestamp.rawValue] as? TimeInterval, let chatId = values[MessageKeys.ChatId.rawValue] as? String, let fromUserId = values[MessageKeys.FromUserId.rawValue] as? String, let text = values[MessageKeys.Text.rawValue] as? String, let messageId = values[MessageKeys.MessageId.rawValue] as? String else {
            return nil
        }
        
        self.init(timestamp: timestamp, chatId: chatId, fromUserId: fromUserId, text: text, messageId: messageId)
    }
    
    init(timestamp: TimeInterval, chatId: String, fromUserId: String, text: String, messageId: String) {
        self.timestamp = timestamp
        self.chatId = chatId
        self.fromUserId = fromUserId
        self.text = text
        self.messageId = messageId
    }
    
    static func getMessageValues(text: String, chat: Chat) -> ([String: Any], String)? {
        guard let currentUser = AppUser.currentUser else {
            return nil
        }
        
        let uuid = UUID.init().uuidString
        let value = [MessageKeys.Timestamp.rawValue: Date().timeIntervalSince1970, MessageKeys.FromUserId.rawValue: currentUser.userId, MessageKeys.ChatId.rawValue: chat.chatId, MessageKeys.Text.rawValue: text, MessageKeys.MessageId.rawValue: uuid] as [String : Any]
        return (value, uuid)
    }
    
}
