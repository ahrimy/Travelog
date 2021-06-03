//
//  AttractionPostListViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/06/02.
//

import UIKit

class AttractionPostListViewController: UIViewController {

    var attraction: Attraction?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = attraction?.name
        nameLabel.numberOfLines = 2
        postCollectionView.layer.cornerRadius = 50
        postCollectionView.layer.maskedCorners = [CACornerMask.layerMaxXMinYCorner, CACornerMask.layerMinXMinYCorner]
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
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
