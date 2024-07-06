//
//  SwiftUIView.swift
//
//
//  Created by Raul on 6/7/24.
//

import SwiftUI

public struct TagsListView: View {
    @Binding var tags: [TagModel]
    
    public init(tags: Binding<[TagModel]>) {
        self._tags = tags
    }
    
    public var body: some View {
        let columns = [GridItem(.adaptive(minimum: 90))]
        
        ScrollView {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
                ForEach($tags) { $tag in
                    TagView(tag: $tag)
                }
            }
            .padding()
        }
    }
}

struct ExampleTagsListView: View {
    @State var tags: [TagModel] = [TagModel(text: "Filter 1",color: .blue),
                                   TagModel(text: "Filter 2", color: .purple),
                                   TagModel(text: "Filter 3", color: .purple),
                                   TagModel(text: "Filter 4", color: .purple),
                                   TagModel(text: "Filter 5", color: .purple),
                                   TagModel(text: "Filter 6", color: .purple),
                                   TagModel(text: "Filter 7", color: .purple),
                                   TagModel(text: "Filter 8", color: .purple)]
    var body: some View {
        TagsListView(tags: $tags)
    }
}

#Preview {
    ExampleTagsListView()
}
