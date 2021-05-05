//
//  PostAnnotation.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/05/06.
//

import Foundation
import MapKit

class PostAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var image: UIImage

    init(coordinate: CLLocationCoordinate2D,title:String, image: UIImage) {
        self.coordinate = coordinate
        self.title = title
        self.image = image
    }
}
