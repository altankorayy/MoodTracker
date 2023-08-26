//
//  ListViewController.swift
//  MoodTracker
//
//  Created by Altan on 22.08.2023.
//

import UIKit
import FirebaseAuth

class ListViewController: UIViewController {
    
    private let signOutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(signOutButton)
        setConstraints()
        
        signOutButton.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
    }
    
    @objc private func didTapSignOut() {
        let alert = UIAlertController(title: "Do you really want to sign out?", message: nil, preferredStyle: .actionSheet)
        let signOutButton = UIAlertAction(title: "Sign Out", style: .default) { [weak self] _ in
            do {
                try Auth.auth().signOut()
                
                DispatchQueue.main.async {
                    let welcomeVC = WelcomeViewController()
                    welcomeVC.modalPresentationStyle = .fullScreen
                    self?.navigationController?.pushViewController(welcomeVC, animated: true)
                }
            } catch {
                self?.makeAlert(title: "Error", message: "Failed to sign out. Try again later")
            }
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive) { [weak self] _ in
            self?.dismiss(animated: true)
        }
        alert.addAction(signOutButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
    
    private func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.frame = view.bounds
    }
    
    private func setConstraints() {
        let signOutButtonConstraints = [
            signOutButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            signOutButton.bottomAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(signOutButtonConstraints)
    }

}
