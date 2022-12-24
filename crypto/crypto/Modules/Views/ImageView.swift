//
//  ImageView.swift
//  crypto
//
//  Created by Mark Christian Buot on 23/12/22.
//

import CryptoSDK
import SwiftUI
import UIKit

struct ImageView: View {
    let url: String
    @State private var isLoading = true

    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: url),
                       content: { image in
                        image.resizable()
                    }, placeholder: {
                        ProgressView()
                            .padding()
                            .background(Colors.gray)
                    })
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(url: "s")
    }
}
