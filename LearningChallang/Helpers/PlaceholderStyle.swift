//
//  PlaceholderStyle.swift
//  Learning
//
//  Created by May Bader Alotaibi on 25/04/1446 AH.
//

import SwiftUI

struct PlaceholderStyle: ViewModifier {
    var showPlaceholder: Bool
    var placeholder: String

    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if showPlaceholder {
                Text(placeholder)
                    .foregroundColor(.gray2)
            }
            content
                .foregroundColor(.white)
        }
    }
}

