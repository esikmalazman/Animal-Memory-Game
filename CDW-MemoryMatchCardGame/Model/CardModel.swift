//
//  CardModel.swift
//  CDW-MemoryMatchCardGame
//
//  Created by Ikmal Azman on 20/05/2023.
//

import Foundation

final class CardModel {
    
    func getCards() -> [Card] {
        // Array to store generated cards
        var generatedCardsArray = [Card]()
        
        // Randomly generate pairs of cards, in this case we do 8 pairs so we loop 8 times
        for _ in 1...8 {
            // Generate random numbers
            let randomNumbers = Int.random(in: 1...13)
            print(randomNumbers)
            
            // Create 2 same card object because we need pair of card to match in the game
            let cardOne = Card()
            cardOne.cardName = "card\(randomNumbers)"
            generatedCardsArray.append(cardOne)
            
            let cardTwo = Card()
            cardTwo.cardName = "card\(randomNumbers)"
            generatedCardsArray.append(cardTwo)
            
            // OPTIONAL : Verify only unique pairs of card generated, to avoid same pairs of card being generated
        }
        
        // TODO : Randomize the array
        
        return generatedCardsArray
    }
}
