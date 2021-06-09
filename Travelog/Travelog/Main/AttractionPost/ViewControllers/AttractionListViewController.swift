//
//  AllPostViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/03/30.
//

import UIKit

class AttractionListViewController: UIViewController, UISearchBarDelegate,UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Properties
    var attractions:[Attraction] = []
    let sectionInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    
    // MARK: - IBOutlet
    @IBOutlet weak var attractionCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.backButtonDisplayMode = .minimal
        attractionCollectionView.register(AttractionCollectionViewCell.self, forCellWithReuseIdentifier: AttractionCollectionViewCell.reuseIdentifier)
        attractions = AttractionService.shared.attractions
        attractionCollectionView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attractions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttractionCollectionViewCell.reuseIdentifier, for: indexPath) as! AttractionCollectionViewCell
        
        cell.attraction = attractions[indexPath.row]
        cell.imageView.load(urlString: attractions[indexPath.row].imageUrl)
        cell.nameLabel.text = attractions[indexPath.row].name
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let attractionPostListViewController = self.storyboard?.instantiateViewController(identifier: "AttractionPostListViewController") as? AttractionPostListViewController{
            
            attractionPostListViewController.attraction = attractions[indexPath.row]
            attractionPostListViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(attractionPostListViewController, animated: false)
        }
    }
}

extension AttractionListViewController: UICollectionViewDelegateFlowLayout{
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
