//
//  File.swift
//  
//
//  Created by Raul on 17/7/24.
//

import SwiftUI

/**
 A root view that displays different modules of the application based on the selected module in `AppCoordinator`.

 - Parameters:
    - Content: A type conforming to `AppModuleView`.
    - viewRouter: An `AppCoordinator` environment object that handles the state and navigation of the application.
    - homeView: The view to be displayed for the home module.

 - Initialization:
    - `init(homeView:)`: Initializes an instance of `RootView` with the provided home view.

 - Body:
    - The body of the view dynamically switches between different modules based on the selected module in `AppCoordinator`.
    - If the debug view is active, it presents a sheet with a `DebugView` wrapped in a `NavigationStack`.

 - Methods:
    - `getRootView(module:)`: A private method that returns the appropriate view based on the selected module.

 - Note: This struct requires an `AppCoordinator` environment object and a home view conforming to `AppModuleView`.
 */
public struct RootView<Content: AppModuleView>: View {
    @EnvironmentObject var viewRouter: AppCoordinator
    let homeView: Content
    
    public init(homeView: Content) {
        self.homeView = homeView
    }
    
    public var body: some View {
        getRootView(module: viewRouter.selectedModule)
            .sheet(isPresented: $viewRouter.isDebugViewActive) {
                NavigationStack {
                    DebugView()
                }
            }
    }
    
    @ViewBuilder func getRootView(module: AppModule) -> some View {
        switch module {
        case .home:
            homeView
                .environmentObject(viewRouter)
        }
    }
}
