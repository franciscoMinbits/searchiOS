//
//  SearchProtocol.swift
//  products
//
//  Created by effit on 3/20/20.
//  Copyright © 2020 liverpool. All rights reserved.
//

import Foundation

protocol SearchProtocol {
    func searchProducts(search: String, page: Int, itemsPerPage: Int, completion: @escaping (ServiceResponse) -> Void)
    func addHistorySearch(history: HistoryEntitie)
    func getHistory() -> [HistoryEntitie] 
}
