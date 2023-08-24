//
//  RegisterViewModel.swift
//  MoodTracker
//
//  Created by Altan on 23.08.2023.
//

import Foundation

protocol AuthErrorDelegate: AnyObject {
    func registerError(error: String)
}

protocol DatabaseErrorDelegate: AnyObject {
    func uploadUserError(error: String)
}

class RegisterViewModel {
    
    var email: String?
    var username: String?
    var password: String?
    
    weak var registerErrorDelegate: AuthErrorDelegate?
    weak var uploadUserErrorDelegate: DatabaseErrorDelegate?
    
    public func registerUser() {
        guard let email = email, let username = username, let password = password else { return }
        
        AuthManager.shared.registerUser(username: username, email: email, password: password) { [weak self] completed, error in
            if completed {
                DatabaseManager.shared.uploadUserInfo(username: username, email: email) { uploaded in
                    if uploaded {
                        NotificationCenter.default.post(name: NSNotification.Name("userCompleted"), object: nil)
                    } else {
                        guard let errorString = error else { return }
                        self?.uploadUserErrorDelegate?.uploadUserError(error: errorString)
                    }
                }
            } else {
                guard let errorString = error else { return }
                self?.registerErrorDelegate?.registerError(error: errorString)
            }
        }
    }
}
