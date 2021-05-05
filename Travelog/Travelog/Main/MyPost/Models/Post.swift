//
//  Post.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/04/19.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore

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
    func setLocation(placeInfo:[String:String]){
        self.location.latitude = placeInfo["latitude"]!
        self.location.longitude = placeInfo["longitude"]!
        self.location.name = placeInfo["name"]!
        self.location.address = placeInfo["address"]!
        self.location.postalCode = placeInfo["postalCode"]!
        self.location.country = placeInfo["country"]!
    }
    func resetLocation(){
        self.location.latitude = ""
        self.location.longitude = ""
        self.location.name = "No Location"
        self.location.address = ""
        self.location.postalCode = ""
        self.location.country = ""
    }
    func changePrivacy(isPublic:Bool){
        self.isPublic = isPublic
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
    func upload(images:[Data], group:DispatchGroup){
        let storageRef = Storage.storage().reference()
        images.forEach{image in
            let imageRef = storageRef.child("\(self.writer)/\(UUID().uuidString)")
            imageRef.putData(image, metadata: nil){
                (metaData, error) in if let error = error {
                    print(error.localizedDescription)
                    return
                }else{
                    imageRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            print(error?.localizedDescription ?? "Error occured")
                            return
                        }
                        self.imageRefs.append(downloadURL.absoluteString)
                        
                        if images.count == self.imageRefs.count {
                            self.uploadPost(group: group)
                        }
                    }
                }
            }
        }
    }
    func uploadPost(group:DispatchGroup){
        let db = Firestore.firestore()
        self.createdAt = Date()
        self.updatedAt = Date()
        let ref = db.collection("posts").addDocument(data:self.getPostData()){ err in
            if let err = err {
                print("Error writing document: \(err)")
                return
            } else {
                print("Document successfully written!")
                group.leave()
            }
        }
        self.id = ref.documentID
    }
}
