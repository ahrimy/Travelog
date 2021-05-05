//
//  Location.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/04/20.
//

import Foundation

class Location{
    
    init(){
        self.latitude = ""
        self.longitude = ""
        self.name = "No Location"
        self.address = ""
        self.postalCode = ""
        self.country = ""
    }
    
    var latitude: String
    var longitude: String
    var name: String
    var address: String
    var postalCode: String
    var country: String
    
    func getLocationData() -> [String:Any] {
        return[
            "latitude":self.latitude,
            "longitude":self.longitude,
            "name":self.name,
            "address":self.address,
            "postalCode":self.postalCode,
            "country":self.country
        ]
    }
}
