//
//  HomeViewModel.swift
//  MoodTracker
//
//  Created by Altan on 9.10.2023.
//

import Foundation
import FirebaseAuth

class HomeViewModel {
    
    var username: String?
    var error: String?
    
    var didFetch: (() -> Void)?
    
    func getUsername() {
        guard let email = Auth.auth().currentUser?.email else { return }
        DatabaseManager.shared.fetchUsername(email: email) { [weak self] result in
            switch result {
            case .success(let username):
                self?.username = username
                self?.didFetch?()
            case .failure(let error):
                self?.error = error.localizedDescription
            }
        }
    }
    
}
