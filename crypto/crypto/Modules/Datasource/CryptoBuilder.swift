//
//  CryptoBuilder.swift
//  crypto
//
//  Created by Mark Christian Buot on 22/12/22.
//

import Foundation

class CryptoBuilder {
    @MainActor static func assemlbleViewmodelWithRequestor(_ requestor: Requestor) -> CryptoViewmodel {
        let service = CryptoService(requestor: requestor)
        let repository = CryptoRepository(cryptoService: service)
        let viewModel = CryptoViewmodel(cryptoRepository: repository)
        repository.delegate = viewModel
        return viewModel
    }
}
