//
//  StarredPostDetailViewController.swift
//  Travelog
//
//  Created by 강예나 on 2021/05/03.
//

import UIKit

class StarredPostDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    // MARK: - Properties
    var data: StarredList?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 45
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
    }
    
    func configureUI() {
        locationLabel.text = data?.city
        dateLabel.text = data?.date
        textLabel.text = data?.text
        imageView.image = UIImage(named: data?.image ?? "")
        
        
        locationLabel.font = UIFont.systemFont(ofSize: 17)
        locationLabel.numberOfLines = 1
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        textLabel.font = UIFont.systemFont(ofSize: 16)
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .left
        textLabel.sizeToFit()
        textLabel.lineBreakStrategy = .hangulWordPriority
    }

}
