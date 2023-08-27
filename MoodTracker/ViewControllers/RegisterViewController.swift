//
//  RegisterViewController.swift
//  MoodTracker
//
//  Created by Altan on 22.08.2023.
//

import UIKit
import JGProgressHUD

class RegisterViewController: UIViewController {
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .default
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 16)
        ]
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: "🙂 Name and Surname", attributes: attributes)
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .default
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 16)
        ]
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: "✉️ Email Adress", attributes: attributes)
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .default
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 16)
        ]
        textField.isSecureTextEntry = true
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: "🔐 Password", attributes: attributes)
        return textField
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Complete", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .white
        button.tintColor = .black
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    }()
    
    var viewModel = RegisterViewModel()
    private let spinner = JGProgressHUD(style: .light)

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sign Up"
        view.backgroundColor = UIColor(red: 104/255, green: 52/255, blue: 212/255, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        view.addSubview(usernameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(completeButton)
        
        usernameTextField.addTarget(self, action: #selector(didTapUsername), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(didTapEmail), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didTapPassword), for: .editingChanged)
        completeButton.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        
        setConstraints()
    }
    
    @objc private func didTapUsername() {
        viewModel.username = usernameTextField.text
    }
    
    @objc private func didTapEmail() {
        viewModel.email = emailTextField.text
    }
    
    @objc private func didTapPassword() {
        viewModel.password = passwordTextField.text
    }
    
    @objc private func didTapCompleteButton() {
        guard usernameTextField.text != nil, emailTextField.text != nil, passwordTextField.text != nil else {
            makeAlert(title: "Error", message: "Please fill username/email or password.")
            return
        }
        spinner.show(in: view, animated: true)
        viewModel.registerUser()
        viewModel.registerErrorDelegate = self
        viewModel.uploadUserErrorDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification), name: NSNotification.Name("userCompleted"), object: nil)
    }
    
    @objc private func didReceiveNotification() {
        spinner.dismiss()
        let tabBar = TabBarController()
        tabBar.modalPresentationStyle = .fullScreen
        tabBar.selectedIndex = 0
        present(tabBar, animated: true)
    }
    
    private func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    private func setConstraints() {
        
        let usernameTextFieldConstraints = [
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            usernameTextField.widthAnchor.constraint(equalToConstant: 280),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let emailTextFieldConstraints = [
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            emailTextField.widthAnchor.constraint(equalToConstant: 280),
            emailTextField.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let passwordTextFieldConstraints = [
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalToConstant: 280),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let completeButtonConstraints = [
            completeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            completeButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 150),
            completeButton.widthAnchor.constraint(equalToConstant: 280),
            completeButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(usernameTextFieldConstraints)
        NSLayoutConstraint.activate(emailTextFieldConstraints)
        NSLayoutConstraint.activate(passwordTextFieldConstraints)
        NSLayoutConstraint.activate(completeButtonConstraints)
    }
}

extension RegisterViewController: AuthErrorDelegate, DatabaseErrorDelegate {
    func registerError(error: String) {
        spinner.dismiss()
        makeAlert(title: "Error", message: error)
    }
    
    func uploadUserError(error: String) {
        spinner.dismiss()
        makeAlert(title: "Error", message: error)
    }
}
