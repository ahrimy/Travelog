//
//  AttractionPostListViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/06/02.
//

import UIKit

class AttractionPostListViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {

    var attraction: Attraction?
    var posts:[PostOverview] = []
    let sectionInsets = UIEdgeInsets(top: 50, left: 10, bottom: 5, right: 10)
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = attraction?.name
        nameLabel.numberOfLines = 2
        postCollectionView.layer.cornerRadius = 50
        postCollectionView.layer.maskedCorners = [CACornerMask.layerMaxXMinYCorner, CACornerMask.layerMinXMinYCorner]
        
        postCollectionView.register(AttractionPostCollectionViewCell.self, forCellWithReuseIdentifier: AttractionPostCollectionViewCell.reuseIdentifier)
        
        if let locality = attraction?.locality , let countryCode = attraction?.countryCode{
            print(locality)
            print(countryCode)
            PostService.shared.loadAttractionPostOverviews(locality: locality, countryCode: countryCode, loadPosts: loadPosts(posts:))
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func loadPosts(posts:[PostOverview]){
        self.posts = posts
        self.postCollectionView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttractionPostCollectionViewCell.reuseIdentifier, for: indexPath) as! AttractionPostCollectionViewCell
        
//        cell.post = posts[indexPath.row]
//        cell.imageView.load(urlString: posts[indexPath.row].imageUrl)
//        cell.nameLabel.text = posts[indexPath.row].writer
        cell.configureData(post: posts[indexPath.row])
        
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
