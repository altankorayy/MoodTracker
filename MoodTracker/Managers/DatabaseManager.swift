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
    
    func uploadDiaryText(id: String, title: String, mood: String, text: String, date: String, completion: @escaping(Bool) -> Void) {
        let diaryData: [String: Any] = ["title": title, "mood": mood, "text": text, "id": id, "date": date]
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
                      let diaryText = document.get("text") as? String,
                      let titleText = document.get("title") as? String,
                      let date = document.get("date") as? String else {
                    return
                }
                
                let diaryObject = MoodListModel(mood: mood, diaryText: diaryText, title: titleText, date: date)
                moodListModel.append(diaryObject)
            }
            completion(.success(moodListModel))
        }
    }
    
    func deleteUserDiary(title: String, completion: @escaping(Bool) -> Void) {
        database.collection("diary").whereField("title", isEqualTo: title).getDocuments { [weak self] snapshot, error in
            guard error == nil else {
                completion(false)
                return
            }
            for document in snapshot!.documents {
                let documentID = document.documentID
                self?.database.collection("diary").document(documentID).delete(completion: { error in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                })
            }
        }
    }
    
    func fetchUsername(email: String, completion: @escaping(Result<String, Error>) -> Void) {
        database.collection("users").whereField("email", isEqualTo: email).getDocuments { querySnapshot, error in
            guard let snapshot = querySnapshot, error == nil else {
                completion(.failure(DatabaseError.documentFindError))
                return
            }
            
            if let document = snapshot.documents.first {
                if let username = document["username"] as? String {
                    completion(.success(username))
                } else {
                    completion(.failure(DatabaseError.documentFetchError))
                }
            } else {
                completion(.failure(DatabaseError.documentFindError))
            }
        }
    }
    
    enum DatabaseError: Error {
        case getDocumentError
        case documentFindError
        case documentFetchError
    }
}
