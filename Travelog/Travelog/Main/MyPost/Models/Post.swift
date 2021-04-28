//
//  Post.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/04/19.
//

import Foundation

class Post{
    
    init(
        userId:String
    ){
        self.id = ""
        self.writer = userId
        self.date = Date()
        self.text = ""
        self.imageRefs = []
        self.location = Location()
        self.isPublic = true
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    var id: String
    var writer: String
    var date: Date
    var text: String
    var imageRefs: [String]
    var location: Location!
    var isPublic: Bool
    var createdAt: Date
    var updatedAt: Date
    
    func setDate(date:Date){
        self.date = date
    }
    func updateText(text:String){
        self.text = text
    }
    func appendImageReference(imageRef:String){
        self.imageRefs.append(imageRef)
    }
    func setLocation(latitude: String, longitude:String, title:String, subTitle:String){
        self.location.latitude = latitude
        self.location.longitude = longitude
        self.location.title = title
        self.location.subTitle = subTitle
    }
    func deleteLocation(){
        self.location.latitude = ""
        self.location.longitude = ""
        self.location.title = "No Location"
        self.location.subTitle = ""
    }
    func changePrivacy(isPublic:Bool){
        self.isPublic = isPublic
    }
    func uploadPost(){
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    func getPostData() -> [String:Any]{
        return [
            "writer":self.writer,
            "date":self.date,
            "text":self.text,
            "imageRefs":self.imageRefs,
            "location":self.location.getLocationData(),
            "isPublic":self.isPublic,
            "createdAt":self.createdAt,
            "updatedAt":self.updatedAt
        ]
    }
    func getImageRefsData() -> [String:[String]]{
        return ["imageRefs":imageRefs]
    }
}
