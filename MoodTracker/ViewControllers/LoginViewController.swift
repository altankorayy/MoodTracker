//
//  LoginViewController.swift
//  MoodTracker
//
//  Created by Altan on 22.08.2023.
//

import UIKit

class LoginViewController: UIViewController {
    
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
        textField.textColor = .white
        textField.isSecureTextEntry = true
        textField.attributedPlaceholder = NSAttributedString(string: "🔐 Password", attributes: attributes)
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .white
        button.tintColor = .black
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    }()
    
    var viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Login"
        view.backgroundColor = UIColor(red: 104/255, green: 52/255, blue: 212/255, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        
        emailTextField.addTarget(self, action: #selector(didTapEmail), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didTapPassword), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        
        setConstraints()
    }
    
    @objc private func didTapEmail() {
        viewModel.email = emailTextField.text
    }
    
    @objc private func didTapPassword() {
        viewModel.password = passwordTextField.text
    }
    
    @objc private func didTapLoginButton() {
        guard emailTextField.text != nil, passwordTextField.text != nil else {
            makeAlert(title: "Error", message: "Please fill email or password.")
            return
        }
        
        viewModel.loginUser()
        viewModel.errorDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveLoginNotification), name: NSNotification.Name("userLoginCompleted"), object: nil)
    }
    
    @objc private func didReceiveLoginNotification() {
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
        let emailTextFieldConstraints = [
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            emailTextField.widthAnchor.constraint(equalToConstant: 280),
            emailTextField.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let passwordTextFieldConstraints = [
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalToConstant: 280),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let loginButtonConstraints = [
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 150),
            loginButton.widthAnchor.constraint(equalToConstant: 280),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(emailTextFieldConstraints)
        NSLayoutConstraint.activate(passwordTextFieldConstraints)
        NSLayoutConstraint.activate(loginButtonConstraints)
    }

}

extension LoginViewController: AuthLoginErrorDelegate {
    func loginError(error: String) {
        makeAlert(title: "Error", message: error)
    }
}
