//
//  MyPostListViewController.swift
//  Travelog
//
//  Created by 강예나 on 2021/03/31.
//

import UIKit

class MyPostListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let posts = [
        PostThumbnail(postId: "1", image: "https://user-images.githubusercontent.com/26592306/112343616-a7d4e680-8d06-11eb-928a-1714f8acc9bd.jpeg"),
        PostThumbnail(postId:"2",image:"https://user-images.githubusercontent.com/26592306/112343646-ab686d80-8d06-11eb-8d7d-8af1eddd0a74.jpeg"),
        PostThumbnail(postId: "3", image: "https://user-images.githubusercontent.com/26592306/112343650-ac010400-8d06-11eb-8845-56d5086add38.jpeg"),
        PostThumbnail(postId: "4", image: "https://user-images.githubusercontent.com/26592306/112343653-ad323100-8d06-11eb-9a10-50a65e6d24b2.jpeg"),
        PostThumbnail(postId: "5", image: "https://user-images.githubusercontent.com/26592306/112343655-adcac780-8d06-11eb-8e2f-1a28d6bb44ba.jpeg"),
        PostThumbnail(postId: "6", image: "https://user-images.githubusercontent.com/26592306/112343673-b02d2180-8d06-11eb-9ebd-1949c80ce163.jpeg"),
        PostThumbnail(postId: "7", image: "https://user-images.githubusercontent.com/26592306/112343684-b28f7b80-8d06-11eb-9804-effc377924fa.jpeg"),

        PostThumbnail(postId: "8", image: "https://user-images.githubusercontent.com/26592306/112343695-b3c0a880-8d06-11eb-9078-8f8a9e56d44e.jpeg"),
        PostThumbnail(postId: "9", image: "https://user-images.githubusercontent.com/26592306/112343702-b58a6c00-8d06-11eb-8ef9-b43986bc641c.jpeg"),

        PostThumbnail(postId: "10", image: "https://user-images.githubusercontent.com/26592306/112344303-4bbe9200-8d07-11eb-91ea-59f61b86e9d8.jpeg"),
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
