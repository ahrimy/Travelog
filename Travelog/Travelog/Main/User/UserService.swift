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
    
    private init(){
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
                    let document = querySnapshot!.documents[0]
                    let data = document.data()
                    let username = (data["username"] ?? "") as! String
                    let starredUsers = (data["starredUsers"] ?? []) as! [String]
                    
                    UserService.shared.user = User(id: document.documentID, uid: authUser.uid, username: username, starredUsers: starredUsers)
                    AttractionService.shared.loadAttractions()
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
                        let document = querySnapshot!.documents[0]
                        let data = document.data()
                        let username = (data["username"] ?? "") as! String
                        let starredUsers = (data["starredUsers"] ?? []) as! [String]
                        
                        UserService.shared.user = User(id: document.documentID,uid: uid, username: username, starredUsers: starredUsers)
                        AttractionService.shared.loadAttractions()
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
    func checkUsernameDuplicate(username:String, completion: @escaping(_ isExist:Bool)->Void){
        db.collection("users").whereField("username", isEqualTo: username).getDocuments{(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }else {
                completion((querySnapshot?.count ?? 0) > 0)
            }
            
        }
    }
    func singUp(data:[String: String], completion: @escaping()->Void){
        guard let email = data["email"] else {return}
        guard let password = data["password"] else {return}
        guard let username = data["username"] else {return}
        auth.createUser(withEmail: email, password: password) { authResult, err in
            guard let user = authResult?.user, err == nil else {
                print(err!.localizedDescription)
                return
            }
            var documentRef: DocumentReference? = nil
            documentRef = self.db.collection("users").addDocument(data: [
                "uid": user.uid,
                "username": username,
                "starredUsers": []
            ]){ err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    UserService.shared.user = User(id: documentRef!.documentID,uid: user.uid, username: username, starredUsers: [])
                    completion()
                }
            }
        }
    }
}
