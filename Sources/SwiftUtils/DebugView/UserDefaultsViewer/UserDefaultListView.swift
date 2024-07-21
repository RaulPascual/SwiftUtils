//
//  UserDefaultListView.swift
//
//
//  Created by Raul on 21/7/24.
//

import SwiftUI

public struct UserDefaultListView: View {
    @State var viewModel = UserDefaultListViewModel()
    
    public var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("You can swipe from the right of the list item to remove it.")
                Text("If it is not removed, it is native from the system.")
            }
            .font(.footnote)
            .foregroundStyle(.gray)
            .padding(.horizontal)
            
            HStack {
                TextField(text: $viewModel.keyText,
                          prompt: Text("Key")) {
                    Text("Key")
                }
                          .padding(.all, 2)
                          .border(.cyan)
                
                TextField(text: $viewModel.valueText,
                          prompt: Text("Value")) {
                    Text("Value")
                }
                          .padding(.all, 2)
                          .border(.cyan)
                
                Button {
                    self.viewModel.addUserDefaultsValue(forKey: viewModel.keyText,
                                              value: viewModel.valueText)
                } label: {
                    Text("Add value")
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
                                self.viewModel.removeUserDefaultsValue(forKey: key)
                                self.viewModel.userDefaults = self.viewModel.getAllUserDefaultsValues()
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
        .onAppear {
            self.viewModel.userDefaults = self.viewModel.getAllUserDefaultsValues()
        }
    }
}

#Preview {
    UserDefaultListView()
}

