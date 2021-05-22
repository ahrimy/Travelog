//
//  ClusterAnnotationView.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/05/22.
//

import UIKit
import MapKit

class ClusterAnnotationView: MKAnnotationView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    private let countLabel = UILabel()

    override var annotation: MKAnnotation? {
        didSet {
            guard let cluster = annotation as? MKClusterAnnotation else { return }
            displayPriority = .defaultHigh
            
            image = (cluster.memberAnnotations[0] as! MapItem).image
            frame.size = CGSize(width: 60, height: 60)
            layer.masksToBounds = true
            layer.borderWidth = 2
            layer.borderColor = UIColor.white.cgColor
            layer.cornerRadius = 5
            
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
