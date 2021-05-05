//
//  MyPostListViewController.swift
//  Travelog
//
//  Created by 강예나 on 2021/03/31.
//

import UIKit

class MyPostListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var posts:[PostThumbnail] = []

    var numberOfCell: Int = 10
    // post cell 수
    let cellIdentifier: String = "cell"
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ViewCell
        
        cell.postThumbnail = posts[indexPath.row]
        let url = URL(string:posts[indexPath.row].image)!
        do{
            let data = try Data(contentsOf: url)
            cell.thumbnailImage.image = UIImage(data: data)
        }catch{
            print("Error occured")
        }
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let flowLayout: UICollectionViewFlowLayout
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.minimumLineSpacing = 5
        
        flowLayout.estimatedItemSize = CGSize(width: 125, height: 125)
        
        self.collectionView.collectionViewLayout = flowLayout
        // collectionView 레이아웃 설정
        
        // Do any additional setup after loading the view.
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let myPostViewController = segue.destination as? MyPostViewController {
//            print("prepare")
//            myPostViewController.myPostViewControllerDelegate = self
//        }
//    }

    func reloadData(list: [PostThumbnail]) {
        self.posts = list
        self.collectionView.reloadData()
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
