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
    static let shared = UserService()
    
    init(){
        db = Firestore.firestore()
        storage = Storage.storage()
        storageRef = storage.reference()
        auth = Auth.auth()
    }
    
    let db: Firestore
    let storage : Storage
    let storageRef: StorageReference
    let auth: Auth
    var user: User?
    
    func authUser(authorizedCompletion:@escaping ()->Void, unAuthorizedCompletion: ()->Void){
        if let authUser = auth.currentUser {
            db.collection("users").whereField("uid", isEqualTo: authUser.uid).getDocuments(){(querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    let data = querySnapshot!.documents[0].data()
                    let username = (data["username"] ?? "") as! String
                    let starredUsers = (data["starredUsers"] ?? []) as! [String]
                    
                    UserService.shared.user = User(uid: authUser.uid, username: username, starredUsers: starredUsers)
                    authorizedCompletion()
                }
            }
        }else {
            unAuthorizedCompletion()
        }
    }
    func signIn(email:String, password:String, completion:@escaping ()->Void){
        auth.signIn(withEmail: email, password: password) {(authResult, error) in
            if authResult?.user != nil{
                print("login success")
                guard let uid = authResult?.user.uid else {return}
                self.db.collection("users").whereField("uid", isEqualTo: uid).getDocuments(){(querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        let data = querySnapshot!.documents[0].data()
                        let username = (data["username"] ?? "") as! String
                        let starredUsers = (data["starredUsers"] ?? []) as! [String]
                        
                        UserService.shared.user = User(uid: uid, username: username, starredUsers: starredUsers)
                        completion()
                    }
                }
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
