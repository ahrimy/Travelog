//
//  PostService.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/05/09.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import MapKit

class PostService {
    
    init(username:String){
        db = Firestore.firestore()
        storage = Storage.storage()
        self.username = username
    }
    
    var db: Firestore
    var storage : Storage
    var username: String
    
    func uploadImage(ids:[String], images:[UIImage]){
        let storageRef = self.storage.reference()
        var imageRef:StorageReference
        for i in 0..<images.count{
            imageRef = storageRef.child("\(self.username)/\(ids[i])")
            if let imageData = images[i].jpegData(compressionQuality: 0.8){
                imageRef.putData(imageData, metadata: nil){(metaData, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }else {
                        print("Image successfully uploaded!")
                    }
                }
            }
        }
    }
    func uploadPostOverview(id:String,data: [String:Any], imageId:String){
        let location = data["location"] as! Location
        db.collection("postoverviews").document(id)
            .setData([
                "writer" : self.username,
                "image" : imageId,
                "date" : data["date"] as! Date,
                "coordinate":GeoPoint(latitude: location.coordinate.coordinate.latitude, longitude: location.coordinate.coordinate.longitude),
                "createdAt" : data["createdAt"] as! Date,
                "isPublic" : data["isPublic"] as! Bool,
                "likes" : 0,
                "comments" : 0
            ]){ err in
                if let err = err {
                    print("Error writing document: \(err)")
                    return
                } else {
                    print("Post overview successfully written!")
                }
            }
    }
    func uploadPostDetail(id:String, data: [String:Any], imageIds:[String]){
        let location = data["location"] as! Location
        db.collection("postdetails").document(id)
            .setData([
                "writer" : self.username,
                "images" : imageIds,
                "date" : data["date"] as! Date,
                "location" : [
                    "name" : location.name,
                    "address": location.address,
                    "coutry" : location.country,
                    "postalCode" : location.postalCode,
                    "coordinate": GeoPoint(latitude: location.coordinate.coordinate.latitude, longitude: location.coordinate.coordinate.longitude)
                ],
                "createdAt" : data["createdAt"] as! Date,
                "updatedAt" : data["createdAt"] as! Date,
                "isPublic" : data["isPublic"] as! Bool,
                "likes" : 0,
                "comments" : 0,
                "likeUsers" : []
            ]){ err in
                if let err = err {
                    print("Error writing document: \(err)")
                    return
                } else {
                    print("Post detail successfully written!")
                }
            }
    }
    func loadPostOverviewsForList(ref:MyPostListViewController){
        let storageRef = self.storage.reference()
        db.collection("postoverviews").whereField("writer", isEqualTo: "ahrimy").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let documents = querySnapshot!.documents
                for i in 0..<documents.count {
                    print("\(documents[i].documentID) => \(documents[i].data())")

                    let data = documents[i].data()
                    let id = documents[i].documentID
                    let writer = data["writer"] as! String
                    let comments = data["comments"] as! Int
                    let likes = data["likes"] as! Int
                    let date = data["date"] as! Timestamp
                    let createdAt = data["createdAt"] as! Timestamp
                    let coordinateData = data["coordinate"] as! GeoPoint
                    let coordinate = CLLocation(latitude: coordinateData.latitude, longitude: coordinateData.longitude)

                    let imageRef = data["image"] as! String

                    storageRef.child("\(self.username)/\(imageRef)").downloadURL{ url, err in
                        if let err = err {
                            print("Error occurred while get url \(err)")
                        }else{
                            do{
                                let imageData = try Data(contentsOf: url!)
                                let image = UIImage(data: imageData)!
                            
                                ref.appendPost(post: PostOverview(id:id,
                                                                  image: image,
                                                                  date: date.dateValue(),
                                                                  createdAt: createdAt.dateValue(),
                                                                  coordinate: coordinate,
                                                                  likes: likes,
                                                                  comments: comments,
                                                                  writer: writer))
                            }catch{
                                print("Error occured while load image from url")
                            }
                        }
                    }
                }
            }
        }
    }
    func loadPostOverviewsForMap(ref:MyPostMapViewController){
        let storageRef = self.storage.reference()
        db.collection("postoverviews").whereField("writer", isEqualTo: "ahrimy").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let documents = querySnapshot!.documents
                for i in 0..<documents.count {
                    print("\(documents[i].documentID) => \(documents[i].data())")
                    let data = documents[i].data()
                    let id = documents[i].documentID
                    let writer = data["writer"] as! String
                    let comments = data["comments"] as! Int
                    let likes = data["likes"] as! Int
                    let date = data["date"] as! Timestamp
                    let createdAt = data["createdAt"] as! Timestamp
                    let coordinateData = data["coordinate"] as! GeoPoint
                    let coordinate = CLLocation(latitude: coordinateData.latitude, longitude: coordinateData.longitude)

                    let imageRef = data["image"] as! String
                    storageRef.child("\(self.username)/\(imageRef)").downloadURL{ url, err in
                        if let err = err {
                            print("Error occurred while get url \(err)")
                        }else{
                            do{
                                let imageData = try Data(contentsOf: url!)
                                let image = UIImage(data: imageData)!
                            
                                ref.appendPost(post: PostOverview(id:id,
                                                                 image: image,
                                                                 date: date.dateValue(),
                                                                 createdAt: createdAt.dateValue(),
                                                                 coordinate: coordinate,
                                                                 likes: likes,
                                                                 comments: comments,
                                                                 writer: writer))
                                
                            }catch{
                                print("Error occured while load image from url")
                            }
                        }
                    }
                }
            }
        }
    }
    func loadPostDetail(){
        
    }
}
