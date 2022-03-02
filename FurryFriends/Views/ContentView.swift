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
    
    @State var currentImageAddedToFavourites: Bool = false
    
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
                    if currentImageAddedToFavourites == false {
                        favourites.append(currentImage)
                        currentImageAddedToFavourites = true
                    }
                }
                .foregroundColor(currentImageAddedToFavourites == true ? .red : .secondary)
            
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
            
            List(favourites, id: \.self) { currentImage in
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
            
            currentImageAddedToFavourites = false
        } catch {
            print("Could not retrieve or decode the JSON from endpoint.")
            
            print(error)
        }
    }
    
    func persistFavourites() {
        let filename = getDocumentsDirectory().appendingPathComponent(savedFavouritesLabel)
        
        do {
            let encoder = JSONEncoder()

            encoder.outputFormatting = .prettyPrinted
            
            let data = try encoder.encode(favourites)
            
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            
            print("Saved data to documents directory successfully.")
            print("===")
            print(String(data: data, encoding: .utf8)!)
        } catch {
            print(error.localizedDescription)
            
            print("Unable to write list of favourites to documents directory in app bundle on device.")
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
