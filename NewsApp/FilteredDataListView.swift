//
//  FilteredDataListView.swift
//  NewsApp
//
//  Created by Neha Kukreja on 01/09/24.
//

import SwiftUI

struct FilteredDataListView: View {
    
    var filteredData: [Sources]
    @Environment(\.presentationMode) var presentationMode
    @State var selectedFilterCategory: String
    @State var isGridView: Bool
    
    var body: some View {
        VStack {
            HeaderViewOnFilterApplied(title: selectedFilterCategory, onBack: { presentationMode.wrappedValue.dismiss() }, onToggleView: {
                isGridView.toggle()
                let displayType = isGridView ? DisplayType.grid.rawValue : DisplayType.list.rawValue
                UserDefaults.standard.setValue(displayType, forKey: "Display_type")
            }, isGridLayout: true)
            if isGridView {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(filteredData, id: \.id) { headline in
                            NewsGridView(newsHeading: headline.name ?? "", newsDescription: headline.description ?? "", webViewURL: headline.url ?? "")
                        }
                        .padding(.all, 5)
                    }
                    .padding(.all, 15)
                }
                .scrollIndicators(.hidden)
            } else {
                ScrollView {
                    ForEach(filteredData, id: \.id) { headline in
                        NewsListView(newsHeading: headline.name ?? "", newsDescription: headline.description ?? "", webViewURL: headline.url ?? "")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .listRowInsets(EdgeInsets())
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

//#Preview {
////    FilteredDataListView()
//}
