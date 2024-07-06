//
//  SwiftUIView.swift
//
//
//  Created by Raul on 6/7/24.
//

import SwiftUI
/**
 A view representing a single tag.

 - Parameters:
    - tag: A binding to a `TagModel` object representing the tag to be displayed.
 */
public struct TagView: View {
    @Binding var tag: TagModel
    
    public init(tag: Binding<TagModel>) {
        self._tag = tag
    }
    
    public var body: some View {
        HStack {
            Text(tag.text)
            if tag.isSelected {
                Button(action: {
                    tag.isSelected = false
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                })
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(tag.isSelected ? tag.color.opacity(0.7) : tag.color)
        .foregroundColor(.white)
        .cornerRadius(8)
        .onTapGesture {
            tag.isSelected.toggle()
        }
    }
}

struct ExampleTagView: View {
    @State var tag = TagModel(text: "Filter 1",
                              color: .green,
                              isSelected: true)
    var body: some View {
        TagView(tag: $tag)
    }
}

#Preview {
    ExampleTagView()
}
