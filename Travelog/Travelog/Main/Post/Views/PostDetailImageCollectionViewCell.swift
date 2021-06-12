//
//  PostDetailImageCollectionViewCell.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/06/12.
//

import UIKit

class PostDetailImageCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = "PostDetailImageCell"
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        setUpImageView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([self.leadingAnchor.constraint(equalTo: imageView.leadingAnchor), self.trailingAnchor.constraint(equalTo: imageView.trailingAnchor), self.topAnchor.constraint(equalTo: imageView.topAnchor), self.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)])
    }
}
