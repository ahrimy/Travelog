//
//  StarredPostListViewController.swift
//  Travelog
//
//  Created by 강예나 on 2021/04/06.
//

import UIKit

class StarredPostListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var posts:[PostOverview] = []
    let cellIdentifier: String = "StarredPostListCell"
    @IBOutlet weak var StarredPostListCollectionView: UICollectionView!
    
    func appendPost(post:PostOverview){
        self.posts.append(post)
        self.StarredPostListCollectionView.reloadData()
    }
    
    func loadPosts(posts:[PostOverview]){
        self.posts = posts
        self.StarredPostListCollectionView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StarredPostListCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        StarredPostListCollectionView.backgroundColor = .systemBackground
        view.addSubview(StarredPostListCollectionView)

        StarredPostListCollectionView.translatesAutoresizingMaskIntoConstraints = false // AutoLayout 설정
        StarredPostListCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        StarredPostListCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        StarredPostListCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        StarredPostListCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true

        StarredPostListCollectionView.register(StarredPostListCell.self, forCellWithReuseIdentifier: StarredPostListCell.reuseIdentifier)
        
        StarredPostListCollectionView.dataSource = self
        StarredPostListCollectionView.delegate = self
        
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        StarredPostListCollectionView.reloadData()
//    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StarredPostListCell", for: indexPath) as? StarredPostListCell else { return UICollectionViewCell()}
        
        cell.configure(with: posts[indexPath.row])
        
        return cell
    }

}



extension StarredPostListViewController:  UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("\(sections[0].items[indexPath.item])") // TODO: 셀 클릭 했을 때, 동작

        // 포스트 상세 페이지 모달
        guard let postDetailView = self.storyboard?.instantiateViewController(withIdentifier: "postDetailView") as? StarredPostDetailViewController else {
            return
        }
        postDetailView.modalTransitionStyle = .coverVertical
        PostService.shared.loadPostDetail(postId: posts[indexPath.row].id){post in
            postDetailView.loadPost(post: post)
            self.present(postDetailView, animated: true, completion: nil)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 2, height: 300) // TODO: 셀 사이즈 지정
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
