//
//  DiaryViewController.swift
//  MoodTracker
//
//  Created by Altan on 23.08.2023.
//

import UIKit
import JGProgressHUD

class DiaryViewController: UIViewController {
    
    private let diaryShowLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Diary"
        label.font = .systemFont(ofSize: 30, weight: .heavy)
        label.textColor = .black
        return label
    }()
    
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 15
        textView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        textView.text = "Write about your feelings"
        textView.font = .systemFont(ofSize: 17)
        textView.textColor = .gray
        textView.layer.borderWidth = 2
        textView.layer.borderColor = CGColor(red: 104/255, green: 52/255, blue: 212/255, alpha: 1)
        return textView
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 104/255, green: 52/255, blue: 212/255, alpha: 1)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18 ,weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        return button
    }()
    
    private let viewModel = DiaryViewModel()
    private var spinner = JGProgressHUD(style: .light)
    
    var moodString: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(diaryShowLabel)
        view.addSubview(diaryTextView)
        view.addSubview(saveButton)
        setConstraints()
        
        navigationController?.navigationBar.isHidden = true
        diaryTextView.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapGesture))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(successUpload), name: NSNotification.Name("diaryUploaded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(failedToUpload), name: NSNotification.Name("diaryUploadError"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let moodString = moodString else { return }
        viewModel.mood = moodString
    }
    
    @objc private func didTapGesture() {
        view.endEditing(true)
    }
    
    @objc private func didTapSaveButton() {
        if diaryTextView.text.count <= 10 {
            makeAlert(title: "Error", message: "Text must be more than 10 characters.")
        } else {
            spinner.show(in: view, animated: true)
            viewModel.uploadDiaryText()
        }
    }
    
    @objc private func successUpload() {
        spinner.dismiss()
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func failedToUpload() {
        makeAlert(title: "Error", message: "Failed to upload your text. Try again later.")
    }
    
    private func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    private func setConstraints() {
        let saveButtonConstraints = [
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10),
            saveButton.widthAnchor.constraint(equalToConstant: 120),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let diaryShowLabelConstrainst = [
            diaryShowLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryShowLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
        ]
        
        let diaryTextViewConstraints = [
            diaryTextView.topAnchor.constraint(equalTo: diaryShowLabel.bottomAnchor, constant: 20),
            diaryTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            diaryTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            diaryTextView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(saveButtonConstraints)
        NSLayoutConstraint.activate(diaryShowLabelConstrainst)
        NSLayoutConstraint.activate(diaryTextViewConstraints)
    }

}

extension DiaryViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray {
            textView.textColor = .black
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .gray
            textView.text = "Write about your feelings"
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.text = textView.text
    }
}
