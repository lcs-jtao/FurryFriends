//
//  DogImage.swift
//  FurryFriends
//
//  Created by Joyce Tao on 2022-03-01.
//

import Foundation

struct DogImage: Decodable, Hashable {
    let id = UUID()
    let message: String
    let status: String
}
