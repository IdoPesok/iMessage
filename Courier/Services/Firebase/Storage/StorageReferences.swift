//
//  StorageReferences.swift
//  Courier
//
//  Created by Ido Pesok on 4/1/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit
import Firebase

struct StorageReferences {
    
    static let profilePictures = Storage.storage().reference().child(StorageKeys.profilePictures.rawValue)
    
}
