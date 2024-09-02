//
//  FilterButtonWithExpandView.swift
//  NewsApp
//
//  Created by Neha Kukreja on 31/08/24.
//

import SwiftUI

struct DropdownItem: Identifiable, Hashable {
    let id: String
    var title: String
}

struct MultiSelectDropdown: View {
    @Binding var selectedItems: [DropdownItem]
    @Binding var isExpanded: Bool
    let items: [DropdownItem]
    
    private var selectedItemsText: String {
        let selectedTitles = selectedItems.map { $0.title }
        return selectedTitles.isEmpty ? "Filter By Categories" : selectedTitles.joined(separator: ", ")
    }
    
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation(.easeInOut) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(selectedItemsText)
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .foregroundColor(.black)
                }
                .padding()
                .background(Color.white)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            }
            
            if isExpanded {
                VStack(alignment: .leading) {
                    ForEach(items) { item in
                        Button(action: {
                            if selectedItems.contains(where: { $0.id == item.id }) {
                                selectedItems.removeAll { $0.id == item.id }
                            } else {
                                selectedItems.append(item)
                            }
                        }) {
                            HStack {
                                Text(item.title)
                                    .padding()
                                Spacer()
                                if selectedItems.contains(where: { $0.id == item.id }) {
                                    Image(systemName: "checkmark")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(.blue)
                                        .padding()
                                }
                            }.frame(maxWidth: .infinity)
                                .border(Color.black, width: 0.5)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(maxWidth: .infinity)
                    }
                }
                .background(Color.white)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.1))
    }
}

struct FilterButtonWithExpandView: View {
    @Binding var selectedItems: [DropdownItem]
    @Binding var categoriesList: [DropdownItem]
    @Binding var isExpanded: Bool
    @State private var isGridLayout: Bool = true
    var onFilterChanged: () -> Void
    var onToggleLayout: () -> Void
    
    var body: some View {
        HStack {
            VStack {
                let items = categoriesList
                MultiSelectDropdown(selectedItems: $selectedItems, isExpanded: $isExpanded, items: items)
                    .padding()
                    .onChange(of: selectedItems) { _, _ in
                        onFilterChanged()
                    }
            }
            if !selectedItems.isEmpty && !isExpanded {
                Button(action: {
                    isGridLayout.toggle()
                    let displayType = isGridLayout ? DisplayType.grid.rawValue : DisplayType.list.rawValue
                    UserDefaults.standard.setValue(displayType, forKey: "Display_type")
                    onToggleLayout()
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
        }
    }
}

//#Preview {
//    FilterButtonWithExpandView()
//}
