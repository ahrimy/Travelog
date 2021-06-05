//
//  MapItem.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/05/22.
//

import Foundation
import MapKit

final class MapItem: NSObject, MKAnnotation {
    
    let image: UIImage?
    let coordinate: CLLocationCoordinate2D
    let imageUrl:String
    
    init(post: PostOverview) {
        self.coordinate = post.coordinate.coordinate
        self.imageUrl = post.imageUrl
        self.image = post.image
    }
}
