//
//  UserService.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/05/20.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class UserService {
    
    init(){
        db = Firestore.firestore()
        storage = Storage.storage()
        storageRef = storage.reference()
        auth = Auth.auth()
    }
    
    var db: Firestore
    var storage : Storage
    var storageRef: StorageReference
    var auth: Auth
    
    func getUser(setUser:@escaping (_ user:User)->Void){
        if let authUser = auth.currentUser {
            db.collection("users").whereField("uid", isEqualTo: authUser.uid).getDocuments(){(querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    let data = querySnapshot!.documents[0].data()
                    let username = (data["username"] ?? "") as! String
                    let starredUsers = (data["starredUsers"] ?? []) as! [String]
                    
                    setUser(User(uid: authUser.uid, username: username, starredUsers: starredUsers))
                }
            }

        }
    }
    func signIn(email:String, password:String, completion:@escaping ()->Void){
        auth.signIn(withEmail: email, password: password) {(authResult, error) in
            if authResult?.user != nil{
                print("login success")
                completion()
            }else{
                print("login fail")
            }
        }
    }
    func signOut(completion:()->Void){
        do {
          try auth.signOut()
            completion()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
}
