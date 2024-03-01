//
//  DataViewModel.swift
//  Assignment
//
//  Created by bleak on 29/02/24.
//

import Foundation

class CryptocurrencyViewModel {
    var cryptocurrencyData: CryptocurrencyData?
    var onDataUpdate: (() -> Void)?
    
    func fetchData() {
        guard let url = URL(string: "https://run.mocky.io/v3/ac7d7699-a7f7-488b-9386-90d1a60c4a4b") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error ?? NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"]))")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let cryptocurrencyData = try decoder.decode(CryptocurrencyData.self, from: data)
                self?.cryptocurrencyData = cryptocurrencyData
                self?.onDataUpdate?()
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}
