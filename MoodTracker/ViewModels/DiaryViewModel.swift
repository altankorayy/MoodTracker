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
    var title: String?
    
    public func uploadDiaryText() {
        guard let titleString = title, let moodString = mood, let textString = text, let userId = Auth.auth().currentUser?.uid else { return }
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let currentDate = dateFormatter.string(from: today)
        DatabaseManager.shared.uploadDiaryText(id: userId, title: titleString, mood: moodString, text: textString, date: currentDate) { completed in
            if completed {
                NotificationCenter.default.post(name: NSNotification.Name("diaryUploaded"), object: nil)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name("diaryUploadError"), object: nil)
            }
        }
    }
}
