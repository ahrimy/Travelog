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
    static let shared = PostService()
    
    init(){
        db = Firestore.firestore()
        storage = Storage.storage()
        storageRef = storage.reference()
        posts = []
    }
    
    let db: Firestore
    let storage : Storage
    let storageRef: StorageReference
    var posts: [PostOverview]
    
    func uploadImage(postId:String, writer:String, ids:[String], images:[UIImage]){
        var imageUrls = [String](repeating: "", count: images.count)
        var count = 0
        for i in 0..<images.count{
            if let imageData = images[i].jpegData(compressionQuality: 0.8){
                let imageRef:StorageReference = storageRef.child("\(writer)/\(ids[i])")
                imageRef.putData(imageData, metadata: nil){(metaData, error) in
                    if let error = error {
                        count += 1
                        print(error.localizedDescription)
                        return
                    }else {
                        print("Image successfully uploaded!")
                        imageRef.downloadURL { (url, error) in
                            count += 1
                            guard let downloadURL = url else {
                                print(error?.localizedDescription ?? "Error occured")
                                return
                            }
                            imageUrls[i] = downloadURL.absoluteString
                            if images.count == count {
                                self.db.collection("postoverviews").document(postId).setData(["imageUrl":imageUrls[0]], merge: true)
                                self.db.collection("postdetails").document(postId).setData(["imageUrls":imageUrls], merge: true)
                            }
                        }
                    }
                }
            }
        }
    }
    func uploadPostOverview(id:String,data: [String:Any], imageId:String){
        let location = data["location"] as! Location
        db.collection("postoverviews").document(id)
            .setData([
                "writer" : data["writer"] as! String,
                "image" : imageId,
                "date" : data["date"] as! Date,
                "text" : data["text"] as! String,
                "coordinate":GeoPoint(latitude: location.coordinate.coordinate.latitude, longitude: location.coordinate.coordinate.longitude),
                "locationName":"\(location.name), \(location.country)",
                "createdAt" : data["createdAt"] as! Date,
                "isPublic" : data["isPublic"] as! Bool,
                "likes" : 0,
                "comments" : 0
            ], merge: true){ err in
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
                "writer" : data["writer"] as! String,
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
            ], merge: true){ err in
                if let err = err {
                    print("Error writing document: \(err)")
                    return
                } else {
                    print("Post detail successfully written!")
                }
            }
    }
    
    func loadMyPostOverviews(loadPosts:@escaping ([PostOverview]) -> Void){
        if let username = UserService.shared.user?.username {
            let documentRef = db.collection("postoverviews").whereField("writer", isEqualTo: username)
            self.appedPostOverviews(documentRef: documentRef, loadPosts: loadPosts)
        }
    }
  
    //현재 사용 X
    func loadPostOverviewsForMyPostList(loadPosts:@escaping ([PostOverview]) -> Void){
       if let username = UserService.shared.user?.username {
           let documentRef = db.collection("postoverviews").whereField("writer", isEqualTo: username).limit(to: 5)
           self.appedPostOverviews(documentRef: documentRef, loadPosts: loadPosts)
       }
    }
    //현재 사용 X
    func loadPostOverviewsForMyPostMap(loadPosts:@escaping ([PostOverview]) -> Void){
       if let username = UserService.shared.user?.username {
           let documentRef = db.collection("postoverviews").whereField("writer", isEqualTo: username).limit(to: 5)
           self.appedPostOverviews(documentRef: documentRef, loadPosts: loadPosts)
       }
    }
    func loadPostOverviewsForStarredPostList(loadPosts:@escaping ([PostOverview]) -> Void){
        // TODO: 데이터 부분적으로 가져올 수 있도록
        if let starredUsers = UserService.shared.user?.starredUsers , starredUsers
        .count > 0{
            let documentRef = db.collection("postoverviews").whereField("writer", in: starredUsers).whereField("isPublic", isEqualTo: true).limit(to: 5)
            self.appedPostOverviews(documentRef: documentRef, loadPosts: loadPosts)
        }
    }
    func loadPostOverviewsForStarredPostMap(loadPosts:@escaping ([PostOverview]) -> Void){
        // TODO: 데이터 부분적으로 가져올 수 있도록
        if let starredUsers = UserService.shared.user?.starredUsers, starredUsers
            .count > 0 {
            let documentRef = db.collection("postoverviews").whereField("writer", in: starredUsers).whereField("isPublic", isEqualTo: true).limit(to: 5)
            self.appedPostOverviews(documentRef: documentRef, loadPosts: loadPosts)
        }
    }
    
    func appedPostOverviews(documentRef:Query,loadPosts:@escaping ([PostOverview]) -> Void){
        var posts:[PostOverview] = []
        documentRef.getDocuments(){(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let documents = querySnapshot!.documents
                var count = 0
                for i in 0..<documents.count {
                    count += 1
//                    print("\(documents[i].documentID) => \(documents[i].data())")
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
                    
//                    guard let imageRef = data["image"] as? String else { return }
                    guard let imageUrl = data["imageUrl"] as? String else { return }
                    do{
                        let url = URL(string: imageUrl)!
                        let imageData = try Data(contentsOf: url)
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
                    }catch{
                        print("Error occured while load image from url")
                    }
                    if count == documents.count {
                        loadPosts(posts)
                    }
                }
            }
            
        }
    }
    func loadPostDetail(postId: String, loadPost:@escaping (PostDetail) -> Void){
        db.collection("postdetails").document(postId).getDocument{(document, error) in
            if let document = document, document.exists {
                guard let data = document.data() else {return}
                let id = document.documentID
                guard let date = data["date"] as? Timestamp else { return }
                guard let text = data["text"] as? String else { return }
                guard let createdAt = data["createdAt"] as? Timestamp else { return }
                guard let updatedAt = data["updatedAt"] as? Timestamp else { return }
                guard let location = data["location"] as? [String:Any] else { return }
                guard let likes = data["likes"] as? Int else { return }
                guard let likeUsers = data["likeUsers"] as? [String] else { return }
                guard let comments = data["comments"] as? Int else { return }
                guard let writer = data["writer"] as? String else { return }
                guard let name = location["name"] as? String else { return }
                guard let address = location["address"] as? String else { return }
                guard let postalCode = location["postalCode"] as? String else { return }
                guard let country = location["country"] as? String else { return }
                guard let coordinateData = location["coordinate"] as? GeoPoint else { return }
                let coordinate = CLLocation(latitude: coordinateData.latitude, longitude: coordinateData.longitude)
                
//                guard let imageRefs = data["images"] as? [String] else { return }
                guard let imageUrls = data["imageUrls"] as? [String] else { return }
                var images:[UIImage] = []
                var count = 0
                for i in 0..<imageUrls.count {
                    do{
                        count += 1
                        let url = URL(string: imageUrls[i])!
                        let imageData = try Data(contentsOf: url)
                        let image = UIImage(data: imageData)!
                        images.append(image)
                        
                        if count == imageUrls.count{
                            loadPost(PostDetail(id: id, images: images, date: date.dateValue(), text: text, createdAt: createdAt.dateValue(), updatedAt: updatedAt.dateValue(), location: Location(name: name, address: address, postalCode: postalCode, country: country, coordinate: coordinate), likes: likes, likeUsers: likeUsers, comments: comments, writer: writer))
                        }
                    }catch{
                        print("Error occured while load image from url")
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}
