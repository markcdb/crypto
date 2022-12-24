//
//  CryptoBuilder.swift
//  crypto
//
//  Created by Mark Christian Buot on 22/12/22.
//

import Foundation

public class CryptoBuilder {
    @MainActor public static func assemlbleViewmodelWithRequestor(_ requestor: Requestor = NetworkManager()) -> CryptoViewmodel {
        let service = CryptoService(requestor: requestor)
        let repository = CryptoRepository(cryptoService: service)
        let viewModel = CryptoViewmodel(cryptoRepository: repository)
        repository.delegate = viewModel
        return viewModel
    }
}
