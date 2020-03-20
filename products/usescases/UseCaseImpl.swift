//
//  UseCaseImpl.swift
//  products
//
//  Created by effit on 3/20/20.
//  Copyright © 2020 liverpool. All rights reserved.
//

import Foundation


class UseCaseImpl {
    let service: ServiceProtocol
    required init(service: ServiceProtocol) {
        self.service = service
    }
}
