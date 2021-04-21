//
//  Location.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/04/20.
//

import Foundation

class Location{
    
    init(
        lat: String = "",
        lng: String = "",
        title: String = "",
        subTitle: String = ""
    ){
        self.lat = lat
        self.lng = lng
        self.title = title
        self.subTitle = subTitle
    }
    
    var lat: String
    var lng: String
    var title: String
    var subTitle: String
}
