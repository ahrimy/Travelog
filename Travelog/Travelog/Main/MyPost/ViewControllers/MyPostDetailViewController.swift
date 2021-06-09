//
//  MyPostDetailViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/06/10.
//

import UIKit

protocol MyPostDetailViewControllerDelegate: AnyObject {
    func deletePost(postId: String)
}

class MyPostDetailViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    //@IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var imageSliderCollectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    
    // MARK: - Properties
    var index: Int?
    var post: PostDetail?
    var imgUrls: [String] = []
    
    // Delegate
    weak var delegate: MyPostDetailViewControllerDelegate?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        pageView.numberOfPages = imgUrls.count
        pageView.hidesForSinglePage = true
        
        imageSliderCollectionView.register(MyPostImageCollectionViewCell.self, forCellWithReuseIdentifier: MyPostImageCollectionViewCell.reuseIdentifier)
    }
    
  
    
    func loadPost(post: PostDetail){
        self.post = post
    }
    
    @IBAction func editNdeleteButton(_ sender: Any){
        let alert =  UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let delete = UIAlertAction(title: "삭제", style: .destructive){_ in
            if let postId = self.post?.id {
                PostService.shared.deletePost(postId: postId)
                self.delegate?.deletePost(postId: postId)
            }
            self.dismiss(animated: true, completion: nil)
        }
        
        let edit =  UIAlertAction(title: "수정", style: .default) {_ in
        }
       
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(delete)
        alert.addAction(edit)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tappedLikeButton(_ sender: Any){
//        likesButton.setImage(UIImage(named: "smile.fill.pink"), for: .normal)
        print("likes button has tapped")
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    func configureUI(){
        imgUrls = post?.imageUrls ?? []
        
        let date: Date? = post?.date
        if let newDate = date {
            let dateString: String = self.dateFormatter.string(from: newDate)
            dateLabel.text = dateString
        }
    
        let likesInt: Int? = post?.likes
        if let newLikesInt = likesInt{
            likesCount.text = "\(newLikesInt)"
        }
        
        let commentsInt: Int? = post?.comments
        if let newCommentsInt = commentsInt{
            commentsCount.text = "\(newCommentsInt)"
        }
        
        locationLabel.text = post?.location.name
        locationLabel.font = UIFont.systemFont(ofSize: 17)
        locationLabel.numberOfLines = 1
        
        
        textLabel.text = post?.text
        textLabel.font = UIFont.systemFont(ofSize: 16)
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .left
        textLabel.sizeToFit()
        textLabel.lineBreakStrategy = .hangulWordPriority
    }

}

extension MyPostDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageCell", for: indexPath) as? MyPostImageCollectionViewCell else {return UICollectionViewCell()}

        cell.imageView.load(urlString: imgUrls[indexPath.row])
        
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / self.imageSliderCollectionView.frame.width)
       self.pageView.currentPage = page
     }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgUrls.count
    }
}

extension MyPostDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize{
        let size = imageSliderCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
