//
//  GwentCard.swift
//  CardsGame
//
//  Created by Vadim Kandaurov on 04/07/2024.
//

/**
 This class represents the data of the card
 */
class GwentCard: Decodable, CustomStringConvertible {
    let name: String // Name of the character
    let fileName: String // Name of the file with the image
    let power: Int // The power of the card
    init(name: String, fileName: String, power: Int) {
        self.name = name
        self.fileName = fileName
        self.power = power
    }
    
    // Custom description to print meaningful information
    var description: String {
        return "\(name) - File: \(fileName) - Power: \(power)"
    }
}
