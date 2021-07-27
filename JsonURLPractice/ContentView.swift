//
//  ContentView.swift
//  JsonURLPractice
//
//  Created by Promal on 28/7/21.
//

import SwiftUI
// Data stucture as per Json data
struct Response: Codable{
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}


struct ContentView: View {
    @State var results = [Result]()
    
    
    var body: some View {
        List(results, id: \.trackId){ item in
            VStack(alignment: .leading){
                Text(item.trackName).font(.headline)
                Text(item.collectionName)
            }
        }.onAppear(perform: loadData)
    }
    
    // Function to load data from URL
    func loadData(){
        guard  let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else{
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request){ data, response, error in
            if let data = data{
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data){
                    DispatchQueue.main.async{
                        self.results = decodedResponse.results
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown Error")")
        }.resume()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
