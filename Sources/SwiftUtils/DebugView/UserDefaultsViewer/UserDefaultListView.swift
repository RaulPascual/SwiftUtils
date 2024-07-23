//
//  UserDefaultListView.swift
//
//
//  Created by Raul on 21/7/24.
//

import SwiftUI

struct UserDefaultListView: View {
    @StateObject var viewModel = UserDefaultListViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("You can swipe from the right of the list item to remove it.")
                Text("If it is not removed, it is native from the system.")
            }
            .font(.footnote)
            .foregroundStyle(.gray)
            .padding(.horizontal)
            
            HStack {
                TextField("Key", text: $viewModel.keyText)
                    .padding(.all, 2)
                    .border(.cyan)
                
                TextField("Value", text: $viewModel.valueText)
                    .padding(.all, 2)
                    .border(.cyan)
                
                Button("Add value") {
                    viewModel.addUserDefaultsValue(forKey: viewModel.keyText, value: viewModel.valueText)
                }
            }
            .padding(.horizontal)
            
            List {
                ForEach(viewModel.filteredUserDefaultsValues.keys.sorted(), id: \.self) { key in
                    if let value = viewModel.userDefaults[key] {
                        HStack {
                            Text(key).bold()
                            Spacer()
                            Text("\(String(describing: value))")
                        }
                        .swipeActions {
                            Button("Remove key") {
                                viewModel.removeUserDefaultsValue(forKey: key)
                            }
                            .tint(.red)
                        }
                    }
                }
            }
            .searchable(text: $viewModel.filterText, prompt: "Filter by key")
            .navigationTitle("User Defaults")
            .toolbarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    UserDefaultListView()
}
