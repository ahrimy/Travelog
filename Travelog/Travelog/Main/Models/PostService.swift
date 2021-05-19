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
        storageRef = storage.reference()
        self.username = username
    }
    
    var db: Firestore
    var storage : Storage
    var username: String
    var storageRef: StorageReference
    
    func uploadImage(ids:[String], images:[UIImage]){
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
                "text" : data["text"] as! String,
                "coordinate":GeoPoint(latitude: location.coordinate.coordinate.latitude, longitude: location.coordinate.coordinate.longitude),
                "locationName":"\(location.name), \(location.country)",
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
                "text" : data["text"] as! String,
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
  
    func loadPostOverviewsForMyPostList(loadPosts:@escaping ([PostOverview]) -> Void){
        let documentRef = db.collection("postoverviews").whereField("writer", isEqualTo: self.username)
        self.appedPostOverviews(documentRef: documentRef, loadPosts: loadPosts)
    }
    func loadPostOverviewsForMyPostMap(loadPosts:@escaping ([PostOverview]) -> Void){
        let documentRef = db.collection("postoverviews").whereField("writer", isEqualTo: self.username)
        self.appedPostOverviews(documentRef: documentRef, loadPosts: loadPosts)
    }
    func loadPostOverviewsForStarredPostList(loadPosts:@escaping ([PostOverview]) -> Void){
        // TODO: starred list 에 있는 user의 포스트 가져오도록 조건 변경
        let documentRef = db.collection("postoverviews").whereField("writer", isEqualTo: self.username)
        self.appedPostOverviews(documentRef: documentRef, loadPosts: loadPosts)
    }
    func loadPostOverviewsForStarredPostMap(loadPosts:@escaping ([PostOverview]) -> Void){
        // TODO: starred list 에 있는 user의 포스트 가져오도록 조건 변경
        let documentRef = db.collection("postoverviews").whereField("writer", isEqualTo: self.username)
        self.appedPostOverviews(documentRef: documentRef, loadPosts: loadPosts)
    }
    
    func appedPostOverviews(documentRef:Query,loadPosts:@escaping ([PostOverview]) -> Void){
        var posts:[PostOverview] = []
        documentRef.getDocuments(){(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let documents = querySnapshot!.documents
                for i in 0..<documents.count {
//                    print("\(documents[i].documentID) => \(documents[i].data())")
                    //TODO: Location 추가
                    let data = documents[i].data()
                    let id = documents[i].documentID
                    guard let writer = data["writer"] as? String else { return }
                    guard let comments = data["comments"] as? Int else { return }
                    guard let likes = data["likes"] as? Int else { return }
                    guard let date = data["date"] as? Timestamp else { return }
                    guard let createdAt = data["createdAt"] as? Timestamp else { return }
                    guard let coordinateData = data["coordinate"] as? GeoPoint else { return }
                    let coordinate = CLLocation(latitude: coordinateData.latitude, longitude: coordinateData.longitude)
                    guard let locationName = data["locationName"] as? String else { return }
                    guard let text = data["text"] as? String else { return }
                    
                    guard let imageRef = data["image"] as? String else { return }
                    self.storageRef.child("\(writer)/\(imageRef)").downloadURL{ url, err in
                        if let err = err {
                            print("Error occurred while get url \(err)")
                        }else{
                            do{
                                let imageData = try Data(contentsOf: url!)
                                let image = UIImage(data: imageData)!
                            
                                posts.append(PostOverview(id:id,
                                                          image: image,
                                                          date: date.dateValue(),
                                                          text:text,
                                                          createdAt: createdAt.dateValue(),
                                                          coordinate: coordinate,
                                                          locationName: locationName,
                                                          likes: likes,
                                                          comments: comments,
                                                          writer: writer))
//                                appendPost(PostOverview(id:id,
//                                                                 image: image,
//                                                                 date: date.dateValue(),
//                                                                 text:text,
//                                                                 createdAt: createdAt.dateValue(),
//                                                                 coordinate: coordinate,
//                                                                 locationName: locationName,
//                                                                 likes: likes,
//                                                                 comments: comments,
//                                                                 writer: writer))
                                if documents.count == posts.count {
                                    loadPosts(posts)
                                }
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
