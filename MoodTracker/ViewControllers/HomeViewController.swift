//
//  HomeViewController.swift
//  MoodTracker
//
//  Created by Altan on 22.08.2023.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    var collectionView: UICollectionView?
    
    let moodModel: [MoodModel] = [
        MoodModel(name: "Happy", image: UIImage(named: "happy")!),
        MoodModel(name: "Sad", image: UIImage(named: "sad")!),
        MoodModel(name: "Excited", image: UIImage(named: "excited")!),
        MoodModel(name: "Depressed", image: UIImage(named: "depressed")!),
        MoodModel(name: "Angry", image: UIImage(named: "angry")!),
        MoodModel(name: "Stressed", image: UIImage(named: "stressed")!)
    ]
    
    private let viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.size.width/2.2, height: view.frame.size.width/2.2)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView?.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
        collectionView?.backgroundColor = .white
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        view.backgroundColor = .white
        view.addSubview(collectionView!)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView?.frame = view.bounds
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moodModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        let image = moodModel[indexPath.row]
        cell.configure(image: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImageModel = moodModel[indexPath.row]
        let selectedName = selectedImageModel.name
        let diaryVC = DiaryViewController()
        diaryVC.moodString = selectedName
        diaryVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(diaryVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as? HeaderCollectionReusableView else {
                return UICollectionReusableView()
            }
            if let usernameString = UserDefaults.standard.string(forKey: "username") {
                header.configureUsername(username: usernameString)
            }
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width/2)-6, height: (view.frame.size.width/2)-6)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: view.frame.size.width / 3)
    }
    
}
