//
//  NewsAppViewModel.swift
//  NewsApp
//
//  Created by Neha Kukreja on 31/08/24.
//

import Foundation

class NewsAppViewModel: ObservableObject {
    
    @Published var newsArticles: [Articles] = []
    @Published var topHeadlines: [Sources] = []
    var categoriesList: [DropdownItem] = []
    let networkManager = NetworkManager()
    
    func hitAPIToGetNews() {
        networkManager.get(endpoint: "everything?q=bitcoin&apiKey=\(networkManager.getApiKey())", responseType: News.self) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.newsArticles = response.articles ?? [Articles]()
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func hitAPIToGetTopHeadlines() {
        networkManager.get(endpoint: "top-headlines/sources?apiKey=\(networkManager.getApiKey())", responseType: TopHeadlines.self) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let sources = response.sources {
                        self.topHeadlines = sources
                        let categoryToIdMap = Dictionary(grouping: sources, by: { $0.category }).compactMapValues { sources in
                            sources.first?.id
                        }
                        
                        self.categoriesList = categoryToIdMap.map { category, id in
                            DropdownItem(id: id, title: category ?? "")
                        }
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func hitAPIToGetFilteredDataAccordingToCategory(selectedCategories: [String]) {
        self.topHeadlines.removeAll()
        
        // Create a dispatch group to manage the asynchronous requests
        let dispatchGroup = DispatchGroup()
        
        // Loop through each selected category
        for category in selectedCategories {
            dispatchGroup.enter() // Enter the group before starting the network request
            
            // Make the network request for each category
            networkManager.get(endpoint: "top-headlines/sources?category=\(category)&apiKey=\(networkManager.getApiKey())", responseType: TopHeadlines.self) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        if let sources = response.sources {
                            // Append the new headlines to the existing list
                            self.topHeadlines.append(contentsOf: sources)
                        }
                    }
                case .failure(let error):
                    print("Error fetching category \(category): \(error)")
                }
                
                dispatchGroup.leave() // Leave the group after the request completes
            }
        }
        
        // Notify when all requests are completed
        dispatchGroup.notify(queue: .main) {
            // Update the UI or handle any final processing
            print("All category requests completed")
        }
    }
}
