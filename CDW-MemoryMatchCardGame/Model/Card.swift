//
//  Card.swift
//  CDW-MemoryMatchCardGame
//
//  Created by Ikmal Azman on 20/05/2023.
//

import Foundation

struct Card {
    
    init(cardName : String = "", cardLabel : String = "") {
        self.cardName = cardName
        self.cardLabel = cardLabel
    }
    
    var cardName : String
    var cardLabel : String
    var isFlipped : Bool = false
    var isMatched : Bool = false
}
