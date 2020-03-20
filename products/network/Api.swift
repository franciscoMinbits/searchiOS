//
//  Api.swift
//  products
//
//  Created by effit on 3/20/20.
//  Copyright © 2020 liverpool. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    case searchProducts(search: String, page: Int, itemsPerPage: Int)
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case  .searchProducts:
            return .get
        }
    }
    
    var path: String! {
        switch self {
        case .searchProducts(let search, let page, let itemsPerPage):
            return "appclienteservices/services/v3/plp?force-plp=true&search-string=\(search)&page-number=\(page)&number-of-items-per-page=\(itemsPerPage)"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let _path = path.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let completeURL = "https://shoppapp.liverpool.com.mx/"
        let baseUrl = URL(string: completeURL)!
        let _URL = URL(string: _path!, relativeTo: baseUrl)!
        var mutableURLRequest = URLRequest(url: _URL)
        mutableURLRequest.timeoutInterval = 10
        mutableURLRequest.httpMethod = method.rawValue
        print(_URL.absoluteString)
        switch self {
        case .searchProducts:
            return try Alamofire.JSONEncoding().encode(mutableURLRequest, with: nil)
        }
    }
}
