//
//  ViewController.swift
//  Assignment
//
//  Created by bleak on 29/02/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cryptoSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!    
    @IBOutlet weak var filterCollectionView: UICollectionView!
    var viewModel = CryptocurrencyViewModel()
    var filterViewModel : [CryptocurrencyViewModel.Cryptocurrency] = []
    var filters: [BottomFilterDataModel] = [BottomFilterDataModel(name: "Active Coins",isSelected: false),BottomFilterDataModel(name: "Inactive Coins", isSelected: false) ,BottomFilterDataModel(name: "Only Tokens", isSelected: false),BottomFilterDataModel(name: "New Coins", isSelected: false),BottomFilterDataModel(name: "Only Coins", isSelected: false) ]
    var selectedFilterIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.tableView.rowHeight = 55.0
        
        // Set the collection view's data source and delegate
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        
        // Set the search bar's delegate
        cryptoSearchBar.delegate = self
        
        // Set the table view's data source
        tableView.dataSource = self
        
        // Register the cell for reuse
        tableView.register(CryptocurrencyTableViewCell.nib(), forCellReuseIdentifier: CryptocurrencyTableViewCell.identifier)
        
        // Fetch data
        viewModel.onDataUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.fetchData()
        filterCollectionView.backgroundColor = .darkGray
    }
    
    func filterContent(searchText: String) {
        if searchText == "" {
            filterViewModel = []
            tableView.reloadData()
        } else {
            filterViewModel = viewModel.cryptocurrencyData?.cryptocurrencies.filter({ (filterViewModel:CryptocurrencyViewModel.Cryptocurrency) -> Bool in
                let nameMatch = filterViewModel.name.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                let symbolMatch = filterViewModel.symbol.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return nameMatch != nil || symbolMatch != nil }
            ) ?? []
            if !filterViewModel.isEmpty {
                tableView.reloadData()
            }
        }
    }
    
    func applyFilter(_ index: Int) {
        switch index {
        case 0:
            filterViewModel = viewModel.cryptocurrencyData?.cryptocurrencies.filter({ (filterViewModel:CryptocurrencyViewModel.Cryptocurrency) -> Bool in
                return filterViewModel.isActive && filterViewModel.type == "coin"
            }
            ) ?? []
            if !filterViewModel.isEmpty {
                tableView.reloadData()
            }
        case 1:
            filterViewModel = viewModel.cryptocurrencyData?.cryptocurrencies.filter({ (filterViewModel:CryptocurrencyViewModel.Cryptocurrency) -> Bool in
                return !filterViewModel.isActive
            }
            ) ?? []
            if !filterViewModel.isEmpty {
                tableView.reloadData()
            }
        case 2:
            filterViewModel = viewModel.cryptocurrencyData?.cryptocurrencies.filter({ (filterViewModel:CryptocurrencyViewModel.Cryptocurrency) -> Bool in
                return filterViewModel.type == "token"
            }
            ) ?? []
            if !filterViewModel.isEmpty {
                tableView.reloadData()
            }
        case 3:
            filterViewModel = viewModel.cryptocurrencyData?.cryptocurrencies.filter({ (filterViewModel:CryptocurrencyViewModel.Cryptocurrency) -> Bool in
                return filterViewModel.isNew
            }
            ) ?? []
            if !filterViewModel.isEmpty {
                tableView.reloadData()
            }
        case 4:
            filterViewModel = viewModel.cryptocurrencyData?.cryptocurrencies.filter({ (filterViewModel:CryptocurrencyViewModel.Cryptocurrency) -> Bool in
                return filterViewModel.type == "coin" && filterViewModel.isActive
            }
            ) ?? []
            if !filterViewModel.isEmpty {
                tableView.reloadData()
            }
        default:
            print("no code")
        }
    }
}

extension ViewController: UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterViewModel.isEmpty {
            return viewModel.cryptocurrencyData?.cryptocurrencies.count ?? 0
        } else {
            return filterViewModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CryptocurrencyTableViewCell.identifier, for: indexPath) as? CryptocurrencyTableViewCell 
        
        if filterViewModel.isEmpty {
            if let cryptocurrency = viewModel.cryptocurrencyData?.cryptocurrencies[indexPath.row] {
                // Configure the cell
                cell?.configureUI(data: cryptocurrency)
            }
        } else {
            cell?.configureUI(data: filterViewModel[indexPath.row])
        }
    
        return cell ?? UITableViewCell()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContent(searchText: searchText)
        }
    }
    
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: [indexPath.row]) as! FilterCollectionViewCell
        cell.configureUI(data: filters[indexPath.row])
        cell.filterLabel.text = filters[indexPath.row].name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = filters[indexPath.row].name.width(withConstrainedHeight: 30, font: .systemFont(ofSize: 22.0))
        if filters[indexPath.row].isSelected {
            width = width + 20.0
        }
        return CGSize(width: width, height: 40)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedFilterIndex = indexPath.item
        if filters[indexPath.row].isSelected == true {
            filters[indexPath.row].isSelected = false
            filterViewModel = []
            tableView.reloadData()
        } else {
            filters[indexPath.row].isSelected = true
            applyFilter(selectedFilterIndex)
        }
        collectionView.reloadData()
    }
}
