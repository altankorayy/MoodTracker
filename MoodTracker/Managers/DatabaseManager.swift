//
//  StorageManager.swift
//  MoodTracker
//
//  Created by Altan on 23.08.2023.
//

import Foundation
import FirebaseFirestore

class DatabaseManager {
    
    static let shared = DatabaseManager()
    let database = Firestore.firestore()
    
    func uploadUserInfo(username: String, email: String, completion: @escaping(Bool) -> Void) {
        let userData: [String: Any] = ["username": username, "email": email]
        database.collection("users").addDocument(data: userData) { error in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func uploadDiaryText(mood: String, text: String, completion: @escaping(Bool) -> Void) {
        let diaryData: [String: Any] = ["mood": mood, "text": text]
        database.collection("diary").addDocument(data: diaryData) { error in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
}
