//
//  CategoryButton.swift
//  NC2
//
//  Created by Evelin Evelin on 19/07/22.
//

import SwiftUI

struct CategoryButton: View {
    let categoryName: String
    let color: Color

    var body: some View {
        Button {
            
        } label: {
            Text(categoryName)
                .foregroundColor(.white)
                .fontWeight(.semibold)
                .padding()
                .frame(width: 165)
                .background(
                    color
                        .cornerRadius(10)
                )
        }

    }
}

struct button: PreviewProvider {
    static var previews: some View {
        CategoryButton(categoryName: "Important - Urgent", color: .black)
    }
}
