//
//  StarredPostDetailViewController.swift
//  Travelog
//
//  Created by 강예나 on 2021/05/03.
//

import UIKit

class StarredPostDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!
    
    // MARK: - Properties
    var data: StarredList?
//    var likesCountInt: Int = 0
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.layer.cornerRadius = 45 // 모달 둥근 정도..
    }
    
    @IBAction func editNdeleteButton(_ sender: Any){
        let alert =  UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let delete = UIAlertAction(title: "삭제", style: .destructive){_ in}
        
        let edit =  UIAlertAction(title: "수정", style: .default) {_ in 
        }
       
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(delete)
        alert.addAction(edit)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tappedLikeButton(_ sender: Any){
        if (likesButton.isSelected == false) {
            likesButton.isSelected = true
            likesButton.setImage(UIImage(named: "smile.fill"), for: .normal)
//            likesButton.tintColor = .white
//            likesCountInt += 1
        }
    
//        else {
//            likesButton.isSelected = false
//            likesButton.setImage(UIImage(named: "smile"), for: .normal)
//            likesButton.tintColor = .white
//            likesCountInt -= 1
//        }
    }
    
//    @IBAction func tappedCommentField(_ sender: Any){
//        guard let commentView = self.storyboard?.instantiateViewController(withIdentifier: "commentView") as? CommentViewController else {
//            return
//        }
//        self.present(commentView, animated: true, completion: nil)
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
    }
    
    func configureUI() {
        locationLabel.text = data?.city
        dateLabel.text = data?.date
        textLabel.text = data?.text
        imageView.image = UIImage(named: data?.image ?? "")
        
//        likesCount.text = "\(likesCountInt)"
        
        locationLabel.font = UIFont.systemFont(ofSize: 17)
        locationLabel.numberOfLines = 1
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        textLabel.font = UIFont.systemFont(ofSize: 16)
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .left
        textLabel.sizeToFit()
        textLabel.lineBreakStrategy = .hangulWordPriority
    }

}
