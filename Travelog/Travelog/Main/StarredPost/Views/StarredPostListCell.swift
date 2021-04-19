//
//  StarredPostListCell.swift
//  Travelog
//
//  Created by 강예나 on 2021/04/06.
//

import UIKit

class StarredPostListCell: UICollectionViewCell, SelfConfiguringCell {
   
    static let reuseIdentifier: String = "StarredPostListCell"

    let name = UILabel()
    let imageView = UIImageView()
    let address_info = UILabel()
    let text = UILabel()
    let likeButton = UIButton()
    let likeNum = UILabel()
    let commentButton = UIButton()
    let commmentNum = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        name.font = UIFont(name: "Apple SD 산돌고딕 Neo 볼드체", size: 17)
        name.font = UIFont.systemFont(ofSize: 16)
        name.textColor = .gray
        name.textAlignment = .right
        
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
//        address_info.font = UIFont(name: "Apple SD 산돌고딕 Neo 볼드체", size: 17)
        address_info.font = UIFont.systemFont(ofSize: 16)
        address_info.textColor = UIColor(red: 0.31, green: 0.16, blue: 0.36, alpha: 1.00)
        address_info.textAlignment = .center
        address_info.numberOfLines = 1
        
//        text.font = UIFont(name: "Apple SD 산돌고딕 Neo 볼드체", size: 17)
        text.font = UIFont.systemFont(ofSize: 16)
        text.textColor = .black
        text.textAlignment = .left
        text.numberOfLines = 5
        
        // TODO : 좋아요 & 댓글 오른쪽 정렬 필요
        likeButton.setImage(UIImage(systemName: "star"), for: .normal)
        likeNum.text = "77" // TODO: data file에서 불러오기
        likeNum.textColor = UIColor(red: 0.31, green: 0.16, blue: 0.36, alpha: 1.00)
        likeNum.font = UIFont.systemFont(ofSize: 16)
        commentButton.setImage(UIImage(systemName: "text.bubble"), for: .normal)
        commmentNum.text = "6" // TODO: data file에서 불러오기
        commmentNum.textColor = UIColor(red: 0.31, green: 0.16, blue: 0.36, alpha: 1.00)
        commmentNum.font = UIFont.systemFont(ofSize: 16)
        let buttonStackView = UIStackView(arrangedSubviews: [likeButton, likeNum, commentButton, commmentNum])
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .equalSpacing
        buttonStackView.setCustomSpacing(20, after: likeNum)
        
        let stackView = UIStackView(arrangedSubviews: [name, imageView, address_info, text, buttonStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalCentering // TODO: 변경 필요
        contentView.addSubview(stackView)
        let margins = contentView.layoutMarginsGuide
        NSLayoutConstraint.activate([stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor), stackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor), stackView.topAnchor.constraint(equalTo: margins.topAnchor), stackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)])
        
//        stackView.setCustomSpacing(5, after: imageView)
//        stackView.setCustomSpacing(5, after: address_info)
    }
    
    func configure(with starredpostlist: StarredList) {
        name.text = starredpostlist.name
        imageView.image = UIImage(named: starredpostlist.image)
        address_info.text = starredpostlist.city + ", " + starredpostlist.country
        text.text = starredpostlist.text
//        likeNum.text = starredpostlist.likeNum
//        commmentNum.text = starredpostlist.commentNum
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    let LabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(LocationLabel.addGestureRecognizer(_:)))
    LocationLabel.addGestureRecognizer(LabelTapGesture)
    */
}
