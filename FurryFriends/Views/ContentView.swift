//
//  ContentView.swift
//  FurryFriends
//
//  Created by Russell Gordon on 2022-02-26.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Stored properties
    @Environment(\.scenePhase) var scenePhase
    
    // Address for main image
    // Starts as a transparent pixel – until an address for an animal's image is set
    @State var currentImage: DogImage = DogImage(message: "https://images.dog.ceo/breeds/keeshond/n02112350_9886.jpg", status: "")
    
    @State var inputNotes: String = ""
    
    @State var favourites: [DogImage] = []
    
    @State var favouriteImages: [FavouriteImage] = []
    
    @State var currentImageAddedToFavourites: Bool = false
    
    @State var initialAppLoadingCompleted: Bool = false
    
    @State var numberOfImages = 1
    
    @State var numberOfFavourites = 0
    
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
                        favouriteImages.append(FavouriteImage(url: URL(string: currentImage.message)!, note: inputNotes))
                        currentImageAddedToFavourites = true
                        numberOfFavourites += 1
                    }
                }
                .foregroundColor(currentImageAddedToFavourites == true ? .red : .secondary)
            
            Button(action: {
                print("Button was pressed")
                
                inputNotes = ""
                
                Task {
                    await loadNewImage()
                }
                
                numberOfImages += 1
                
            }, label: {
                Text("Another one!")
            })
                .buttonStyle(.bordered)
            
            HStack {
                Text("Favourites (\(numberOfFavourites)/\(numberOfImages))")
                    .bold()
                    .font(.title)
                
                Spacer()
            }
            
            List(favouriteImages, id: \.self) { currentFavouriteImage in
                NavigationLink(destination: DetailPageView(imageURL: currentFavouriteImage.url, note: currentFavouriteImage.note)) {
                    HStack {
                        RemoteImageView(fromURL: currentFavouriteImage.url)
                            .frame(width: 50, height: 50, alignment: .center)
                            .clipped()
                        
                        Spacer()
                    }
                }
            }
            
            // Push main image to top of screen
            Spacer()
            

        }
        
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .inactive {
                print("Inactive")
            } else if newPhase == .active {
                print("Active")
            } else if newPhase == .background {
                print("Background")
                
                persistFavourites()
                persistFavouriteImages()
            }
        }
        
        // Runs once when the app is opened
        .task {
            initialAppLoadingCompleted = true
            
            if initialAppLoadingCompleted == false {
                await loadNewImage()
            }
            
            print("Have just attempted to load a new image.")
            
            loadFavourites()
            loadFavouriteImages()
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
    
    // Functions for storing/loading data from the "favourites" list to/from the device storage
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
    
    func loadFavourites() {
        let filename = getDocumentsDirectory().appendingPathComponent(savedFavouritesLabel)
        
        print(filename)
                
        do {
            let data = try Data(contentsOf: filename)
            
            print("Got data from file, contents are:")
            print(String(data: data, encoding: .utf8)!)

            favourites = try JSONDecoder().decode([DogImage].self, from: data)
        } catch {
            print(error.localizedDescription)
            
            print("Could not load data from file, initializing with tasks provided to initializer.")
        }
    }
    
    // Functions for storing/loading data from the "favouriteImages" list to/from the device storage
    func persistFavouriteImages() {
        let filename = getDocumentsDirectory().appendingPathComponent(savedFavouriteImageLabel)
        
        do {
            let encoder = JSONEncoder()

            encoder.outputFormatting = .prettyPrinted
            
            let data = try encoder.encode(favouriteImages)
            
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            
            print("Saved data to documents directory successfully.")
            print("===")
            print(String(data: data, encoding: .utf8)!)
        } catch {
            print(error.localizedDescription)
            
            print("Unable to write list of favourites to documents directory in app bundle on device.")
        }
    }
    
    func loadFavouriteImages() {
        let filename = getDocumentsDirectory().appendingPathComponent(savedFavouriteImageLabel)
        
        print(filename)
                
        do {
            let data = try Data(contentsOf: filename)
            
            print("Got data from file, contents are:")
            print(String(data: data, encoding: .utf8)!)

            favouriteImages = try JSONDecoder().decode([FavouriteImage].self, from: data)
        } catch {
            print(error.localizedDescription)
            
            print("Could not load data from file, initializing with tasks provided to initializer.")
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
