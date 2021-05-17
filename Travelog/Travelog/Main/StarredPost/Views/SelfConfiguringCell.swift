//
//  SelfConfiguringCell.swift
//  Travelog
//
//  Created by 강예나 on 2021/04/07.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(with starredpostlist: PostOverview)
}
