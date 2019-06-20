//
//  DatabaseReferences.swift
//  Courier
//
//  Created by Ido Pesok on 3/26/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit
import Firebase

struct DatabaseReferences {
    
    static let users = Database.database().reference().child(DatabaseKeys.Users.rawValue)
    static let messages = Database.database().reference().child(DatabaseKeys.Messages.rawValue)
    static let chats = Database.database().reference().child(DatabaseKeys.Chats.rawValue)
    
}
