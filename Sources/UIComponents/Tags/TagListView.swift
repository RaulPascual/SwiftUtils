//
//  SwiftUIView.swift
//
//
//  Created by Raul on 6/7/24.
//

import SwiftUI
/**
 A view displaying a list of tags.
 
 - Parameters:
 - tags: A binding to an array of `TagModel` objects representing the tags to be displayed.
 */
public struct TagsListView: View {
    @Binding var tags: [TagModel]
    
    public init(tags: Binding<[TagModel]>) {
        self._tags = tags
    }
    
    public var body: some View {
        ScrollView {
            FlowLayout {
                ForEach($tags) { $tag in
                    TagView(tag: $tag)
                        .padding(.all, 4)
                }
            }
        }
    }
}

struct ExampleTagsListView: View {
    @State var tags: [TagModel] = [TagModel(text: "Filter 1",color: .blue, isSelected: true),
                                   TagModel(text: "Filter 2", color: .blue),
                                   TagModel(text: "Filter 3", color: .blue),
                                   TagModel(text: "Filter 4", color: .blue, isSelected: true),
                                   TagModel(text: "Filter 5", color: .blue, isSelected: true),
                                   TagModel(text: "Filter 6", color: .blue),
                                   TagModel(text: "Filter 7", color: .blue),
                                   TagModel(text: "Filter 8", color: .blue)]
    var body: some View {
        TagsListView(tags: $tags)
    }
}

#Preview {
    ExampleTagsListView()
}
