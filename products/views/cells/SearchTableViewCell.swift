//
//  SearchTableViewCell.swift
//  products
//
//  Created by effit on 3/20/20.
//  Copyright © 2020 liverpool. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
