//
//  ClusterAnnotationView.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/05/22.
//

import UIKit
import MapKit

class ClusterAnnotationView: MKAnnotationView {

    private let countLabel = UILabel()
    
    override var annotation: MKAnnotation? {
        didSet {
            guard let cluster = annotation as? MKClusterAnnotation else { return }
            displayPriority = .required
            
            if let image = (cluster.memberAnnotations[0] as! MapItem).image {
                self.image = image
            }else{
                self.load(urlString: (cluster.memberAnnotations[0] as! MapItem).imageUrl)
            }
            self.frame.size = CGSize(width: 60, height: 60)
            self.layer.masksToBounds = true
            self.layer.borderWidth = 2
            self.layer.borderColor = UIColor.white.cgColor
            self.layer.cornerRadius = 5
            
            countLabel.frame = CGRect(x: 33, y: 33, width: 24, height: 24)
            countLabel.text = cluster.memberAnnotations.count < 10 ? "\(cluster.memberAnnotations.count)" : "9+"
            countLabel.font = UIFont(name: "Arial", size: 13)
            countLabel.textColor = UIColor.white
            countLabel.textAlignment = .center
            countLabel.backgroundColor = UIColor(red: 0.31, green: 0.16, blue: 0.36, alpha: 1.00)
            countLabel.layer.cornerRadius = 12
            countLabel.layer.masksToBounds = true

            self.addSubview(countLabel)
        }
    }
}
