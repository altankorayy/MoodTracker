//
//  DiaryViewModel.swift
//  MoodTracker
//
//  Created by Altan on 27.08.2023.
//

import Foundation
import FirebaseAuth

class DiaryViewModel {
    
    var mood: String?
    var text: String?
    
    public func uploadDiaryText() {
        guard let moodString = mood, let textString = text, let userId = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.uploadDiaryText(id: userId, mood: moodString, text: textString) { completed in
            if completed {
                NotificationCenter.default.post(name: NSNotification.Name("diaryUploaded"), object: nil)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name("diaryUploadError"), object: nil)
            }
        }
    }
}
