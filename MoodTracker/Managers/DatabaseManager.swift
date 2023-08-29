//
//  StorageManager.swift
//  MoodTracker
//
//  Created by Altan on 23.08.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

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
    
    func uploadDiaryText(id: String, mood: String, text: String, completion: @escaping(Bool) -> Void) {
        let diaryData: [String: Any] = ["mood": mood, "text": text, "id": id]
        database.collection("diary").addDocument(data: diaryData) { error in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func fetchUserDiary(id: String, completion: @escaping(Result<[MoodListModel], Error>) -> Void) {
        var moodListModel = [MoodListModel]()
        
        database.collection("diary").whereField("id", isEqualTo: id).getDocuments { snapshot, error in
            guard error == nil else {
                completion(.failure(DatabaseError.documentFindError))
                return
            }
            
            for document in snapshot!.documents {
                guard let mood = document.get("mood") as? String,
                      let diaryText = document.get("text") as? String else {
                    return
                }
                
                let diaryObject = MoodListModel(mood: mood, diaryText: diaryText)
                moodListModel.append(diaryObject)
            }
            completion(.success(moodListModel))
        }
    }
    
    enum DatabaseError: Error {
        case documentFindError
    }
}
