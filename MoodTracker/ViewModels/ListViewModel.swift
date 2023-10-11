//
//  ListViewModel.swift
//  MoodTracker
//
//  Created by Altan on 11.10.2023.
//

import Foundation

class ListViewModel {
    
    var didDeleteDiary: Bool?
    
    func deleteUserDiary(model: [MoodListModel], indexPath: Int) {
        let selectedDiary = model[indexPath].title
        
        DatabaseManager.shared.deleteUserDiary(title: selectedDiary) { [weak self] success in
            if success {
                self?.didDeleteDiary = true
            } else {
                self?.didDeleteDiary = false
            }
        }
    }
}
