//
//  ServiceImp.swift
//  products
//
//  Created by effit on 3/20/20.
//  Copyright © 2020 liverpool. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import SwiftyJSON
import RealmSwift

class ServiceImp: ServiceProtocol {
    init() {
         
         
         
             
     }
    struct ErrorHttpCode {
        static var OkCode = 200
        static var Invalid = 404
        static var Other = 409
        static var unauthorized = 401
    }
    
    struct ParseType {
        static var searchProducts = 1
    }
    
    func searchProducts(search: String, page: Int, itemsPerPage: Int, completion: @escaping (ServiceResponse) -> Void) {
        AF.request(Router.searchProducts(search: search, page: page,itemsPerPage: itemsPerPage )).responseJSON { response in
            self.parseResponse(response: response,parseType: ParseType.searchProducts, completion: completion)
        }
    }
    
    
    func parseResponse(response : AFDataResponse<Any> , parseType: Int , completion: @escaping (ServiceResponse) -> Void)  {
        switch response.result {
        case .success(let value):
            guard let urlResponse = response.response else {
                completion(.failure)
                return
            }
            switch urlResponse.statusCode {
            case ErrorHttpCode.OkCode:
                if let json = value as? NSDictionary {
                    switch parseType {
                    case ParseType.searchProducts:
                        if let data = ParseUtils.parseSearchData(data: json) {
                            completion(.successSearch(data: data))
                        } else {
                            completion(.failure)
                        }
                        break
                        
                    default:
                        completion(.failure)
                        break
                    }
                }
                break
            case ErrorHttpCode.Invalid, ErrorHttpCode.Other  :
                completion(.failure)
                break
            case NSURLErrorTimedOut:
                completion(.timeOut)
            case NSURLErrorNotConnectedToInternet:
                completion(.notConnectedToInternet)
            case ErrorHttpCode.unauthorized:
                completion(.unauthorized)
            default:
                completion(.failure)
            }
            
        case .failure(let error):
            if let error = error as NSError?{
                print("Response Error Code \(error.code)")
                switch error.code {
                case NSURLErrorNotConnectedToInternet:
                    completion(.notConnectedToInternet)
                    break
                case NSURLErrorTimedOut:
                    completion(.timeOut)
                case NSURLErrorUserAuthenticationRequired:
                    completion(.unauthorized)
                case ErrorHttpCode.Other:
                    completion(.failure)
                default:
                    completion(.failure)
                }
            } else {
                completion(.failure)
            }
        }
    }
    
    lazy var database:Realm = {
           return try! Realm()
       }()
       
       func addHistorySearch(history: HistoryEntitie) {
           try! database.write {
            history.id = getHistory().count + 1
            database.add(history)
           }
       }
       
       func getHistory() -> [HistoryEntitie] {
        let results: Results<HistoryEntitie> = database.objects(HistoryEntitie.self).sorted(byKeyPath: "id", ascending: false)
           return Array(results)
       }
}
