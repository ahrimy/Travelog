//
//  AttractionService.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/05/31.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import MapKit

class AttractionService {
    static let shared = AttractionService()
    
    private init(){
        db = Firestore.firestore()
        storage = Storage.storage()
        storageRef = storage.reference()
        attractions = []
    }
    
    let db: Firestore
    let storage : Storage
    let storageRef: StorageReference
    var attractions: [Attraction]
    
    func loadAttractions(){
        let documentRef = db.collection("attractions")
        documentRef.getDocuments(){(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let documents = querySnapshot!.documents
                for i in 0..<documents.count {
//                     print("\(documents[i].documentID) => \(documents[i].data())")
                    let data = documents[i].data()
                    let id = documents[i].documentID
                    guard let name = data["name"] as? String else { continue }
                    guard let locality = data["locality"] as? String else { continue }
                    guard let countryCode = data["countryCode"] as? String else { continue }
                    guard let imageUrl = data["imageUrl"] as? String else { continue }
                    do{
                        let url = URL(string: imageUrl)!
                        let imageData = try Data(contentsOf: url)
                        let image = UIImage(data: imageData)!
                        self.attractions.append(Attraction(id:id,
                                                  image: image,
                                                  name:name,
                                                  locality:locality,
                                                  countryCode:countryCode))
                    }catch{
                        print("Error occured while load image from url")
                    }
                }
            }
            
        }
    }
}
