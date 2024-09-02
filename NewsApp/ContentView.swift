//
//  ContentView.swift
//  NewsApp
//
//  Created by Neha Kukreja on 31/08/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = NewsAppViewModel()
    @State private var selectedItems = [DropdownItem]()
    @State private var isGridView: Bool = false
    @State private var isExpanded: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                FilterButtonWithExpandView(selectedItems: $selectedItems,categoriesList: $viewModel.categoriesList, isExpanded: $isExpanded, onFilterChanged: {
                    if selectedItems.isEmpty {
                        viewModel.hitAPIToGetTopHeadlines()
                    } else {
                        let selectedCategories = selectedItems.map { $0.title }
                        viewModel.hitAPIToGetFilteredDataAccordingToCategory(selectedCategories: selectedCategories)
                    }
                },
                                           onToggleLayout: {
                    isGridView.toggle()
                })
                if isGridView {
                    if !selectedItems.isEmpty {
                        ForEach(selectedItems, id: \.title) { category in
                            let categoryTitle = category.title
                            let filteredData = viewModel.topHeadlines.filter { $0.category == categoryTitle }
                            
                            Section(header: CustomSectionHeader(
                                title: categoryTitle,
                                destination: FilteredDataListView(
                                    filteredData: filteredData,
                                    selectedFilterCategory: categoryTitle,
                                    isGridView: true
                                )
                            )) {
                                ScrollView {
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                                        ForEach(filteredData, id: \.id) { headline in
                                            NewsGridView(
                                                newsHeading: headline.name ?? "",
                                                newsDescription: headline.description ?? "",
                                                webViewURL: headline.url ?? ""
                                            )
                                            .padding(.all, 5)
                                        }
                                    }
                                    .padding(.all, 15)
                                }
                                .scrollIndicators(.never)
                            }
                        }
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                                ForEach(viewModel.topHeadlines, id: \.id) { headline in
                                    NewsGridView(
                                        newsHeading: headline.name ?? "",
                                        newsDescription: headline.description ?? "",
                                        webViewURL: headline.url ?? ""
                                    )
                                    .padding(.all, 5)
                                }
                            }
                            .padding(.all, 15)
                            .scrollIndicators(.never)
                        }
                    }
                } else {
                    List {
                        if !selectedItems.isEmpty {
                            ForEach(selectedItems, id: \.title) { category in
                                let categoryTitle = category.title
                                let filteredData = viewModel.topHeadlines.filter { $0.category == categoryTitle }
                                
                                Section(header: CustomSectionHeader(
                                    title: categoryTitle,
                                    destination: FilteredDataListView(
                                        filteredData: filteredData,
                                        selectedFilterCategory: categoryTitle,
                                        isGridView: true
                                    )
                                )) {
                                    ForEach(viewModel.topHeadlines, id: \.id) { headline in
                                        NewsListView(
                                            newsHeading: headline.name ?? "",
                                            newsDescription: headline.description ?? "",
                                            webViewURL: headline.url ?? ""
                                        )
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .listRowInsets(EdgeInsets())
                                    }
                                }
                            }
                        } else {
                            ForEach(viewModel.topHeadlines, id: \.id) { headline in
                                NewsListView(
                                    newsHeading: headline.name ?? "",
                                    newsDescription: headline.description ?? "",
                                    webViewURL: headline.url ?? ""
                                )
                                .frame(maxWidth: .infinity)
                                .padding()
                                .listRowInsets(EdgeInsets())
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .onAppear {
                viewModel.hitAPIToGetTopHeadlines()
                selectedItems.removeAll()
                let savedDisplayType = UserDefaults.standard.string(forKey: "Display_type") ?? DisplayType.grid.rawValue
                isGridView = savedDisplayType == DisplayType.grid.rawValue
            }
            .navigationTitle("News")
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
