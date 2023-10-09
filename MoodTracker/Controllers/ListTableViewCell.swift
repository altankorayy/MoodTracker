//
//  ListTableViewCell.swift
//  MoodTracker
//
//  Created by Altan on 29.08.2023.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    static let identifier = "ListTableViewCell"
    
    private let cellLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "next"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        return button
    }()
    
    private let diaryImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "diary")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(diaryImage)
        contentView.addSubview(cellLabel)
        contentView.addSubview(nextButton)
        contentView.addSubview(dateLabel)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, date: String) {
        cellLabel.text = title
        dateLabel.text = date
    }
    
    private func setConstraints() {
        let diaryImageViewConstrainst = [
            diaryImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            diaryImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            diaryImage.heightAnchor.constraint(equalToConstant: 40),
            diaryImage.widthAnchor.constraint(equalToConstant: 40)
        ]
        
        let cellLabelConstaints = [
            cellLabel.leadingAnchor.constraint(equalTo: diaryImage.leadingAnchor, constant: 50),
            cellLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        let nextButtonConstraints = [
            nextButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            nextButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 30),
            nextButton.widthAnchor.constraint(equalToConstant: 30)
        ]
        
        let dateLabelConstraint = [
            dateLabel.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 5),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ]
        
        NSLayoutConstraint.activate(diaryImageViewConstrainst)
        NSLayoutConstraint.activate(cellLabelConstaints)
        NSLayoutConstraint.activate(nextButtonConstraints)
        NSLayoutConstraint.activate(dateLabelConstraint)
    }
}
