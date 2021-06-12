//
//  AttractionPostListViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/06/02.
//

import UIKit

class AttractionPostListViewController: UIViewController {

    var attraction: Attraction?
    var posts:[PostOverview] = []
    let sectionInsets = UIEdgeInsets(top: 30, left: 10, bottom: 5, right: 10)
    
    @IBOutlet weak var nameLabel: UILabel!{
        didSet{
            nameLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var postCollectionView: UICollectionView!{
        didSet{
            postCollectionView.layer.cornerRadius = 50
            postCollectionView.layer.maskedCorners = [CACornerMask.layerMaxXMinYCorner, CACornerMask.layerMinXMinYCorner]
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = attraction?.name
        
        postCollectionView.register(PostOverviewCollectionViewCell.self, forCellWithReuseIdentifier: PostOverviewCollectionViewCell.reuseIdentifier)
        
        if let locality = attraction?.locality , let countryCode = attraction?.countryCode{
            PostService.shared.loadAttractionPostOverviews(locality: locality, countryCode: countryCode, loadPosts: loadPosts(posts:))
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Methods
    
    func loadPosts(posts:[PostOverview]){
        self.posts = posts
        self.postCollectionView.reloadData()
    }
}

extension AttractionPostListViewController:UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostOverviewCollectionViewCell.reuseIdentifier, for: indexPath) as! PostOverviewCollectionViewCell

        cell.configureData(post: posts[indexPath.row])
        cell.setUpHiddenUI(type: "attractionpost")
        
        return cell
    }
}

extension AttractionPostListViewController: UICollectionViewDelegateFlowLayout{
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
