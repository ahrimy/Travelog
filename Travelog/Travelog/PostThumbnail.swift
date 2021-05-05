//
//  PostThumbnail.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/03/25.
//

import Foundation

class PostThumbnail {
    
    init(postId: String , image: String, latitude: String, longitude: String){
        self.postId = postId
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
    }
    
    let postId : String
    let image: String
    let latitude: String
    let longitude: String
    
}
