//
//  PostList.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/05/05.
//

import Foundation
import FirebaseFirestore

//class PostList{
//    
//    init() {
//        self.list = []
//    }
//    var list:[PostThumbnail]
//    
//    func loadPosts(listVC: MyPostViewController){
//        let db = Firestore.firestore()
//        let docRef = db.collection("posts").whereField("writer", isEqualTo: "ahrimy")
//        docRef.getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
////                self.list = querySnapshot!.documents
//                for document in querySnapshot!.documents {
////                    print("\(document.documentID) => \(document.data())")
//                    let data = document.data()
//                    var imageRef = ""
//                    if let imageRefs = data["imageRefs"] as? NSArray{
//                        imageRef = imageRefs[0] as! String
//                    }
//                    var latitude = ""
//                    var longitude = ""
//                    if let location = data["location"] as? [String: Any]{
//                        latitude = location["latitude"] as! String
//                        longitude = location["longitude"] as! String
//                    }
//                    
//                    self.list.append(PostThumbnail(postId: document.documentID, image: imageRef, latitude: latitude, longitude: longitude))
//                }
//                listVC.reloadData(list: self.list)
//            }
//        }
//    }
//}
