//
//  User.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/05/20.
//

import Foundation
import UIKit

class User{
    
    init(uid:String = "",
         username:String = "",
         starredUsers:[String] = []){
        self.uid = uid
        self.username = username
        self.starredUsers = starredUsers
    }
    
    let uid:String
    var username:String
    var starredUsers: [String]
}
