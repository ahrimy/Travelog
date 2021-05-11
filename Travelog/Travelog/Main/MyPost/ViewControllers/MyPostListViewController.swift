//
//  MyPostListViewController.swift
//  Travelog
//
//  Created by 강예나 on 2021/03/31.
//

import UIKit

class MyPostListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Properties
    var posts:[PostOverview] = []
//    var posts:[PostThumbnail] = []
    let cellIdentifier: String = "cell"
    
    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let flowLayout: UICollectionViewFlowLayout
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.minimumLineSpacing = 5
        
        flowLayout.estimatedItemSize = CGSize(width: 125, height: 125)
        
        self.collectionView.collectionViewLayout = flowLayout
    }

    // MARK: - Methods
    func appendPost(post:PostOverview){
        self.posts.append(post)
        self.collectionView.reloadData()
    }
    func reloadData(list: [PostOverview]) {
//        self.posts = list
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyPostViewCell
        
        cell.overview = posts[indexPath.row]
        cell.imageView.image = posts[indexPath.row].image
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
