//
//  DatabaseKeys.swift
//  Courier
//
//  Created by Ido Pesok on 3/26/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

enum DatabaseKeys: String {
    case Users, Messages, Chats
}

enum UserKeys: String {
    case Email, Username
    case UserId = "User_Id"
    case ChatIds = "Chat_Ids"
    case ProfileImageUrl = "Profile_Image_Url"
}

enum MessageKeys: String {
    case Text, Timestamp
    case FromUserId = "From_User_Id"
    case MessageId = "Message_Id"
    case ChatId = "Chat_Id"
}

enum ChatKeys: String {
    case ChatId = "Chat_Id"
    case ParticipantIds = "Participant_Ids"
    case MessageIds = "Message_Ids"
    case CreatedTimestamp = "Created_Timestamp"
    case CreatorUserId = "Creator_User_Id"
    case LastMessageTimestamp = "Last_Message_Timestamp"
    case LastMessageId = "Last_Message_Id"
}
