//
//  File.swift
//  
//
//  Created by Raul on 2/7/24.
//

import SwiftUI

public enum LoaderType {
    case circularProgress
    case dots
    case pulsingCircle
    case custom(() -> AnyView)
}
