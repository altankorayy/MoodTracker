//
//  DiaryViewController.swift
//  MoodTracker
//
//  Created by Altan on 23.08.2023.
//

import UIKit

class DiaryViewController: UIViewController {
    
    private let diaryShowLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Why are you Happy? Write on your diary."
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 8
        textView.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        textView.text = "Write your feelings"
        textView.font = .systemFont(ofSize: 17)
        textView.textColor = .gray
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

}
