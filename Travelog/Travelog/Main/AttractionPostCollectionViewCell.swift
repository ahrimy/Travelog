//
//  AttractionPostCollectionViewCell.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/06/09.
//

import UIKit

class AttractionPostCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "AttractionPostCell"
    var post : PostOverview?
    var cellView = UIView()
    var nameLabel = UILabel()
    var imageView = UIImageView()
    var addressStackView = UIStackView()
    var locationImg = UIImageView()
    var addressLabel = UILabel()
    var textLabel = UILabel()
    var likeCommentStackView = UIStackView()
    var likeImg = UIImageView()
    var likeLabel = UILabel()
    var commentImg = UIImageView()
    var commentLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cellView)
        cellView.addSubview(imageView)
        cellView.addSubview(nameLabel)
        
        cellView.addSubview(addressStackView)
        addressStackView.addArrangedSubview(locationImg)
        addressStackView.addArrangedSubview(addressLabel)
        
        cellView.addSubview(textLabel)
        
        cellView.addSubview(likeCommentStackView)
        likeCommentStackView.addArrangedSubview(commentLabel)
        likeCommentStackView.addArrangedSubview(commentImg)
        likeCommentStackView.addArrangedSubview(likeLabel)
        likeCommentStackView.addArrangedSubview(likeImg)
        
        setUpCellView()
        setUpImageView()
        setUpNameLabel()
        setUpAddressStackView()
        setUpTextLabel()
        setUpLikeCommentStackView()
        
        setUpConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureData(post:PostOverview){
        imageView.load(urlString: post.imageUrl)
        nameLabel.text = post.writer
        addressLabel.text = post.locationName
        textLabel.text = post.text
        likeLabel.text = String(post.likes)
        commentLabel.text = String(post.comments)
    }
    
    func setUpCellView() {
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.clipsToBounds = true
        cellView.backgroundColor = .none
    }
    
    func setUpImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
    }
    
    func setUpNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.backgroundColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.3)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .right
        nameLabel.numberOfLines = 1
    }
    
    func setUpAddressStackView(){
        addressStackView.translatesAutoresizingMaskIntoConstraints = false
        addressStackView.axis = .horizontal
        addressStackView.spacing = 3
        addressStackView.backgroundColor = .none
        addressStackView.alignment = .center
        addressStackView.distribution = .fill
        
        locationImg.tintColor = UIColor(red: 0.31, green: 0.16, blue: 0.36, alpha: 1.00)
        locationImg.image = UIImage(systemName: "paperplane.fill")
        
        addressLabel.textColor = UIColor(red: 0.31, green: 0.16, blue: 0.36, alpha: 1.00)
        addressLabel.numberOfLines = 1
    }
    
    func setUpTextLabel(){
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .white
        textLabel.textColor = .black
        textLabel.numberOfLines = 1
    }
    
    func setUpLikeCommentStackView(){
        likeCommentStackView.translatesAutoresizingMaskIntoConstraints = false
        likeCommentStackView.backgroundColor = .none
        likeCommentStackView.spacing = 3
        likeCommentStackView.alignment = .center
        likeCommentStackView.distribution = .fill
        likeCommentStackView.semanticContentAttribute = .forceRightToLeft
        
        likeImg.image = UIImage(systemName: "smiley")
        likeImg.tintColor = UIColor(red: 0.31, green: 0.16, blue: 0.36, alpha: 1.00)

        likeLabel.textColor = UIColor(red: 0.31, green: 0.16, blue: 0.36, alpha: 1.00)
        
        commentImg.image = UIImage(systemName: "captions.bubble")
        commentImg.tintColor = UIColor(red: 0.31, green: 0.16, blue: 0.36, alpha: 1.00)
        
        commentLabel.textColor = UIColor(red: 0.31, green: 0.16, blue: 0.36, alpha: 1.00)
    }
    
    func setUpConstraints(){
        cellView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        cellView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        cellView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        imageView.superview?.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 0).isActive = true
        imageView.superview?.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 0).isActive = true
        imageView.superview?.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true

        nameLabel.superview?.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor,constant: 0).isActive = true
        nameLabel.superview?.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 0).isActive = true
        imageView.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -15).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addressStackView.superview?.leadingAnchor.constraint(equalTo: addressStackView.leadingAnchor,constant: -5).isActive = true
        addressStackView.superview?.trailingAnchor.constraint(greaterThanOrEqualTo: addressStackView.trailingAnchor, constant: 5).isActive = true
        addressStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5).isActive = true
        addressStackView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        textLabel.superview?.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor,constant: -5).isActive = true
        textLabel.superview?.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: 5).isActive = true
        textLabel.topAnchor.constraint(equalTo: addressStackView.bottomAnchor, constant: 2).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        likeCommentStackView.superview?.leadingAnchor.constraint(lessThanOrEqualTo: likeCommentStackView.leadingAnchor,constant: -5).isActive = true
        likeCommentStackView.superview?.trailingAnchor.constraint(equalTo: likeCommentStackView.trailingAnchor, constant: 5).isActive = true
        likeCommentStackView.superview?.bottomAnchor.constraint(equalTo: likeCommentStackView.bottomAnchor).isActive = true
        likeCommentStackView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 2).isActive = true
        likeCommentStackView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
}
