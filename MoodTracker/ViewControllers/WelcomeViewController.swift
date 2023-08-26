//
//  ViewController.swift
//  MoodTracker
//
//  Created by Altan on 22.08.2023.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Mood Tracker 😊"
        label.textColor = .white
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Understand yourself better by monitoring your emotional state."
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let descriptionLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your data is safe with us 🔐"
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Already have an account? Login", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(appNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionLabel2)
        view.addSubview(signUpButton)
        view.addSubview(loginButton)
        view.backgroundColor = UIColor(red: 104/255, green: 52/255, blue: 212/255, alpha: 1)
        setConstraints()
        
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    @objc private func didTapSignUp() {
        let registerVC = RegisterViewController()
        registerVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @objc private func didTapLogin() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    private func setConstraints() {
        let appNameLabelConstraints = [
            appNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            appNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ]
        
        let descriptionLabelConstraints = [
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 60),
            descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20)
        ]
        
        let descriptionLabel2Constraints = [
            descriptionLabel2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel2.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            descriptionLabel2.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20)
        ]
        
        let signUpButtonConstraints = [
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: descriptionLabel2.bottomAnchor, constant: 150),
            signUpButton.widthAnchor.constraint(equalToConstant: 280),
            signUpButton.heightAnchor.constraint(equalToConstant: 45)
        ]
        
        let loginButtonConstraints = [
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 5)
        ]
        
        NSLayoutConstraint.activate(appNameLabelConstraints)
        NSLayoutConstraint.activate(descriptionLabelConstraints)
        NSLayoutConstraint.activate(descriptionLabel2Constraints)
        NSLayoutConstraint.activate(signUpButtonConstraints)
        NSLayoutConstraint.activate(loginButtonConstraints)
    }


}

