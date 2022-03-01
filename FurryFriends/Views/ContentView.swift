//
//  ContentView.swift
//  FurryFriends
//
//  Created by Russell Gordon on 2022-02-26.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Stored properties
    
    // Address for main image
    // Starts as a transparent pixel – until an address for an animal's image is set
    
    @State var currentImage: DogImage = DogImage(message: "https://www.russellgordon.ca/lcs/miscellaneous/transparent-pixel.png", status: "")
    
    @State var inputNotes: String = ""
    
    @State var favourites: [DogImage] = []
    
    // MARK: Computed properties
    var body: some View {
        
        VStack {
            
            // Shows the main image
            RemoteImageView(fromURL: URL(string: currentImage.message)!)
            
            TextField("Notes", text: $inputNotes, prompt: Text("Enter your notes here"))
            
            Image(systemName: "heart.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .onTapGesture {
                    favourites.append(currentImage)
                }
            
            Button(action: {
                print("Button was pressed")
                
                Task {
                    await loadNewImage()
                }
                
            }, label: {
                Text("Another one!")
            })
                .buttonStyle(.bordered)
            
            HStack {
                Text("Favourites")
                    .bold()
                    .font(.title)
                
                Spacer()
            }
            
            List(favourites) { currentImage in
                RemoteImageView(fromURL: URL(string: currentImage.message)!)
            }
            
            // Push main image to top of screen
            Spacer()
            

        }
        // Runs once when the app is opened
        .task {
            await loadNewImage()
            
            print("Have just attempted to load a new image.")
        }
        .navigationTitle("Furry Friends")
        .padding()
        
    }
    
    // MARK: Functions
    func loadNewImage() async {
        let remoteDogImage = URL(string: "https://dog.ceo/api/breeds/image/random")!
        
        var request = URLRequest(url: remoteDogImage)
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let urlSession = URLSession.shared
        
        do {
            let (data, _) = try await urlSession.data(for: request)
            
            currentImage = try JSONDecoder().decode(DogImage.self, from: data)
        } catch {
            print("Could not retrieve or decode the JSON from endpoint.")
            
            print(error)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
