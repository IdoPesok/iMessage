//
//  Chat.swift
//  Courier
//
//  Created by Ido Pesok on 4/1/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

class Chat {
    
    var chatId: String
    var participantIds: [String]
    var messageIds: [String]
    var createdTimestamp: TimeInterval
    var creatorUserId: String
    var chatToUserId: String
    var lastMessageTimestamp: TimeInterval
    var lastMessageId: String
    
    convenience init?(values: [String: Any]) {
        guard let chatId = values[ChatKeys.ChatId.rawValue] as? String, let createdTimestamp = values[ChatKeys.CreatedTimestamp.rawValue] as? TimeInterval, let creatorUserId = values[ChatKeys.CreatorUserId.rawValue] as? String, let participantIds = values[ChatKeys.ParticipantIds.rawValue] as? [String: Any], let lastMessageTS = values[ChatKeys.LastMessageTimestamp.rawValue] as? TimeInterval, let lastMessageId = values[ChatKeys.LastMessageId.rawValue] as? String else {
            return nil
        }
        
        var messageIds = [String]()
        if let messageIdsDict = values[ChatKeys.MessageIds.rawValue] as? [String: Any] {
            messageIds = Array(messageIdsDict.keys)
        }
        
        self.init(chatId: chatId, participantIds: Array(participantIds.keys), messageIds: messageIds, createdTimestamp: createdTimestamp, creatorUserId: creatorUserId, lastMessageTS: lastMessageTS, lastMessageId: lastMessageId)
    }
    
    init(chatId: String, participantIds: [String], messageIds: [String], createdTimestamp: TimeInterval, creatorUserId: String, lastMessageTS: TimeInterval, lastMessageId: String) {
        self.chatId = chatId
        self.participantIds = participantIds
        self.messageIds = messageIds
        self.createdTimestamp = createdTimestamp
        self.lastMessageTimestamp = lastMessageTS
        self.creatorUserId = creatorUserId
        self.chatToUserId = ""
        self.lastMessageId = lastMessageId
        
        if participantIds.count == 2 {
            if let userId = participantIds.first(where: { $0 != AppUser.currentUser?.userId }) {
                self.chatToUserId = userId
            }
        }
    }
    
    static func getChatValues(userIds: [String]) -> ([String: Any], String)? {
        if let participantIds = self.setupParticipantIds(userIds: userIds), let currentUser = AppUser.currentUser {
            let uuid = UUID.init().uuidString
            let timestamp = Date().timeIntervalSince1970
            
            let value = [ChatKeys.CreatedTimestamp.rawValue: timestamp, ChatKeys.ChatId.rawValue: uuid, ChatKeys.CreatorUserId.rawValue: currentUser.userId, ChatKeys.ParticipantIds.rawValue: participantIds, ChatKeys.LastMessageTimestamp.rawValue: timestamp, ChatKeys.LastMessageId.rawValue: ""] as [String : Any]
            return (value, uuid)
        }
        
        return nil
    }
    
    static fileprivate func setupParticipantIds(userIds: [String]) -> [String: Any]? {
        var participantIds = [String: Int]()
        for id in userIds {
            participantIds[id] = 1
        }
        
        return participantIds
    }
    
}
