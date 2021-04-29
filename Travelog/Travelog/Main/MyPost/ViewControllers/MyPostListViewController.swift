//
//  MyPostListViewController.swift
//  Travelog
//
//  Created by 강예나 on 2021/03/31.
//

import UIKit

class MyPostListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let posts = [
        PostThumbnail(postId: "IidJt7M8ukwEQhxLQpWg", image: "https://firebasestorage.googleapis.com/v0/b/travelog-6cf98.appspot.com/o/ahrimy%2FIidJt7M8ukwEQhxLQpWg%2Fimage1?alt=media&token=be17bba5-c517-46cb-bd8e-2d3ee5fc5303"),
        PostThumbnail(postId:"P91CzQHef6pRdlU6REf2",image:"https://firebasestorage.googleapis.com/v0/b/travelog-6cf98.appspot.com/o/ahrimy%2FP91CzQHef6pRdlU6REf2%2Fimage2?alt=media&token=3d171ae6-88d1-4c7a-ab5d-fdb760043ac8"),
        PostThumbnail(postId: "UAHfGFaPxqkFUI8m4cvG", image: "https://firebasestorage.googleapis.com/v0/b/travelog-6cf98.appspot.com/o/ahrimy%2FUAHfGFaPxqkFUI8m4cvG%2Fimage2?alt=media&token=8326f7a6-c727-4f6b-832b-2696fd45c27b"),
        PostThumbnail(postId: "ZaAHu8bgRVI0L6EUHQCS", image: "https://firebasestorage.googleapis.com/v0/b/travelog-6cf98.appspot.com/o/ahrimy%2FZaAHu8bgRVI0L6EUHQCS%2Fimage1?alt=media&token=5e04e205-0230-41c7-9da5-ddb05015691a"),
        PostThumbnail(postId: "p9BuAMHkkAcrHAcGRcTU", image: "https://firebasestorage.googleapis.com/v0/b/travelog-6cf98.appspot.com/o/ahrimy%2Fp9BuAMHkkAcrHAcGRcTU%2Fimage1?alt=media&token=a9708bce-06ed-4714-a208-2f720cd36095"),
        ]

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
