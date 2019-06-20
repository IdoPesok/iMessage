//
//  UserService.swift
//  Courier
//
//  Created by Ido Pesok on 4/1/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit
import Firebase

class UserService {
    
    static let shared = UserService()
    
    func addUserToDatabase(user: User, username: String, error: @escaping (String) -> Void, completion: @escaping (User) -> Void) {
        let userValue = [UserKeys.Email.rawValue: user.email, UserKeys.Username.rawValue: username, UserKeys.ProfileImageUrl.rawValue: ProfilePictureKeys.defaultUrl.rawValue]
        DatabaseReferences.users.child(user.uid).setValue(userValue) { (err, userRef) in
            if err != nil {
                error(err!.localizedDescription)
                return
            }
            self.setUserId(userRef: userRef, user: user, error: error, completion: completion)
        }
    }
    
    func setUserId(userRef: DatabaseReference, user: User, error: @escaping (String) -> Void, completion: @escaping (User) -> Void) {
        let value = [UserKeys.UserId.rawValue: user.uid]
        DatabaseReferences.users.child(userRef.key).updateChildValues(value) { (err, ref) in
            if err != nil {
                error(err!.localizedDescription)
            }
            
            completion(user)
        }
    }
    
    func retrieveUserWithId(_ id: String, completion: @escaping (AppUser) -> Void) {
        DatabaseReferences.users.child(id).observeSingleEvent(of: .value) { (snapshot) in
            if let snapValue = snapshot.value as? [String: Any], let user = AppUser.init(values: snapValue) {
                completion(user)
            }
        }
    }
    
    func retrieveAllUsers(completion: @escaping ([AppUser]) -> Void) {
        DatabaseReferences.users.observeSingleEvent(of: .value, with: { (snapshot) in
            if let userSnaps = snapshot.children.allObjects as? [DataSnapshot] {
                var users = [AppUser]()
                for userSnap in userSnaps {
                    if let userValue = userSnap.value as? [String: Any], let user = AppUser.init(values: userValue) {
                        users.append(user)
                    }
                }
                
                completion(users)
            }
        })
    }
    
    func checkIfUsernameExists(username: String, error: @escaping (String) -> Void, completion: @escaping () -> Void) {
        retrieveAllUsers { (users) in
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
    
    func changeUsernameTo(newUsername: String, onError: @escaping (String) -> Void, completion: @escaping () -> Void) {
        guard let currentUser = AppUser.currentUser else { return }
        checkIfUsernameExists(username: newUsername, error: { (err) in
            onError(err)
        }) {
            let values = [UserKeys.Username.rawValue: newUsername]
            DatabaseReferences.users.child(currentUser.userId).updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    onError("There has been an unknown error. Please try again.")
                    return
                }
                
                completion()
            })
        }
    }
    
    func changeProfileImageUrl(_ url: String, onError: @escaping (String) -> Void, completion: @escaping () -> Void) {
        guard let currentUser = AppUser.currentUser else { return }
        let values = [UserKeys.ProfileImageUrl.rawValue: url]
        
        DatabaseReferences.users.child(currentUser.userId).updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                onError("There has been an unknown error. Please try again.")
                return
            }
            
            completion()
        })
    }
    
}
