//
//  SearchViewModel.swift
//  products
//
//  Created by effit on 3/20/20.
//  Copyright © 2020 liverpool. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


final class SearchViewModel {
    private let locator: UseCaseLocatorProtocol
    var searchValue = BehaviorRelay<String?>(value: nil)
    var errorMessage: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var searchData: BehaviorRelay<[SearchData]> =  BehaviorRelay(value: [])
    var historyData: BehaviorRelay<[HistoryEntitie]> =  BehaviorRelay(value: [])
    var page = 1
    let size = 10
    var loadMore: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    init( locator: UseCaseLocatorProtocol) {
        self.locator = locator
    }
    
     func onShowSearch(){
        guard let searchUseCase = locator.getUseCase(ofType: SearchProtocol.self) else {
                        return
                    }
        let histories = searchUseCase.getHistory()
        historyData.accept(histories)
    }
    
    func searchProducts(refresh: Bool  = false, search: String = "" ){
       guard let searchUseCase = locator.getUseCase(ofType: SearchProtocol.self) else {
                  return
              }
        
        if refresh {
            page = 1
            searchData.accept([])
            searchValue.accept(search)
            let history = HistoryEntitie()
            history.name = searchValue.value ?? ""
            searchUseCase.addHistorySearch(history: history)
            
        }
        loadMore.accept(false)
       
       
        
        if let searchValue = searchValue.value {
            searchUseCase.searchProducts(search: searchValue, page: page, itemsPerPage: size ){[weak self] result in
                self?.didFinish(result: result)
                
            }
        }
    }
}

extension SearchViewModel {
    func didFinish(result: ServiceResponse) {
        isLoading.accept(false)
        loadMore.accept(true)
        switch result {
        case .successSearch(let data):
            if page == 1 {
                self.searchData.accept(data)
            } else {
                var currentData =  self.searchData.value
                currentData.append(contentsOf: data)
                self.searchData.accept(currentData)
            }
            if data.count != 0 {
                page += 1
            }
            break
        case .failure:
            errorMessage.accept("Error el conectar")
            break
        case .timeOut:
            errorMessage.accept("Error el conectar")
        case .notConnectedToInternet:
            errorMessage.accept("Error el conectar")
        default:
            errorMessage.accept("Error el conectar")
        }
    }
}
