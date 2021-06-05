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
         image:UIImage? = nil,
         imageUrl:String,
         locality:String,
         countryCode:String,
         country:String){
        self.id = id
        self.image = image
        self.imageUrl = imageUrl
        self.name = "  \(locality), \n  \(country)"
        self.locality = locality
        self.countryCode = countryCode
        self.country = country
    }
    
    let id: String
    var image:UIImage?
    let imageUrl:String
    let name:String
    let locality:String
    let countryCode: String
    let country: String
    
}
