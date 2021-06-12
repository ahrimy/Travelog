//
//  PostDetailViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/06/12.
//

import UIKit

protocol PostDetailViewControllerDelegate: AnyObject {
    func deletePost(postId: String)
    func updateLikes(index: Int, likes: Int)
}

class PostDetailViewController: UIViewController {
    
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
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    // Delegate
    weak var delegate: PostDetailViewControllerDelegate?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        pageView.hidesForSinglePage = true
        imageSliderCollectionView.register(PostDetailImageCollectionViewCell.self, forCellWithReuseIdentifier: PostDetailImageCollectionViewCell.reuseIdentifier)
    }
    override func viewWillAppear(_ animated: Bool) {
        configureData()
        imageSliderCollectionView.reloadData()
        imageSliderCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0),at: .left,animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        if let index = index, let likes = post?.likes {
            delegate?.updateLikes(index: index, likes: likes)
        }
    }
    
    // MARK: - IBActions
    
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
        guard let postId = post?.id else{ return }
        guard let userId = UserService.shared.user?.uid else { return }
        
        print(post?.likeUsers as Any)
        if (post?.likeUsers.contains(userId) == false) {
            // 좋아요 수 + 1 저장
            post?.likes += 1
            post?.likeUsers.append(userId)
            PostService.shared.updateLikes(postId: postId, uid: userId, isLike: true)
            
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
        if let username = UserService.shared.user?.username, let writer = post?.writer{
            if username == writer{
                editButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
            }else{
                editButton.setImage(UIImage(systemName: "person.circle"), for: .normal)
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
        pageView.currentPage = 0
    }
    
    
      func loadPost(post: PostDetail){
          self.post = post
      }


}

extension PostDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostDetailImageCollectionViewCell.reuseIdentifier, for: indexPath) as? PostDetailImageCollectionViewCell else {return PostDetailImageCollectionViewCell()}

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

extension PostDetailViewController: UICollectionViewDelegateFlowLayout {
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
