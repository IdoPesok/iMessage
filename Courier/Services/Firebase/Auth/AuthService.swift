//
//  AuthService.swift
//  Courier
//
//  Created by Ido Pesok on 3/26/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit
import Firebase

class AuthService {
    
    static let shared = AuthService()
    
    func createUser(email: String, username: String, password: String, error: @escaping (String) -> Void, completion: @escaping (User) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            guard err == nil && user != nil else {
                error(err!.localizedDescription)
                return
            }
            
            UserService.shared.addUserToDatabase(user: user!, username: username, error: error, completion: completion)
        }
    }
    
    func checkIfUsernameExists(username: String, error: @escaping (String) -> Void, completion: @escaping () -> Void) {
        UserService.shared.retrieveAllUsers { (users) in 
            var foundUsername = false
            for user in users {
                if user.username == username {
                    foundUsername = true
                    break
                }
            }
            if foundUsername {
                error("Oops! An account already exists with that username.")
            } else {
                completion()
            }
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func signIn(email: String, password: String, error: @escaping (String) -> Void, completion: @escaping (AppUser) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
            guard err == nil, let user = user else {
                error("Oops! " + err!.localizedDescription)
                return
            }
            
            UserService.shared.retrieveUserWithId(user.uid, completion: completion)
        }
    }
    
    func isLoggedIn(completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                completion(true, user!.uid)
            } else {
                completion(false, nil)
            }
        }
    }
    
    func logout(onError: (String) -> Void, completion: () -> Void) {
        do {
            try Auth.auth().signOut()
            AppUser.currentUser = nil
            completion()
        } catch {
            onError("Could not logout due to an unknown error. Please try again later.")
        }
    }
    
}
