//
//  MapItem.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/05/22.
//

import Foundation
import MapKit

final class MapItem: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    let image:UIImage
    
    init(post: PostOverview) {
        self.coordinate = post.coordinate.coordinate
        self.image = post.image
    }
}
