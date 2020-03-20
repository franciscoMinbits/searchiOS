//
//  HistoryEntitie.swift
//  products
//
//  Created by effit on 3/20/20.
//  Copyright © 2020 liverpool. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class HistoryEntitie: Object, Mappable {
    required convenience init?(map _: Map) {
        self.init()
    }
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
       
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
