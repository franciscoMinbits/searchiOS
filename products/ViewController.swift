//
//  ViewController.swift
//  products
//
//  Created by effit on 3/20/20.
//  Copyright © 2020 liverpool. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class ViewController: BaseViewController, UITextFieldDelegate {
    private let searchViewModel = SearchViewModel(locator: UseCaseLocator.defaultLocator)
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var historyTableView: UITableView!
    @IBOutlet var historySearchView: UIView!
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        configureUI()
        configureBinding()
        
    }
}

extension ViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentSize = scrollView.contentSize.height
        let contentOffset = scrollView.contentOffset.y
        let difference = (contentSize - scrollView.frame.height) - contentOffset
        if difference < -20 &&  self.searchViewModel.searchData.value.count >= self.searchViewModel.size {
            if self.searchViewModel.loadMore.value && historySearchView.isHidden  {
                self.searchViewModel.searchProducts()
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func configureUI() {
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        //view.addGestureRecognizer(tap)
        searchBar.searchTextField.autocapitalizationType = .none
        tableView.delegate = self
        
    }
    
    func configureBinding() {
        searchViewModel.searchData
            .asObservable()
            .bind { searchData in
                self.tableView.reloadData()
        }.disposed(by: disposeBag)
        
        
        
        searchViewModel.historyData
            .asObservable()
            .bind { historyData in
                if historyData.count > 0 {
                    self.historyTableView.reloadData()
                }
        }.disposed(by: disposeBag)
        
        self.searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { () in
                self.historySearchView.isHidden = true
                self.searchBar.showsCancelButton = false
                self.searchBar.resignFirstResponder()
                self.searchBar.text = ""
                self.searchBar.showsCancelButton = false
                
            })
            .disposed(by: self.disposeBag)
        
        self.searchBar.rx.textDidEndEditing
            .subscribe(onNext: { () in
                self.historySearchView.isHidden = true
                self.searchBar.resignFirstResponder()
            })
            .disposed(by: self.disposeBag)
        
        self.searchBar.rx.textDidBeginEditing
            .subscribe(onNext: { () in
                self.historySearchView.isHidden = false
                self.searchBar.showsCancelButton = true
                self.searchViewModel.onShowSearch()
                
            })
            .disposed(by: self.disposeBag)
        
        self.searchBar.rx.searchButtonClicked
            .subscribe(onNext: { () in
                self.searchBar.resignFirstResponder()
                self.historySearchView.isHidden = true
                if let searchText = self.searchBar.text {
                    self.searchViewModel.searchProducts(refresh: true, search: searchText)
                }
            })
            .disposed(by: self.disposeBag)
        
        historyTableView.rx.itemSelected.subscribe({ IndexPath in
          if let element = IndexPath.element {
            let item  = self.searchViewModel.historyData.value[element.row]
            self.searchBar.text = item.name
          }
          
          
        }).disposed(by: disposeBag)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == self.tableView {
            return 120
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
            
            let item  = searchViewModel.searchData.value[indexPath.row]
            cell.selectionStyle = .none
            cell.titleLabel.text = item.productDisplayName
            cell.priceLabel.text = "\(item.listPrice)"
            if let url = URL(string: item.smImage) {
                cell.itemImage.kf.setImage(with: url)
            }
            
            return cell
          } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
            let item  = searchViewModel.historyData.value[indexPath.row]
            cell.selectionStyle = .none
            cell.titleLabel.text = item.name
            return cell
        }
        
    }
    
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          if tableView == self.tableView {
             return searchViewModel.searchData.value.count
          }else {
            return searchViewModel.historyData.value.count
        }
    }
}
