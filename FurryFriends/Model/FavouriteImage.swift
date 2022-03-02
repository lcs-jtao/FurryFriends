//
//  FavouriteImage.swift
//  FurryFriends
//
//  Created by Joyce Tao on 2022-03-02.
//

import Foundation

struct FavouriteImage: Hashable, Encodable, Decodable {
    let id = UUID()
    let url: URL
    let note: String
}
