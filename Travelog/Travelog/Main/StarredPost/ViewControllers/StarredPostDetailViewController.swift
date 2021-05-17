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
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!
    
    // MARK: - Properties
    var data: PostOverview?
    var detailData : PostDetail?
    
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
//            var likesCountInt : Int = data!.likes
//            likesCount.text = "\(likesCountInt)"
//            likesCountInt += 1
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
    
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .medium
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    func configureUI() {
        let someLocation: Location? = detailData?.location // TODO : Location 정보 없음
        if let newLocation = someLocation {
            locationLabel.text = "\(newLocation.address)"
        }

        imageView.image = data?.image
        
        let date: Date? = data?.date
        if let newDate = date {
            let dateString: String = self.dateFormatter.string(from: newDate)
            dateLabel.text = dateString
        }
    
        let likesInt: Int? = data?.likes
        if let newLikesInt = likesInt{
            likesCount.text = "\(newLikesInt)"
        }
        
        let commentsInt: Int? = data?.comments
        if let newCommentsInt = commentsInt{
            commentsCount.text = "\(newCommentsInt)"
        }
        
        textLabel.text = "LA에서 한 할아버지를 만나서 무한도전을 아냐고 물었다. 할아버지께서는 당연히 안다고 하셨다. 그래서 외쳐보았다 무한 ~ "
        
        
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
