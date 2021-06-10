//
//  StarredPostDetailViewController.swift
//  Travelog
//
//  Created by 강예나 on 2021/05/03.
//

import UIKit
import FirebaseFirestore

protocol StarredPostDetailViewControllerDelegate: AnyObject {
    func updateLikes(index: Int, likes: Int)
}

class StarredPostDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var userButton: UIButton!
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
    var index:Int?
    var postId: String = ""
    var post: PostDetail?
    var imgUrls: [String] = []
    var starredPostDetailViewController: StarredPostDetailViewController?
    var user: String = ""
    
    // Delegate
    weak var delegate: StarredPostDetailViewControllerDelegate?

    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.layer.cornerRadius = 45 // 모달 둥근 정도..
        configureUI()
        pageView.hidesForSinglePage = true
        
//        if let starredPostDetailViewController = self.starredPostDetailViewController {
//            PostService.shared.loadPostDetail(postId: postId, loadPost: starredPostDetailViewController.loadPosts(posts:))
//        }
        
        imageSliderCollectionView.dataSource = self
        imageSliderCollectionView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
        configureData()
        imageSliderCollectionView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        if let index = index, let likes = post?.likes {
            delegate?.updateLikes(index: index, likes: likes)
        }
    }
    
    func loadPost(post: PostDetail){
        self.post = post
        //self.imageSliderCollectionView.reloadData()
    }
    
    
    
    @IBAction func didTouchUserButton(_ sender: Any){
        print(post?.writer)
    }
    
    @IBAction func tappedLikeButton(_ sender: Any){
        
        guard let postId = post?.id else{ return }
        guard let userId = UserService.shared.user?.uid else { return }
        
        print(post?.likeUsers as Any)
        if (post?.likeUsers.contains(userId) == false) {
            // 좋아요 수 + 1 저장
            post?.likes += 1
            post?.likeUsers.append(userId)
            DispatchQueue.global().async {
                PostService.shared.updateLikes(postId: postId, uid: userId, isLike: true)
            }
            
            likesButton.setImage(UIImage(named: "smile.fill.pink"), for: .normal)
            likesCount.text = "\(post?.likes ?? 0)"
        }
        // 좋아요 취소
        else {
            // 좋아요 수 - 1 저장
            post?.likes -= 1
            post?.likeUsers = post?.likeUsers.filter(){$0 != userId} ?? []
            DispatchQueue.global().async {
                PostService.shared.updateLikes(postId: postId, uid: userId, isLike: false)
            }
            likesButton.setImage(UIImage(named: "smile.pink"), for: .normal)
            likesCount.text = "\(post?.likes ?? 0)"
        }
    }
    
//    @IBAction func tappedCommentField(_ sender: Any){
//        guard let commentView = self.storyboard?.instantiateViewController(withIdentifier: "commentView") as? CommentViewController else {
//            return
//        }
//        self.present(commentView, animated: true, completion: nil)
//    }
    
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .medium
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    func configureUI(){
        imageSliderCollectionView.isPagingEnabled = true
        
        locationLabel.font = UIFont.systemFont(ofSize: 17)
        locationLabel.numberOfLines = 1
        
        textLabel.font = UIFont.systemFont(ofSize: 16)
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .left
        textLabel.lineBreakStrategy = .hangulWordPriority
        textLabel.frame.size = CGSize(width: 358, height: 150)
    }
    func configureData(){
        textLabel.text = post?.text
        
        locationLabel.text = post?.location.name
        imgUrls = post?.imageUrls ?? []
        
        let date: Date? = post?.date
        
        if let newDate = date {
            let dateString: String = self.dateFormatter.string(from: newDate)
            dateLabel.text = dateString
        }
        
        if let uid = UserService.shared.user?.uid, let likeUsers = post?.likeUsers{
            if likeUsers.contains(uid){
                likesButton.setImage(UIImage(named: "smile.fill.pink"), for: .normal)
            }else{
                likesButton.setImage(UIImage(named: "smile.pink"), for: .normal)
            }
        }
    
        let likesInt: Int? = post?.likes
        if let newLikesInt = likesInt{
            likesCount.text = "\(newLikesInt)"
        }
        
        let commentsInt: Int? = post?.comments
        if let newCommentsInt = commentsInt{
            commentsCount.text = "\(newCommentsInt)"
        }
        pageView.numberOfPages = imgUrls.count
    }

}


extension StarredPostDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailViewCell", for: indexPath) as? StarredPostDetailImageCell else {return UICollectionViewCell()}
        
//        cell.imageView.image = img[indexPath.row]
        cell.imageView.load(urlString: imgUrls[indexPath.row])
        //pageView.currentPage = indexPath.row
        
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

extension StarredPostDetailViewController: UICollectionViewDelegateFlowLayout{
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
