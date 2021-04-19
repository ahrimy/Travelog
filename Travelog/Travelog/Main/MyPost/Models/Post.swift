//
//  Post.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/04/19.
//

import Foundation

class Post {
    
    init(
        id: Int = -1,
        date: String="",
        text: String="",
        image: [Image] = [],
        location: Location? = nil,
        isPublic: Bool = false,
        createdAt: String="",
        updatedAt:String=""
    ){
        self.id = id
        self.date = date
        self.text = text
        self.image = image
        self.location = location
        self.isPublic = isPublic
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    var id : Int
    var date: String
    var text: String
    var image: [Image]
    var location: Location?
    var isPublic: Bool
    var createdAt: String
    var updatedAt: String
}
