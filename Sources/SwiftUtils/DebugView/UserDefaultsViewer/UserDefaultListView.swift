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
                ForEach(viewModel.userDefaults.keys.sorted(), id: \.self) { key in
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
            .navigationTitle("User Defaults")
        }
        .onAppear {
            self.viewModel.userDefaults = self.viewModel.getAllUserDefaultsValues()
        }
    }
}

#Preview {
    UserDefaultListView()
}

@Observable public class UserDefaultListViewModel {
    var userDefaults: [String: Any] = [:]
    public var keyText = ""
    var valueText = ""
    
    /**
     Retrieves all values stored in the standard `UserDefaults`.

     This function fetches all key-value pairs stored in the standard `UserDefaults` and returns them as a dictionary.

     - Returns: A dictionary containing all key-value pairs stored in the standard `UserDefaults`.
     */
    func getAllUserDefaultsValues() -> [String: Any] {
        let userDefaults = UserDefaults.standard
        return userDefaults.dictionaryRepresentation()
    }
    
    /**
     Removes a value from the standard `UserDefaults` for the specified key.

     This function removes the value associated with the given key from the standard `UserDefaults`.

     - Parameter key: The key whose value should be removed from the `UserDefaults`.
     */
    func removeUserDefaultsValue(forKey key: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: key)
    }
    
    /**
     Adds a value to the standard `UserDefaults` for the specified key.

     This function sets the value for the given key in the standard `UserDefaults` and updates the local `userDefaults` property with all the current key-value pairs.

     - Parameters:
        - key: The key with which to associate the value.
        - value: The value to store in the `UserDefaults`.
     */
    func addUserDefaultsValue(forKey key: String, value: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: key)
        self.userDefaults = self.getAllUserDefaultsValues()
    }
}
