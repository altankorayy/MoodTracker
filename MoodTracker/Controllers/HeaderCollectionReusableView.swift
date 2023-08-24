//
//  HeaderCollectionReusableView.swift
//  MoodTracker
//
//  Created by Altan on 22.08.2023.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "HeaderCollectionReusableView"

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let showLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "How are you feeling today?"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(nameLabel)
        addSubview(showLabel)
        setConstraints()
    }
    
    private func setConstraints() {
        let nameLabelConstrains = [
            nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ]
        
        let showLabelConstraints = [
            showLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            showLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ]
        
        NSLayoutConstraint.activate(nameLabelConstrains)
        NSLayoutConstraint.activate(showLabelConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
}
