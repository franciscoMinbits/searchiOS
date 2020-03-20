//
//  ParseUtils.swift
//  products
//
//  Created by effit on 3/20/20.
//  Copyright © 2020 liverpool. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

class ParseUtils {
    
    static func parseSearchData(data: NSDictionary) ->[SearchData]?{
        let json = JSON(data)
        if let lstResponse = json["plpResults"]["records"].rawString() {
            print("JSON: \(lstResponse)")
            if  let searchData = Mapper<SearchData>().mapArray(JSONString: lstResponse) {
                return searchData
            }
        }
        return nil
    }
}
