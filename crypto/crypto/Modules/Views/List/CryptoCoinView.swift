//
//  CryptoCoinView.swift
//  crypto
//
//  Created by Mark Christian Buot on 23/12/22.
//

import SwiftUI
import CryptoSDK

struct CryptoCoinView: View {
    var coin: Coin
    
    var body: some View {
        HStack {
            ImageView(url: coin.icon)
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(coin.base)
                            .font(Fonts.header)
                            .minimumScaleFactor(0.5)
                        Text(coin.name)
                            .lineLimit(2)
                            .font(Fonts.subHeader)
                            .minimumScaleFactor(0.7)
                            .foregroundColor(Colors.subtitleGray)
                    }.frame(width: (UIScreen.main.bounds.width / 3) - 30, alignment: .leading)
                    
                    VStack {
                        HStack {
                            Text(String(coin.buyPrice)).font(Fonts.description)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                                .frame(width: (UIScreen.main.bounds.width / 3) - 16 , alignment: .trailing)
                            Text(String(coin.sellPrice)).font(Fonts.description)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                                .frame(width: (UIScreen.main.bounds.width / 3) - 46, alignment: .trailing)
                        }
                    }
                }
            }
        }
    }
    
    var column: some View {
        VStack {
            HStack {
                Text(String(coin.buyPrice)).font(Fonts.description)
            }
        }
        
    }
}

#if DEBUG
struct CryptoCoinView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoCoinView(coin: Coin(base: "Test",
                                  counter: "Test",
                                  buyPrice: "2.092383838",
                                  sellPrice: "3.092383838",
                                  icon: "https://cdn.coinhako.com/assets/wallet-ldo-e169d4a9e68cca676d55fc3f669df92ea319c2b26d7e44e51d899fe47711310c.png",
                                  name: "Testing coin"))
    }
}
#endif
