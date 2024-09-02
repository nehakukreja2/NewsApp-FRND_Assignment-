//
//  NewsListView.swift
//  NewsApp
//
//  Created by Neha Kukreja on 31/08/24.
//

import SwiftUI

struct NewsListView: View {
    
    @State var newsHeading: String
    @State var newsDescription: String
    @State var webViewURL: String
    @State private var showingSheet = false
    
    var body: some View {
        HStack(spacing: 10) {
                Image("placeholderImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
            VStack(alignment: .leading) {
                Text(newsHeading)
                    .fontWeight(.bold)
                Text(newsDescription)
                    .lineLimit(2)
            }.padding()
        } .clipShape(RoundedRectangle(cornerRadius: 8))
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
