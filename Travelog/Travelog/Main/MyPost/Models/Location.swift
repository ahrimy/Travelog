//
//  Location.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/04/20.
//

import Foundation

class Location{
    
    init(
        lat: Float = 0.0,
        lng: Float = 0.0,
        title: String = "",
        subTitle: String = ""
    ){
        self.lat = lat
        self.lng = lng
        self.title = title
        self.subTitle = subTitle
    }
    
    var lat: Float
    var lng: Float
    var title: String
    var subTitle: String
}
