//
//  CheckDiaryViewController.swift
//  MoodTracker
//
//  Created by Altan on 31.08.2023.
//

import UIKit

class CheckDiaryViewController: UIViewController {
    
    private let moodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 15
        textView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        textView.font = .systemFont(ofSize: 17)
        textView.textColor = .black
        textView.layer.borderWidth = 2
        textView.layer.borderColor = CGColor(red: 104/255, green: 52/255, blue: 212/255, alpha: 1)
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(moodLabel)
        view.addSubview(textView)
        view.backgroundColor = .white

        setConstraints()
    }
    
    func configure(mood: String, text: String) {
        moodLabel.text = "Mood: \(mood)"
        textView.text = text
    }

    private func setConstraints() {
        let moodLabelConstraints = [
            moodLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            moodLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ]
        
        let textViewConstraints = [
            textView.topAnchor.constraint(equalTo: moodLabel.bottomAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(moodLabelConstraints)
        NSLayoutConstraint.activate(textViewConstraints)
    }
    
}
