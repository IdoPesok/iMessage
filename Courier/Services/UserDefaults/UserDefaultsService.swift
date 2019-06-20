//
//  UserDefaultsService.swift
//  Courier
//
//  Created by Ido Pesok on 3/27/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit
import Firebase

class UserDefaultsService {
    
    static let shared = UserDefaultsService()
    
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    func login() {
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func logout() {
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        UserDefaults.standard.synchronize()
    }
    
}
