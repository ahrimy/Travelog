//
//  Section.swift
//  Travelog
//
//  Created by 강예나 on 2021/04/06.
//

import Foundation

struct Section : Decodable, Hashable {
    let id: Int
    let type: String
    let items: [StarredList]
}
