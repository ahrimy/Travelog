//
//  MyPostListViewController.swift
//  Travelog
//
//  Created by 강예나 on 2021/03/31.
//

import UIKit

class MyPostListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    var posts:[PostOverview] = []
    var myPostDetailViewController: MyPostDetailViewController?
   
    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methods
    func appendPost(post:PostOverview){
        self.posts.append(post)
        self.posts = self.posts.sorted(by: {$0.date > $1.date})
        self.collectionView.reloadData()
    }
    func loadPosts(posts: [PostOverview]) {
        self.posts = posts.sorted(by: {$0.date > $1.date})
        self.collectionView.reloadData()
    }
    func deletePost(postId:String){
        print("Has deleted in list")
        for i in 0..<posts.count{
            if posts[i].id == postId {
                posts.remove(at: i)
                break
            }
        }
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPostOverviewCell", for: indexPath) as! MyPostViewCell
        
        cell.overview = posts[indexPath.row]
        if let image = posts[indexPath.row].image {
            cell.imageView.image = image
        }else{
            cell.imageView.load(urlString: posts[indexPath.row].imageUrl)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.frame.width
            let itemsPerRow: CGFloat = 3
            let cellWidth = width / itemsPerRow

            return CGSize(width: cellWidth, height: cellWidth)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
      return  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let myPostDetailViewController = self.myPostDetailViewController else { return }
        myPostDetailViewController.modalTransitionStyle = .coverVertical
        PostService.shared.loadPostDetail(postId: posts[indexPath.row].id){ post in
            myPostDetailViewController.index = indexPath.row
            myPostDetailViewController.loadPost(post: post)
            self.present(myPostDetailViewController, animated: true, completion: nil)
        }
    }

}
