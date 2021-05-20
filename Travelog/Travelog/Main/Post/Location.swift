//
//  Location.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/04/20.
//

import Foundation
import MapKit

class Location{
    
    init(name:String = "No Location",
         address:String = "",
         postalCode:String = "",
         country: String = "",
         coordinate:CLLocation = CLLocation(latitude: 0.0, longitude: 0.0)){
        self.name = name
        self.address = address
        self.postalCode = postalCode
        self.country = country
        self.coordinate = coordinate
    }
    
    var name:String
    var address:String
    var postalCode:String
    var country:String
    var coordinate: CLLocation
    
    func updateLocation(info:[String: Any]) {
        self.name = info["name"] as! String
        self.address = info["address"] as! String
        self.postalCode = info["postalCode"] as! String
        self.country = info["country"] as! String
        self.coordinate = info["coordinate"] as! CLLocation
    }
}
