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
        self.title = "No Location"
        self.subTitle = ""
    }
    
    var latitude: String
    var longitude: String
    var title: String
    var subTitle: String
    
    func getLocationData() -> [String:Any] {
        return[
            "latitude":self.latitude,
            "longitude":self.longitude,
            "title":self.title,
            "subTitle":self.subTitle
        ]
    }
}
