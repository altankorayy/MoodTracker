//
//  LoginViewModel.swift
//  MoodTracker
//
//  Created by Altan on 23.08.2023.
//

import Foundation

protocol AuthLoginErrorDelegate: AnyObject {
    func loginError(error: String)
}

class LoginViewModel {
    
    var email: String?
    var password: String?
    
    weak var errorDelegate: AuthLoginErrorDelegate?
    
    func loginUser() {
        guard let email = email, let password = password else { return }
        
        AuthManager.shared.loginUser(email: email, password: password) { [weak self] completed, error in
            if completed {
                NotificationCenter.default.post(name: NSNotification.Name("userLoginCompleted"), object: nil)
            } else {
                guard let errorString = error else { return }
                self?.errorDelegate?.loginError(error: errorString)
            }
        }
    }
}
