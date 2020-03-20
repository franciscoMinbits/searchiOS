//
//  SearchData.swift
//  products
//
//  Created by effit on 3/20/20.
//  Copyright © 2020 liverpool. All rights reserved.
//

import Foundation
import Foundation
import ObjectMapper

class SearchData:  Mappable {
    required convenience init?(map _: Map) {
        self.init()
    }
    
    @objc dynamic var productId = ""
    @objc dynamic var productDisplayName = ""
    @objc dynamic var smImage = ""
    @objc dynamic var listPrice = 0.0
    
    func mapping(map: Map) {
        productId <- map["productId"]
        productDisplayName <- map["productDisplayName"]
        smImage <- map["smImage"]
        listPrice <- map["listPrice"]
    }
}
