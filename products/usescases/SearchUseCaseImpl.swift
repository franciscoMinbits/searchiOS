//
//  SearchUseCaseImpl.swift
//  products
//
//  Created by effit on 3/20/20.
//  Copyright © 2020 liverpool. All rights reserved.
//

import Foundation

class SearchUseCaseImpl: UseCaseImpl, SearchProtocol {
    func addHistorySearch(history: HistoryEntitie) {
        service.addHistorySearch(history: history)
    }
    
    func getHistory() -> [HistoryEntitie] {
        service.getHistory()
    }
    
    
    func searchProducts(search: String, page: Int, itemsPerPage: Int,completion: @escaping (ServiceResponse) -> ()) {
        service.searchProducts(search: search, page: page, itemsPerPage: itemsPerPage ) {
            switch $0 {
            case .successSearch(let data):
                completion(.successSearch(data: data))
            case .timeOut:
                completion(.timeOut)
            case .notConnectedToInternet:
                completion(.notConnectedToInternet)
            case .failure:
                completion(.failure)
            default:
                break
            }
        }
    }
}
