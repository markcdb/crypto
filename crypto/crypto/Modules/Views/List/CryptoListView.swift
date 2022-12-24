//
//  CryptoListView.swift
//  crypto
//
//  Created by Mark Christian Buot on 21/12/22.
//

import CryptoSDK
import SwiftUI
import UIKit

struct CryptoListView: View {
    @ObservedObject var viewModel: CryptoViewmodel
    @State var isEditing: Bool = false
    
    var body: some View {
        NavigationView {
            VStack{
                Picker("", selection: $viewModel.currency) {
                    ForEach(Countries.shared.countries, id: \.currencyCode) { country in
                        Text(country.currencyCode)
                    }
                }
                .accessibilityIdentifier("picker-currency")
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.bottom)
                .onChange(of: viewModel.currency) { _ in
                    viewModel.reloadCoins()
                }.disabled($isEditing.wrappedValue)
                
                HStack {
                    let width = (UIScreen.main.bounds.width / 3)
                    FilterHeaderView(title: "Coin")
                        .frame(width: width - 16,
                               alignment: .leading)
                        .onTapGesture {
                            viewModel.filter(.name)
                    }
                    FilterHeaderView(title: "Buy")
                        .frame(width: width,
                               alignment: .trailing)
                        .onTapGesture {
                            viewModel.filter(.buy)
                    }
                    FilterHeaderView(title: "Sell")
                        .frame(width: width - 46,
                               alignment: .trailing)
                        .onTapGesture {
                            viewModel.filter(.sell)
                    }
                }
                .padding(.horizontal)
                .font(.caption)
                .foregroundColor(Colors.subtitleGray)
                
                if viewModel.searchString.isEmpty {
                    switch viewModel.state {
                    case .none:
                        ProgressView()
                    case .success(let coins), .failed(let coins):
                        List(coins, id: \.name) { coin in
                            CryptoCoinView(coin: coin)
                        }.listStyle(PlainListStyle())
                            .accessibilityIdentifier("list-coin")
                    }
                } else {
                    List($viewModel.searchedCoin, id:\.name) { coin in
                        CryptoCoinView(coin: coin.wrappedValue)
                    }.listStyle(PlainListStyle())
                        .accessibilityIdentifier("list-search")
                }
            }
            .frame(minWidth: 0,
                   maxWidth: .infinity,
                   minHeight: 0,
                   maxHeight: .infinity,
                   alignment: .topLeading)
            .onAppear {
                viewModel.startTimer()
            }
        }.searchable(text: $viewModel.searchString).onChange(of: viewModel.searchString) { newValue in
            isEditing = !newValue.isEmpty
            viewModel.search()
        }
    }
}

#if DEBUG
struct CryptoListView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoListView(viewModel: CryptoBuilder.assemlbleViewmodelWithRequestor(MockCryptoNetworkRequest()))
    }
}
#endif

