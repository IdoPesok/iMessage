//
//  AppUser.swift
//  Courier
//
//  Created by Ido Pesok on 3/26/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

class AppUser {
    
    static var currentUser: AppUser?
    
    var email: String
    var username: String
    var userId: String
    var profileImageUrl: String
    var chatIds: [String]
    
    convenience init?(values: [String: Any]) {
        guard let email = values[UserKeys.Email.rawValue] as? String, let username = values[UserKeys.Username.rawValue] as? String, let uid = values[UserKeys.UserId.rawValue] as? String, let profileImgUrl = values[UserKeys.ProfileImageUrl.rawValue] as? String else {
            return nil
        }
        
        var chatIds = [String]()
        if let chatIdsDict = values[UserKeys.ChatIds.rawValue] as? [String: Any] {
            chatIds = Array(chatIdsDict.keys)
        }
        
        self.init(email: email, username: username, userId: uid, profileUrl: profileImgUrl, chatIds: chatIds)
    }
    
    init(email: String, username: String, userId: String, profileUrl: String, chatIds: [String]) {
        self.email = email
        self.username = username
        self.userId = userId
        self.profileImageUrl = profileUrl
        self.chatIds = chatIds
    }
    
}
