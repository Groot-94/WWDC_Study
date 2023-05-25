//
//  Sandwich.swift
//  Sandwiches
//
//  Created by 전민수 on 2023/05/23.
//

import Foundation

struct Sandwich: Identifiable {
    var id = UUID()
    var name: String
    var ingredientCount: Int
    var isSpicy: Bool = false

    var imageName: String { return "Sandwich" }
    var thumbnailName: String { return name + "Thumb" }
}

let testData = [
    Sandwich(name: "Club", ingredientCount: 4, isSpicy: false),
    Sandwich(name: "Pastrami on rye", ingredientCount: 4, isSpicy: true),
    Sandwich(name: "French dip", ingredientCount: 3, isSpicy: false),
    Sandwich(name: "Banh mi", ingredientCount: 5, isSpicy: true),
    Sandwich(name: "Ice cream sandwich", ingredientCount: 2, isSpicy: false),
    Sandwich(name: "Croque madame", ingredientCount: 4, isSpicy: false),
    Sandwich(name: "Hot dog", ingredientCount: 2, isSpicy: true),
    Sandwich(name: "Fluffernutter", ingredientCount: 2, isSpicy: false),
    Sandwich(name: "Avocado toast", ingredientCount: 3, isSpicy: true),
    Sandwich(name: "Gua bao", ingredientCount: 4, isSpicy: true)
]
