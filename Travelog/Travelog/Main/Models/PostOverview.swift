//
//  PostOverView.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/05/09.
//

import Foundation
import UIKit
import MapKit

class PostOverview{
    
    init(id:String = "-1",
         image:UIImage,
         date:Date = Date(),
         text:String = "",
         createdAt: Date = Date(),
         coordinate:CLLocation = CLLocation(latitude: 0.0, longitude: 0.0 ),
         likes:Int = 0,
         comments: Int = 0,
         writer:String = ""){
        self.id = id
        self.image = image
        self.date = date
        self.text = text
        self.createdAt = createdAt
        self.coordinate = coordinate
        self.likes = likes
        self.comments = comments
        self.writer = writer
    }
    
    var id:String
    var image:UIImage
    var date:Date
    var text:String
    var createdAt: Date
    var coordinate: CLLocation
    var likes:Int
    var comments: Int
    var writer:String
    
}
