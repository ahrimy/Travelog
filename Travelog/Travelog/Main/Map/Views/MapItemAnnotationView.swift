//
//  MapItemAnnotationView.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/05/22.
//

import MapKit

final class MapItemAnnotationView: MKAnnotationView {

    override var annotation: MKAnnotation? {
            didSet {
                guard let mapItem = annotation as? MapItem else { return }
                displayPriority = .required
                
                self.clusteringIdentifier = "MapItem"
                if let image = mapItem.image {
                    self.image = image
                }else{
                    self.load(urlString: mapItem.imageUrl)
                }
                self.frame.size = CGSize(width: 60, height: 60)
                self.layer.masksToBounds = true
                self.layer.borderWidth = 2
                self.layer.borderColor = UIColor.white.cgColor
                self.layer.cornerRadius = 5
            }
        }

}
