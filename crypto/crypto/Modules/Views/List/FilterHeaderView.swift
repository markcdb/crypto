//
//  FilterHeaderView.swift
//  crypto
//
//  Created by Mark Christian Buot on 24/12/22.
//

import SwiftUI

struct FilterHeaderView: View {
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: -3))
            Image("down-chevron")
                .resizable()
                .frame(width: 8, height: 8, alignment: .leading)
        }
    }
}

struct FilterHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        FilterHeaderView(title: "Hello")
    }
}
