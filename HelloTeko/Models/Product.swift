//
//  Product.swift
//  HelloTeko
//
//  Created by thien on 3/27/21.
//  Copyright © 2021 thiennq. All rights reserved.
//

import Foundation

struct Product: Codable {
    let id: Int
    let name: String
    let imageURL: String
    let dateAdded, dateUpdated: String
    let price: Float
    let brand, code: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageURL = "imageUrl"
        case dateAdded, dateUpdated, price, brand, code
    }
}

extension Product: Equatable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }       
}
extension Product: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
