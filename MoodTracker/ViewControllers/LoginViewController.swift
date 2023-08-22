//
//  LoginViewController.swift
//  MoodTracker
//
//  Created by Altan on 22.08.2023.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func didTapBackButton() {
        dismiss(animated: true)
    }
   

}
