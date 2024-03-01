//
//  Data.swift
//  Assignment
//
//  Created by bleak on 29/02/24.
//

import Foundation

extension CryptocurrencyViewModel {
    struct Cryptocurrency: Codable {
        let name: String
        let symbol: String
        let isNew: Bool
        let isActive: Bool
        let type: String
        
        enum CodingKeys: String, CodingKey {
            case name
            case symbol
            case isNew = "is_new"
            case isActive = "is_active"
            case type
        }
    }
    
    struct CryptocurrencyData: Codable {
        let cryptocurrencies: [Cryptocurrency]
    }
}

