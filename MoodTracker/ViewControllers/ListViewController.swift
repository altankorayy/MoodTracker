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
    var title: String
    var date: String
}

class ListViewController: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Recent"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let signOutButton: UIButton = {
        let image = UIImage(systemName: "rectangle.portrait.and.arrow.forward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.tintColor = UIColor(red: 104/255, green: 52/255, blue: 212/255, alpha: 1)
        return button
    }()
    
    private let listTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        return tableView
    }()
    
    private let noDataLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "There is no diary here."
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .gray
        label.isHidden = true
        return label
    }()
    
    var moodListModel = [MoodListModel]()
    private var spinner = JGProgressHUD(style: .light)
    private let viewModel = ListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(label)
        view.addSubview(listTableView)
        view.addSubview(noDataLabel)
        view.addSubview(signOutButton)
        
        setConstraints()
        
        signOutButton.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
        navigationController?.navigationBar.isHidden = true
        
        spinner.show(in: view)
        fetchDiaryList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTableView), name: NSNotification.Name("diaryUploaded"), object: nil)
    }
    
    private func fetchDiaryList() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        DatabaseManager.shared.fetchUserDiary(id: userId) { [weak self] result in
            switch result {
            case .success(let moodListModel):
                self?.moodListModel = moodListModel
                self?.checkDiaryList()
                
                DispatchQueue.main.async {
                    self?.listTableView.reloadData()
                }
                self?.spinner.dismiss()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    @objc private func refreshTableView() {
        fetchDiaryList()
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
                self?.makeAlert(title: "Something went wrong", message: "Failed to sign out. Try again later")
            }
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive) { [weak self] _ in
            self?.dismiss(animated: true)
        }
        alert.addAction(signOutButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
    
    private func checkDiaryList() {
        if moodListModel.isEmpty {
            noDataLabel.isHidden = false
        } else {
            noDataLabel.isHidden = true
        }
    }
    
    private func setConstraints() {
        let labelConstraints = [
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ]
        
        let listTableViewConstraints = [
            listTableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            listTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        let noDataLabelConstraints = [
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        let signOutButtonConstraints = [
            signOutButton.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            signOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ]
        
        NSLayoutConstraint.activate(labelConstraints)
        NSLayoutConstraint.activate(listTableViewConstraints)
        NSLayoutConstraint.activate(noDataLabelConstraints)
        NSLayoutConstraint.activate(signOutButtonConstraints)
    }
    
    private func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moodListModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier) as! ListTableViewCell
        let titleString = moodListModel[indexPath.row].title
        let dateString = moodListModel[indexPath.row].date
        cell.configure(title: titleString, date: dateString)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let checkDiaryVC = CheckDiaryViewController()
        let moodString = moodListModel[indexPath.row].mood
        let diaryTextString = moodListModel[indexPath.row].diaryText
        checkDiaryVC.configure(mood: moodString, text: diaryTextString)
        navigationController?.pushViewController(checkDiaryVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            viewModel.deleteUserDiary(model: moodListModel, indexPath: indexPath.row)
            guard let deleted = viewModel.didDeleteDiary else { return }
            
            if deleted {
                makeAlert(title: "Success", message: "Successfully deleted.")
            } else {
                makeAlert(title: "Something went wrong...", message: "Failed to delete diary. Please check your internet connection.")
            }
            
            moodListModel.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            checkDiaryList()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
