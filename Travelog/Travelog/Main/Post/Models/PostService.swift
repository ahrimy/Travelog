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
    
    private init(){
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
                let imageRef:StorageReference = storageRef.child("\(writer)/\(ids[i]).jpeg")
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpeg"
                imageRef.putData(imageData, metadata: metaData){(metaData, error) in
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
                "locality" : location.locality ,
                "countryCode" : location.countryCode ,
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
                    "country" : location.country,
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
            self.loadPostOverviews(documentRef: documentRef, loadPosts: loadPosts)
        }
    }
    
    func loadStarredPostOverviews(loadPosts:@escaping ([PostOverview]) -> Void){
        if let starredUsers = UserService.shared.user?.starredUsers, starredUsers
            .count > 0 {
            let documentRef = db.collection("postoverviews").whereField("writer", in: starredUsers).whereField("isPublic", isEqualTo: true)
            self.loadPostOverviews(documentRef: documentRef, loadPosts: loadPosts)
        }
    }
    
    func loadAttractionPostOverviews(locality:String, countryCode: String, loadPosts:@escaping ([PostOverview]) -> Void){
        let documentRef = db.collection("postoverviews")
            .whereField("isPublic", isEqualTo: true)
            .whereField("locality", isEqualTo: locality)
            .whereField("countryCode", isEqualTo: countryCode)
        self.loadPostOverviews(documentRef: documentRef, loadPosts: loadPosts)

    }
  
    //?????? ?????? X
    func loadPostOverviewsForMyPostList(loadPosts:@escaping ([PostOverview]) -> Void){
       if let username = UserService.shared.user?.username {
        let documentRef = db.collection("postoverviews").whereField("writer", isEqualTo: username).limit(to: 5)
           self.loadPostOverviews(documentRef: documentRef, loadPosts: loadPosts)
       }
    }
    //?????? ?????? X
    func loadPostOverviewsForMyPostMap(loadPosts:@escaping ([PostOverview]) -> Void){
       if let username = UserService.shared.user?.username {
           let documentRef = db.collection("postoverviews").whereField("writer", isEqualTo: username).limit(to: 5)
           self.loadPostOverviews(documentRef: documentRef, loadPosts: loadPosts)
       }
    }
    //?????? ?????? X
    func loadPostOverviewsForStarredPostList(loadPosts:@escaping ([PostOverview]) -> Void){
        // TODO: ????????? ??????????????? ????????? ??? ?????????
        if let starredUsers = UserService.shared.user?.starredUsers , starredUsers
        .count > 0{
            let documentRef = db.collection("postoverviews").whereField("writer", in: starredUsers).whereField("isPublic", isEqualTo: true)
            self.loadPostOverviews(documentRef: documentRef, loadPosts: loadPosts)
        }
    }
    //?????? ?????? X
    func loadPostOverviewsForStarredPostMap(loadPosts:@escaping ([PostOverview]) -> Void){
        // TODO: ????????? ??????????????? ????????? ??? ?????????
        if let starredUsers = UserService.shared.user?.starredUsers, starredUsers
            .count > 0 {
            let documentRef = db.collection("postoverviews").whereField("writer", in: starredUsers).whereField("isPublic", isEqualTo: true)
            self.loadPostOverviews(documentRef: documentRef, loadPosts: loadPosts)
        }
    }
    
    func loadPostOverviews(documentRef:Query,loadPosts:@escaping ([PostOverview]) -> Void){
        var posts:[PostOverview] = []
        documentRef.getDocuments(){(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let documents = querySnapshot!.documents
                var count = 0
                for i in 0..<documents.count {
                    count += 1
//                     print("\(documents[i].documentID) => \(documents[i].data())")
                    let data = documents[i].data()
                    let id = documents[i].documentID
                    guard let writer = data["writer"] as? String else { continue }
                    guard let comments = data["comments"] as? Int else { continue }
                    guard let likes = data["likes"] as? Int else { continue }
                    guard let date = data["date"] as? Timestamp else { continue }
                    guard let createdAt = data["createdAt"] as? Timestamp else { continue }
                    guard let coordinateData = data["coordinate"] as? GeoPoint else { continue }
                    let coordinate = CLLocation(latitude: coordinateData.latitude, longitude: coordinateData.longitude)
                    guard let locationName = data["locationName"] as? String else { continue }
                    guard let text = data["text"] as? String else { continue }
                    
                    guard let imageUrl = data["imageUrl"] as? String else { continue }
                    let post = PostOverview(id:id,
                                           imageUrl: imageUrl,
                                           date: date.dateValue(),
                                           text:text,
                                           createdAt: createdAt.dateValue(),
                                           coordinate: coordinate,
                                           locationName: locationName,
                                           likes: likes,
                                           comments: comments,
                                           writer: writer)
                    posts.append(post)
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
                
                guard let imageUrls = data["imageUrls"] as? [String] else { return }
                let post = PostDetail(id: id, imageUrls: imageUrls, date: date.dateValue(), text: text, createdAt: createdAt.dateValue(), updatedAt: updatedAt.dateValue(), location: Location(name: name, address: address, postalCode: postalCode, country: country, coordinate: coordinate), likes: likes, likeUsers: likeUsers, comments: comments, writer: writer)

                loadPost(post)
            } else {
                print("Document does not exist")
            }
        }
    }
    func deletePost(postId:String){
        db.collection("postoverviews").document(postId).delete()
        db.collection("postdetails").document(postId).delete()
    }
    func updateLikes(postId:String, uid:String, isLike: Bool){
        let ref_details = db.collection("postdetails").document(postId)
        let ref_overviews = db.collection("postoverviews").document(postId)
        
        db.runTransaction({(Transaction, ErrorPointer) -> Any? in let Document: DocumentSnapshot
            do{ try Document = Transaction.getDocument(ref_details)
            } catch let fetchError as NSError{
                ErrorPointer?.pointee = fetchError
                return nil
            }
            guard let like = Document.data()?["likes"] as? Int else{
                let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey:"Unable to retrieve like from snapshot \(Document)"])
                ErrorPointer?.pointee = error
                return nil
            }
            if isLike {
                Transaction.updateData(["likes": like + 1], forDocument: ref_details)
                Transaction.updateData(["likes": like + 1], forDocument: ref_overviews)
                Transaction.updateData(["likeUsers": FieldValue.arrayUnion([uid])], forDocument: ref_details)
            }else{
                Transaction.updateData(["likes": like - 1], forDocument: ref_details)
                Transaction.updateData(["likes": like - 1], forDocument: ref_overviews)
                Transaction.updateData(["likeUsers": FieldValue.arrayRemove([uid])], forDocument: ref_details)
            }
            return nil
        }, completion: { (object, error) in
            if let error = error {
                //???????????????
                print("Transaction failed: \(error)")
            } else {
                //???????????? ??? ??????
                print("Transaction successfully committed!")
            }
        })
    }
}
