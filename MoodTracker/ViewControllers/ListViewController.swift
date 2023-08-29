//
//  ListViewController.swift
//  MoodTracker
//
//  Created by Altan on 22.08.2023.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

struct MoodListModel {
    var mood: String
    var diaryText: String
}

class ListViewController: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Latest"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let signOutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        return button
    }()
    
    private let listTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        return tableView
    }()
    
    var moodListModel = [MoodListModel]()
    private var spinner = JGProgressHUD(style: .light)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(listTableView)
        setConstraints()
        
        signOutButton.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
        navigationController?.navigationBar.isHidden = true
        
        spinner.show(in: view)
        fetchDiaryList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        listTableView.frame = view.bounds
    }
    
    private func fetchDiaryList() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        DatabaseManager.shared.fetchUserDiary(id: userId) { [weak self] result in
            switch result {
            case .success(let moodListModel):
                self?.moodListModel = moodListModel
                
                DispatchQueue.main.async {
                    self?.listTableView.reloadData()
                }
                self?.spinner.dismiss()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
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
    
    private func setConstraints() {
        
    }

}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moodListModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier) as! ListTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
