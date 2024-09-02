//
//  HeaderViewOnFilterApplied.swift
//  NewsApp
//
//  Created by Neha Kukreja on 02/09/24.
//

import SwiftUI

import SwiftUI

struct HeaderViewOnFilterApplied: View {
    var title: String
    var onBack: () -> Void
    var onToggleView: () -> Void
    @State var isGridLayout: Bool

    var body: some View {
        HStack {
            // Back button
            Button(action: {
                onBack()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)
            }
            .padding(.leading, 10)
            
            // Title
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
            
            // Toggle Grid/List View Button
            Button(action: {
                isGridLayout.toggle()
                let displayType = isGridLayout ? DisplayType.grid.rawValue : DisplayType.list.rawValue
                UserDefaults.standard.setValue(displayType, forKey: "Display_type")
                onToggleView()
            }) {
                Image(systemName: !isGridLayout ? "square.grid.2x2" : "line.horizontal.3")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 10)
            }
            .padding()
            .onAppear {
                let savedDisplayType = UserDefaults.standard.string(forKey: "Display_type") ?? DisplayType.grid.rawValue
                isGridLayout = savedDisplayType == DisplayType.grid.rawValue
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 40)
        .padding(.vertical, 10)
        .background(Color.white)
    }
}

//struct CustomHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        HeaderViewOnFilterApplied(title: "Business", onBack: {}, onToggleView: {})
//            .previewLayout(.sizeThatFits)
//    }
//}
