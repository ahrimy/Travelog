//
//  StarredPostListViewController.swift
//  Travelog
//
//  Created by 강예나 on 2021/04/06.
//

import UIKit

class StarredPostListViewController: UIViewController {

    var posts:[PostOverview] = []
    var starredPostDetailViewController: StarredPostDetailViewController?
    @IBOutlet weak var StarredPostListCollectionView: UICollectionView!
    let sectionInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)


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

        StarredPostListCollectionView.register(PostOverviewCollectionViewCell.self, forCellWithReuseIdentifier: PostOverviewCollectionViewCell.reuseIdentifier)
        
        StarredPostListCollectionView.dataSource = self
        StarredPostListCollectionView.delegate = self
        
    }
    
    // MARK: - Methods
    func appendPost(post:PostOverview){
        self.posts.append(post)
        self.StarredPostListCollectionView.reloadData()
    }
    
    func loadPosts(posts:[PostOverview]){
        self.posts = posts
        self.StarredPostListCollectionView.reloadData()
    }
    
    func updateLikes(index: Int, likes: Int){
        posts[index].likes = likes
        StarredPostListCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }

}

extension StarredPostListViewController:  UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostOverviewCollectionViewCell.reuseIdentifier, for: indexPath) as? PostOverviewCollectionViewCell else { return PostOverviewCollectionViewCell()}
        
        cell.configureData(post: posts[indexPath.row])
        return cell
    }
}

extension StarredPostListViewController:  UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // 포스트 상세 페이지 모달
        guard let postDetailView = self.starredPostDetailViewController else {
            return
        }
        postDetailView.modalTransitionStyle = .coverVertical
        PostService.shared.loadPostDetail(postId: posts[indexPath.row].id){post in
            postDetailView.index = indexPath.row
            postDetailView.loadPost(post: post)
            self.present(postDetailView, animated: true, completion: nil)
        }

    }
    
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
}
