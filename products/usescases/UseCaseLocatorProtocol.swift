//
//  UseCaseLocatorProtocol.swift
//  products
//
//  Created by effit on 3/20/20.
//  Copyright © 2020 liverpool. All rights reserved.
//

import Foundation

protocol UseCaseLocatorProtocol {
    func getUseCase<T>(ofType type: T.Type) -> T?
}

class UseCaseLocator : UseCaseLocatorProtocol {
    static let defaultLocator = UseCaseLocator(
                                               service: ServiceImp())
    fileprivate let service: ServiceProtocol
    init( service: ServiceProtocol) {
        self.service = service
    }
    
    func getUseCase<T>(ofType type: T.Type) -> T? {
        switch String(describing: type) {
        case String(describing: SearchProtocol.self):
            return buildUseCase(type: SearchUseCaseImpl.self)
        default:
            return nil
        }
    }
}

private extension UseCaseLocator {
    func buildUseCase<U: UseCaseImpl, R>(type: U.Type) -> R? {
        return U(service: service) as? R
    }
}
