//
//  DiaryViewController.swift
//  MoodTracker
//
//  Created by Altan on 23.08.2023.
//

import UIKit
import JGProgressHUD

class DiaryViewController: UIViewController {
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 26)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "Add Title", attributes: attributes)
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 26, weight: .bold)
        return textField
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
        view.addSubview(titleTextField)
        view.addSubview(diaryTextView)
        view.addSubview(saveButton)
        setConstraints()
        navigationController?.navigationBar.isHidden = true
        diaryTextView.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapGesture))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        
        titleTextField.addTarget(self, action: #selector(didEditTitle), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(successUpload), name: NSNotification.Name("diaryUploaded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(failedToUpload), name: NSNotification.Name("diaryUploadError"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let moodString = moodString else { return }
        viewModel.mood = moodString
    }
    
    @objc private func didEditTitle() {
        viewModel.title = titleTextField.text
    }
    
    @objc private func didTapGesture() {
        view.endEditing(true)
    }
    
    @objc private func didTapSaveButton() {
        if diaryTextView.text.count <= 10 {
            spinner.dismiss()
            makeAlert(title: "Something went wrong", message: "Text must be more than 10 characters.")
        } else if let titleText = titleTextField.text, titleText.count <= 2 {
            spinner.dismiss()
            makeAlert(title: "Something went wrong", message: "Please add title.")
        } else {
            spinner.show(in: view, animated: true)
            viewModel.uploadDiaryText()
        }
    }
    
    @objc private func successUpload() {
        spinner.dismiss()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func failedToUpload() {
        makeAlert(title: "Something went wrong", message: "Failed to upload your text. Try again later.")
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
        
        let titleTextFieldConstrainst = [
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
        ]
        
        let diaryTextViewConstraints = [
            diaryTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            diaryTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            diaryTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            diaryTextView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(saveButtonConstraints)
        NSLayoutConstraint.activate(titleTextFieldConstrainst)
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
