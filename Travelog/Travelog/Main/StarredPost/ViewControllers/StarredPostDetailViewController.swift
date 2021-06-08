//
//  StarredPostDetailViewController.swift
//  Travelog
//
//  Created by 강예나 on 2021/05/03.
//

import UIKit
import FirebaseFirestore

class StarredPostDetailViewController: UIViewController {
    
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
    var postId: String = ""
    var data: PostDetail?
    var imgUrls: [String] = []
    var starredPostDetailViewController: StarredPostDetailViewController?
    var user: String = ""
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.layer.cornerRadius = 45 // 모달 둥근 정도..
        configureUI()
        pageView.numberOfPages = imgUrls.count // TODO : page 이미지 갯수와 연결
        pageView.hidesForSinglePage = true
        
//        if let starredPostDetailViewController = self.starredPostDetailViewController {
//            PostService.shared.loadPostDetail(postId: postId, loadPost: starredPostDetailViewController.loadPosts(posts:))
//        }
        
        imageSliderCollectionView.dataSource = self
        imageSliderCollectionView.delegate = self
    }
    
  
    
    func loadPost(post: PostDetail){
        self.data = post
        //self.imageSliderCollectionView.reloadData()
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
        
        let likesInt: Int? = data?.likes
        if let newLikesInt = likesInt{
            likesCount.text = "\(newLikesInt)"
        }
        
        let username: String? = UserService.shared.user?.username
        if let newUsername = username{
            user = newUsername
        }
        print(data?.likeUsers as Any)
        if (data?.likeUsers.contains(user) == false) {
            data?.likeUsers.append(user)
            print(data?.likeUsers as Any)
            
            likesButton.isSelected = true
            likesButton.setImage(UIImage(named: "smile.fill"), for: .normal)
            
            // 좋아요 수 + 1 저장
            let db = Firestore.firestore()
            let id = data?.id
            let ref = db.collection("postdetails").document(id!)
            
            db.runTransaction({(Transaction, ErrorPointer) -> Any? in let Document: DocumentSnapshot
                do{ try Document = Transaction.getDocument(ref)
                } catch let fetchError as NSError{
                    ErrorPointer?.pointee = fetchError
                    return nil
                }
                guard let like = Document.data()?["likes"] as? Int else{
                    let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey:"Unable to retrieve like from snapshot \(Document)"])
                    ErrorPointer?.pointee = error
                    return nil
                }
                Transaction.updateData(["likes": like + 1], forDocument: ref)
                return nil
            }, completion: { (object, error) in
                if let error = error {
                    //실패했을때
                    print("Transaction failed: \(error)")
                } else {
                    //성공했을 때 출력
                    print("Transaction successfully committed!")
                }
            })
        }
        
       
        // 좋아요 취소
//        else {

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
        
    }
    
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .medium
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    func configureUI(){
        locationLabel.text = data?.location.name
        //imageView.image = data?.images[0]
        
        imgUrls = data?.imageUrls ?? []
        //img = data?.images
        
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
        
        textLabel.text = data?.text
        
        
//        likesCount.text = "\(likesCountInt)"
        
        locationLabel.font = UIFont.systemFont(ofSize: 17)
        locationLabel.numberOfLines = 1
        
        //imageView.clipsToBounds = true
        //imageView.contentMode = .scaleAspectFill
        
        textLabel.font = UIFont.systemFont(ofSize: 16)
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .left
        textLabel.sizeToFit()
        textLabel.lineBreakStrategy = .hangulWordPriority
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
