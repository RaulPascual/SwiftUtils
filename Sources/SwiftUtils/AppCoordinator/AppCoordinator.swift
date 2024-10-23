//
//  File.swift
//  
//
//  Created by Raul on 17/7/24.
//

import SwiftUI

/**
 A class responsible for coordinating the state and navigation of the application.

 - Parameters:
    - shared: A singleton instance of `AppCoordinator`.
    - showDebug: A boolean value indicating whether the debug view is shown.
    - selectedModule: The currently selected module in the application, represented by an `AppModule` value.
    - isDebugViewActive: A boolean value indicating whether the debug view is active.

 - Initialization:
    - `init(showDebug:selectedModule:isDebugViewActive:)`: Initializes an instance of `AppCoordinator` with optional parameters to set initial values.

 - Methods:
    - `showDebugView()`: Toggles the `showDebug` property.
    - `setModule(_:animation:)`: Sets the `selectedModule` property with an optional animation.

 - Note: This class conforms to `ObservableObject` to allow SwiftUI views to observe its properties.
 */
public class AppCoordinator: ObservableObject {
    @MainActor public static let shared = AppCoordinator()
    var showDebug = false
    @Published var selectedModule = AppModule.home
    @Published var isDebugViewActive = false
    
    public init(showDebug: Bool = false, selectedModule: AppModule = AppModule.home, isDebugViewActive: Bool = false) {
        self.showDebug = showDebug
        self.selectedModule = selectedModule
        self.isDebugViewActive = isDebugViewActive
    }
    
    func showDebugView() {
        self.showDebug.toggle()
    }
    
    func setModule(_ module: AppModule, animation: Animation? = .easeInOut(duration: 0.3)) {
        withAnimation(animation) {
            selectedModule = module
        }
    }
}

public enum AppModule {
    case home
}

public protocol AppModuleView: View {
    associatedtype Content: View
    var body: Content { get }
}
