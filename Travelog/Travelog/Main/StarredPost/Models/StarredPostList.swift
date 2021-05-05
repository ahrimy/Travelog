//
//  StarredPostList.swift
//  Travelog
//
//  Created by 강예나 on 2021/04/06.
//

import Foundation

struct StarredList: Decodable, Hashable {
    
    let id: Int
    let name: String
    let image: String
    let country: String
    let city: String
    let date: String
    let text: String
    
}
