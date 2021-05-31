//
//  AttractionOverview.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/05/31.
//

import Foundation
import UIKit
import MapKit

class Attraction{
    
    init(id:String,
         image:UIImage,
         name:String,
         locality:String,
         countryCode:String){
        self.id = id
        self.image = image
        self.name = name
        self.locality = locality
        self.countryCode = countryCode
    }
    
    let id: String
    let image:UIImage
    let name:String
    let locality:String
    let countryCode: String
    
}
