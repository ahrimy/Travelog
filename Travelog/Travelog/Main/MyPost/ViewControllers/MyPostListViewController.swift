//
//  MyPostListViewController.swift
//  Travelog
//
//  Created by 강예나 on 2021/03/31.
//

import UIKit

class MyPostListViewController: UIViewController {
    
    // MARK: - Properties
    var posts:[PostOverview] = []
    var myPostDetailViewController: MyPostDetailViewController?
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
   
    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.register(PostOverviewCollectionViewCell.self, forCellWithReuseIdentifier: PostOverviewCollectionViewCell.reuseIdentifier)
        
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
    func updateLikes(index: Int, likes:Int){
        posts[index].likes = likes
        collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
}


extension MyPostListViewController:UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostOverviewCollectionViewCell.reuseIdentifier, for: indexPath) as! PostOverviewCollectionViewCell
        
        cell.configureData(post: posts[indexPath.row])
        cell.setUpHiddenUI(type: "mypost")
        
        return cell
    }
    
}

extension MyPostListViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        
        let itemsPerRow: CGFloat = 2
        let widthPadding = sectionInsets.left * (itemsPerRow + 1)
        
        let cellWidth = (width - widthPadding) / itemsPerRow
        
        
        return CGSize(width: cellWidth, height: cellWidth*1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.sectionInsets.left
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

