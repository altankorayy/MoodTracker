//
//  CollectionViewCell.swift
//  MoodTracker
//
//  Created by Altan on 22.08.2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    static let identifier = "CollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
    }
    
    func configure(image: MoodModel) {
        imageView.image = image.image
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
