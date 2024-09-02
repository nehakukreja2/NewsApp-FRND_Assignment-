//
//  CustomSectionHeader.swift
//  NewsApp
//
//  Created by Neha Kukreja on 01/09/24.
//

import SwiftUI

struct CustomSectionHeader: View {
    @State var title: String
    var destination: FilteredDataListView
    @State private var navigate: Bool = false
    
    var body: some View {
        NavigationLink(destination: destination, isActive: $navigate) {
            HStack {
                Text(title)
                    .font(.headline)
                    .textCase(.uppercase)
                    .padding(.leading, 10)
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.headline)
            }
            .foregroundColor(.black)
            .padding(.trailing, 10)
            .onTapGesture {
                navigate = true
            }
            .padding(.vertical, 5)
            .background(Color.clear)
            .frame(maxWidth: .infinity)
        }
    }
}

//#Preview {
//    CustomSectionHeader(title: "Abc")
//}
