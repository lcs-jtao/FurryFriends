//
//  FavouriteListView.swift
//  FurryFriends
//
//  Created by Joyce Tao on 2022-03-02.
//

import SwiftUI

struct FavouriteListView: View {
    
    let imageURL: URL
    let note: String
    
    var body: some View {
        VStack {
            RemoteImageView(fromURL: imageURL)
            
            HStack {
                Text("Your note for this image:")
                        .bold()
                        .italic()
                
                Text(note)
                
                Spacer()
            }
            Spacer()
        }
        .padding()
    }
}

struct FavouriteListView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteListView(imageURL: URL(string: "https://picsum.photos/640/360")!, note: "Hi")
    }
}
