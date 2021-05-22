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
                
                clusteringIdentifier = "MapItem"
                image = mapItem.image
                frame.size = CGSize(width: 60, height: 60)
                layer.masksToBounds = true
                layer.borderWidth = 2
                layer.borderColor = UIColor.white.cgColor
                layer.cornerRadius = 5
            }
        }

}
