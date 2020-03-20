//
//  BaseViewController.swift
//  products
//
//  Created by effit on 3/20/20.
//  Copyright © 2020 liverpool. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
class BaseViewController: UIViewController {
    private(set) var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
