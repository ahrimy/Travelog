//
//  AttractionCollectionViewCell.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/05/31.
//

import UIKit

class AttractionCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier: String = "AttractionCell"
    var attraction : Attraction?
    let nameLabel = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(nameLabel)
        setUpImageView()
        setUpNameLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        NSLayoutConstraint.activate([self.leadingAnchor.constraint(equalTo: imageView.leadingAnchor), self.trailingAnchor.constraint(equalTo: imageView.trailingAnchor), self.topAnchor.constraint(equalTo: imageView.topAnchor), self.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)])
    }
    
    func setUpNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([self.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor), self.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),  self.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 30),
                                     nameLabel.heightAnchor.constraint(equalToConstant: 50)])
        nameLabel.backgroundColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.5)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 2
        nameLabel.font = UIFont(name: "Arial", size: 15)
    }
    
}
