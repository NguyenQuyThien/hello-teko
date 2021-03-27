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
    let price: Double
    let brand, code: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageURL = "imageUrl"
        case dateAdded, dateUpdated, price, brand, code
    }
}
