//
//  NewsGridView.swift
//  NewsApp
//
//  Created by Neha Kukreja on 31/08/24.
//

import SwiftUI

struct GridView: View {
    var topHeadlines: [Sources]
    @Binding var selectedItems: [DropdownItem]
    
    var body: some View {
        GeometryReader { geometry in
            let itemWidth = (geometry.size.width / 2) - 20
            VStack {
                ScrollView{
                    if !selectedItems.isEmpty {
                        ForEach(selectedItems, id: \.title) { category in
                            let categoryTitle = category.title
                            Section(header: CustomSectionHeader(title: categoryTitle,
                                                                destination: FilteredDataListView(filteredData: (topHeadlines.filter { $0.category == categoryTitle }),
                                                                                                  selectedFilterCategory: categoryTitle, isGridView: true))
                                .listRowInsets(EdgeInsets())) {
                                    
                                    ScrollView(.horizontal) {
                                        LazyHGrid(rows: [GridItem(.fixed(itemWidth))], spacing: 20) {
                                            ForEach(topHeadlines.filter { $0.category == categoryTitle }, id: \.id) { headline in
                                                NewsGridView(
                                                    newsHeading: headline.name ?? "",
                                                    newsDescription: headline.description ?? "",
                                                    webViewURL: headline.url ?? ""
                                                )
//                                                .frame(width: itemWidth, height: 250)
                                            }
                                        }
                                        .scrollIndicators(.never)
                                    }
                                }
                        }
                    } else {
                        ForEach(topHeadlines, id: \.id) { headline in
                            NewsGridView(
                                newsHeading: headline.name ?? "",
                                newsDescription: headline.description ?? "",
                                webViewURL: headline.url ?? ""
                            )
//                            .frame(width: itemWidth)
                        }
                    }
                }
                .padding()
            }
            
        }
    }
}


struct NewsGridView: View {
    
    @State var newsHeading: String
    @State var newsDescription: String
    @State var webViewURL: String
    @State private var showingSheet = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Image("placeholderImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: 80)
                .background(Color.orange)
            Text(newsHeading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontWeight(.bold)
                .lineLimit(1)
                .padding(.all, 2)
            Text(newsDescription)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(4)
                .padding(.all, 2)
        }
//        .frame(height: 320)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black, lineWidth: 1)
        )
        .onTapGesture {
            showingSheet = true
        }
        .sheet(isPresented: $showingSheet) {
            WebViewDetailScreen(url: webViewURL)
        }
    }
}

//#Preview {
//    NewsGridView()
//}
