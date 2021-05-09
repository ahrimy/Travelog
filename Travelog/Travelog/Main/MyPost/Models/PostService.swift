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
    
    init(){
        db = Firestore.firestore()
        storage = Storage.storage()
    }
    
    var db: Firestore
    var storage : Storage
    
    func uploadImage(){
        // TODO: upload image on storage
        print("image")
    }
    func uploadPostOverview(){
        // TODO: upload post overview
        print("overview")
    }
    func uploadPostDetail(){
        // TODO: upload post detail
        print("detail")
    }
    func loadPostOverviewsForList(ref:MyPostListViewController){
        var list:[PostOverview] = []
        db.collection("postoverviews").whereField("writer", isEqualTo: "ahrimy").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    do{
                        let data = document.data()
                        let id = document.documentID
                        let writer = data["writer"] as! String
                        let comments = data["comments"] as! Int
                        let likes = data["likes"] as! Int
                        let date = data["date"] as! Timestamp
                        let createdAt = data["createdAt"] as! Timestamp
                        let coordinateData = data["coordinate"] as! GeoPoint
                        let coordinate = CLLocation(latitude: coordinateData.latitude, longitude: coordinateData.longitude)

                        let imageRef = data["image"] as! String
                        let url = URL(string: imageRef)!
                        
                        let imageData = try Data(contentsOf: url)
                        let image = UIImage(data: imageData)!
                        
                        list.append(
                            PostOverview(id:id,
                                         image: image,
                                         date: date.dateValue(),
                                         createdAt: createdAt.dateValue(),
                                         coordinate: coordinate,
                                         likes: likes,
                                         comments: comments,
                                         writer: writer))
                        
                    }catch{
                        print("Error occured while load post")
                    }
                }
                ref.reloadData(list: list)
            }
        }
    }
    func loadPostOverviewsForMap(ref:MyPostMapViewController){
        var list:[PostOverview] = []
        db.collection("postoverviews").whereField("writer", isEqualTo: "ahrimy").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    do{
                        let data = document.data()
                        let id = document.documentID
                        let writer = data["writer"] as! String
                        let comments = data["comments"] as! Int
                        let likes = data["likes"] as! Int
                        let date = data["date"] as! Timestamp
                        let createdAt = data["createdAt"] as! Timestamp
                        let coordinateData = data["coordinate"] as! GeoPoint
                        let coordinate = CLLocation(latitude: coordinateData.latitude, longitude: coordinateData.longitude)

                        let imageRef = data["image"] as! String
                        let url = URL(string: imageRef)!
                        
                        let imageData = try Data(contentsOf: url)
                        let image = UIImage(data: imageData)!
                        
                        list.append(
                            PostOverview(id:id,
                                         image: image,
                                         date: date.dateValue(),
                                         createdAt: createdAt.dateValue(),
                                         coordinate: coordinate,
                                         likes: likes,
                                         comments: comments,
                                         writer: writer))
                        
                    }catch{
                        print("Error occured while load post")
                    }
                }
                ref.reloadData(list: list)
            }
        }
    }
    func loadPostDetail(){
        
    }
}
