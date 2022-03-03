//
//  DetailPageView.swift
//  FurryFriends
//
//  Created by Joyce Tao on 2022-03-02.
//

import SwiftUI

struct DetailPageView: View {
    
    let imageURL: URL
    let note: String
    
    var body: some View {
        VStack {
            RemoteImageView(fromURL: imageURL)
            
            HStack {
                Text("Your note for this image:")
                        .bold()
                        .italic()
                
                if note == "" {
                    Text("None")
                } else {
                    Text(note)
                }
                
                Spacer()
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Favourite Little Friend")
    }
}

struct DetailPageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailPageView(imageURL: URL(string: "https://picsum.photos/640/360")!, note: "Hi")
        }
    }
}
