//
//  AuthManager.swift
//  MoodTracker
//
//  Created by Altan on 23.08.2023.
//

import Foundation
import FirebaseAuth

class AuthManager {
    
    static let shared = AuthManager()
    
    func registerUser(username: String, email: String, password: String, completion: @escaping(Bool, String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping(Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }
}
