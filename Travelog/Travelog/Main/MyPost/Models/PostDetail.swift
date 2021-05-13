//
//  PostDetail.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/05/09.
//

import Foundation
import UIKit

class PostDetail {
    
    init(id:String = "-1",
         images:[UIImage] = [],
         date:Date = Date(),
         text:String = "",
         createdAt:Date = Date(),
         updatedAt:Date = Date(),
         location:Location,
         likes:Int = 0,
         likeUsers:[String] = [],
         comments:Int = 0,
         writer:String = ""){
        self.id = id
        self.images = images
        self.date = date
        self.text = text
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.location = location
        self.likes = likes
        self.likeUsers = likeUsers
        self.comments = comments
        self.writer = writer
    }
    
    var id: String
    var images: [UIImage]
    var date: Date
    var text: String
    var createdAt: Date
    var updatedAt: Date
    var location: Location
    var likes:Int
    var likeUsers:[String]
    var comments:Int
    var writer:String
    
}
